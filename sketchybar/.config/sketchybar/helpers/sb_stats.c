// sb_stats: native CPU / RAM / network provider for SketchyBar.
//
// One small process instead of shell pollers. It never forks: it reads the
// kernel counters directly and sends every changed label to sketchybar in a
// single message over sketchybar's mach port (the same port the `sketchybar`
// CLI uses). Nothing is sent when the formatted values did not change.
//
//   cpu       host_statistics(HOST_CPU_LOAD_INFO) tick deltas
//   memory    Activity Monitor "Memory Used": app (internal - purgeable)
//             + wired + compressed, as % of hw.memsize
//   net_*     64-bit byte counters of the default-route interface
//             (a physical en* one when the default route is a tunnel),
//             timed with mach_absolute_time
//
// Usage: sb_stats [tick_seconds=2] [memory_every_n_ticks=2]
// Exits as soon as sketchybar's port is gone, so it never outlives the bar.
// Built and (re)started by sketchybarrc.

#include <mach/mach.h>
#include <mach/mach_time.h>
#include <servers/bootstrap.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_mib.h>
#include <net/route.h>
#include <netinet/in.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/file.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// ---------------------------------------------------------------- sketchybar

struct sb_message {
  mach_msg_header_t header;
  mach_msg_size_t descriptor_count;
  mach_msg_ool_descriptor_t descriptor;
};

static mach_port_t sb_lookup(void) {
  mach_port_t bs = MACH_PORT_NULL, port = MACH_PORT_NULL;
  if (task_get_special_port(mach_task_self(), TASK_BOOTSTRAP_PORT, &bs) != KERN_SUCCESS)
    return MACH_PORT_NULL;
  const char *bar = getenv("BAR_NAME");
  char name[128];
  snprintf(name, sizeof name, "git.felix.%s", bar && *bar ? bar : "sketchybar");
  if (bootstrap_look_up(bs, name, &port) != KERN_SUCCESS) port = MACH_PORT_NULL;
  mach_port_deallocate(mach_task_self(), bs);
  return port;
}

// The payload is the CLI argv joined with NULs plus a final NUL.
static bool sb_send(mach_port_t port, const char *buf, uint32_t len) {
  if (port == MACH_PORT_NULL) return false;
  struct sb_message msg = {0};
  msg.header.msgh_remote_port = port;
  msg.header.msgh_local_port = MACH_PORT_NULL; // no reply wanted
  msg.header.msgh_bits = MACH_MSGH_BITS_SET(MACH_MSG_TYPE_COPY_SEND, 0, 0, MACH_MSGH_BITS_COMPLEX);
  msg.header.msgh_size = sizeof msg;
  msg.descriptor_count = 1;
  msg.descriptor.address = (void *)buf;
  msg.descriptor.size = len;
  msg.descriptor.copy = MACH_MSG_VIRTUAL_COPY;
  msg.descriptor.deallocate = false;
  msg.descriptor.type = MACH_MSG_OOL_DESCRIPTOR;
  return mach_msg(&msg.header, MACH_SEND_MSG | MACH_SEND_TIMEOUT, sizeof msg, 0,
                  MACH_PORT_NULL, 1000, MACH_PORT_NULL) == MACH_MSG_SUCCESS;
}

struct batch { char data[512]; uint32_t len; };

static void batch_token(struct batch *b, const char *tok) {
  size_t n = strlen(tok) + 1;
  if (b->len + n + 1 > sizeof b->data) return;
  memcpy(b->data + b->len, tok, n);
  b->len += (uint32_t)n;
}

// Queue `--set <item> label=<value>` only when the value changed.
static void batch_label(struct batch *b, const char *item, const char *value, char last[16]) {
  if (strcmp(value, last) == 0) return;
  char prop[32];
  snprintf(prop, sizeof prop, "label=%s", value);
  batch_token(b, "--set");
  batch_token(b, item);
  batch_token(b, prop);
  strlcpy(last, value, 16);
}

// --------------------------------------------------------------------- cpu

static host_t g_host;

// Busy percent since the previous call. cpu_ticks are 32-bit counters that
// wrap, so take per-state deltas in natural_t (wrap-safe), never widened sums.
static bool cpu_percent(int *pct) {
  static natural_t prev[CPU_STATE_MAX];
  host_cpu_load_info_data_t info;
  mach_msg_type_number_t count = HOST_CPU_LOAD_INFO_COUNT;
  if (host_statistics(g_host, HOST_CPU_LOAD_INFO, (host_info_t)&info, &count) != KERN_SUCCESS)
    return false;
  uint32_t d[CPU_STATE_MAX];
  for (int i = 0; i < CPU_STATE_MAX; i++) {
    d[i] = (uint32_t)(info.cpu_ticks[i] - prev[i]);
    prev[i] = info.cpu_ticks[i];
  }
  uint64_t busy = (uint64_t)d[CPU_STATE_USER] + d[CPU_STATE_SYSTEM] + d[CPU_STATE_NICE];
  uint64_t total = busy + d[CPU_STATE_IDLE];
  if (total == 0) return false;
  *pct = (int)((busy * 100 + total / 2) / total);
  return true;
}

// ------------------------------------------------------------------ memory

static uint64_t g_memsize;

static int memory_percent(void) {
  vm_statistics64_data_t vm;
  mach_msg_type_number_t count = HOST_VM_INFO64_COUNT;
  if (!g_memsize || host_statistics64(g_host, HOST_VM_INFO64, (host_info64_t)&vm, &count) != KERN_SUCCESS)
    return -1;
  uint64_t app = vm.internal_page_count > vm.purgeable_count
                     ? (uint64_t)vm.internal_page_count - vm.purgeable_count : 0;
  uint64_t used = (app + vm.wire_count + vm.compressor_page_count) * (uint64_t)vm_kernel_page_size;
  int pct = (int)((used * 100 + g_memsize / 2) / g_memsize);
  return pct > 100 ? 100 : pct;
}

// ----------------------------------------------------------------- network

static bool is_tunnel(const char *name) {
  static const char *prefixes[] = {"utun", "ipsec", "ppp", "tun", "tap", "gif", "stf", "lo", "awdl", "llw"};
  for (size_t i = 0; i < sizeof prefixes / sizeof *prefixes; i++)
    if (strncmp(name, prefixes[i], strlen(prefixes[i])) == 0) return true;
  return false;
}

// Interface index of the IPv4 default route; 0 when there is none.
static unsigned int default_ifindex(void) {
  int mib[6] = {CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_GATEWAY};
  size_t len = 0;
  if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0 || len == 0) return 0;
  len += len / 4; // routes may appear between the two calls
  char *buf = malloc(len);
  if (!buf) return 0;
  if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) { free(buf); return 0; }

  unsigned int primary = 0, physical = 0;
  char primary_name[IF_NAMESIZE] = "";
  for (char *p = buf; p + sizeof(struct rt_msghdr) <= buf + len;) {
    struct rt_msghdr *rtm = (struct rt_msghdr *)p;
    if (rtm->rtm_msglen == 0) break;
    struct sockaddr_in *dst = (struct sockaddr_in *)(rtm + 1);
    if ((rtm->rtm_addrs & RTA_DST) && dst->sin_family == AF_INET &&
        dst->sin_addr.s_addr == INADDR_ANY && rtm->rtm_index) {
      char name[IF_NAMESIZE];
      if (if_indextoname(rtm->rtm_index, name)) {
        if (!primary && !(rtm->rtm_flags & RTF_IFSCOPE)) {
          primary = rtm->rtm_index;
          strlcpy(primary_name, name, sizeof primary_name);
        }
        if (!physical && strncmp(name, "en", 2) == 0) physical = rtm->rtm_index;
      }
    }
    p += rtm->rtm_msglen;
  }
  free(buf);
  if (primary && is_tunnel(primary_name) && physical) return physical;
  return primary ? primary : physical;
}

static bool if_bytes(unsigned int ifindex, uint64_t *in, uint64_t *out) {
  struct ifmibdata data;
  size_t len = sizeof data;
  int mib[6] = {CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_IFDATA, (int)ifindex, IFDATA_GENERAL};
  if (!ifindex || sysctl(mib, 6, &data, &len, NULL, 0) < 0) return false;
  *in = data.ifmd_data.ifi_ibytes;
  *out = data.ifmd_data.ifi_obytes;
  return true;
}

// Same look as the old shell module: three digits plus unit, e.g. 042kB.
static void format_speed(uint64_t bytes_per_sec, char out[16]) {
  static const char *units[] = {"kB", "MB", "GB", "TB"};
  if (bytes_per_sec == 0) { strlcpy(out, "000kB", 16); return; }
  uint64_t value = bytes_per_sec / 1024;
  if (value == 0) value = 1;
  int idx = 0;
  while (value >= 1000 && idx < 3) {
    if (value / 1024 == 0) { value = 999; break; }
    value /= 1024;
    idx++;
  }
  if (value > 999) value = 999;
  snprintf(out, 16, "%03llu%s", (unsigned long long)value, units[idx]);
}

// -------------------------------------------------------------------- main

// One instance per user: sketchybarrc kills the old copy, but two reloads in
// a row (hotload plus --reload) can race. Wait briefly for a dying copy to
// release the lock, otherwise leave the running one alone.
static bool single_instance(void) {
  const char *dir = getenv("TMPDIR");
  char path[1024];
  snprintf(path, sizeof path, "%s/sb_stats.lock", dir && *dir ? dir : "/tmp");
  int fd = open(path, O_RDWR | O_CREAT | O_CLOEXEC, 0600);
  if (fd < 0) return true;
  for (int i = 0; i < 30; i++) {
    if (flock(fd, LOCK_EX | LOCK_NB) == 0) return true; // fd stays open: lock held until exit
    struct timespec wait = {0, 100 * 1000 * 1000};
    nanosleep(&wait, NULL);
  }
  return false;
}

int main(int argc, char **argv) {
  double tick = argc > 1 ? atof(argv[1]) : 2.0;
  int mem_every = argc > 2 ? atoi(argv[2]) : 2;
  if (tick < 0.5) tick = 0.5;
  if (mem_every < 1) mem_every = 1;

  if (!single_instance()) return 0;

  mach_port_t port = sb_lookup();
  if (port == MACH_PORT_NULL) {
    fprintf(stderr, "sb_stats: sketchybar is not running\n");
    return 1;
  }

  g_host = mach_host_self();
  size_t len = sizeof g_memsize;
  sysctlbyname("hw.memsize", &g_memsize, &len, NULL, 0);
  mach_timebase_info_data_t tb;
  mach_timebase_info(&tb);

  char last_cpu[16] = "", last_mem[16] = "", last_down[16] = "", last_up[16] = "";
  uint64_t in0 = 0, out0 = 0, t0 = mach_absolute_time();
  unsigned int ifindex = default_ifindex();
  bool have_net = if_bytes(ifindex, &in0, &out0);
  int cpu_pct;
  cpu_percent(&cpu_pct);  // prime the per-state baseline

  // First sample after 1s so the bar fills in quickly, then every `tick`.
  struct timespec first = {1, 0};
  struct timespec period = {(time_t)tick, (long)((tick - (time_t)tick) * 1e9)};

  for (unsigned long n = 0;; n++) {
    struct timespec rem = n ? period : first;
    while (nanosleep(&rem, &rem) < 0 && errno == EINTR) {}

    struct batch b = {.len = 0};
    char value[16];

    if (cpu_percent(&cpu_pct)) {
      snprintf(value, sizeof value, "%02d%%", cpu_pct > 99 ? 99 : cpu_pct);
      batch_label(&b, "cpu", value, last_cpu);
    }

    if (n % (unsigned long)mem_every == 0) {
      int pct = memory_percent();
      if (pct >= 0) {
        snprintf(value, sizeof value, "%02d%%", pct > 99 ? 99 : pct);
        batch_label(&b, "memory", value, last_mem);
      }
    }

    // Re-resolve the default interface every ~10s, or at once when it vanished.
    if (n % 5 == 4 || !have_net) {
      unsigned int idx = default_ifindex();
      if (idx != ifindex) { ifindex = idx; have_net = false; }
    }
    uint64_t in, out, t = mach_absolute_time();
    if (if_bytes(ifindex, &in, &out)) {
      if (have_net) {
        double secs = (double)(t - t0) * tb.numer / tb.denom / 1e9;
        uint64_t din = in >= in0 ? in - in0 : 0, dout = out >= out0 ? out - out0 : 0;
        if (secs < 0.1) secs = 0.1;
        format_speed((uint64_t)(din / secs + 0.5), value);
        batch_label(&b, "net_down", value, last_down);
        format_speed((uint64_t)(dout / secs + 0.5), value);
        batch_label(&b, "net_up", value, last_up);
      }
      in0 = in; out0 = out; t0 = t; have_net = true;
    } else {
      have_net = false;
      batch_label(&b, "net_down", "-", last_down);
      batch_label(&b, "net_up", "-", last_up);
    }

    if (b.len == 0) continue;
    b.data[b.len++] = '\0';
    if (!sb_send(port, b.data, b.len)) {
      // Port gone: sketchybar quit or restarted (its sketchybarrc starts a
      // fresh sb_stats), so exit instead of lingering as an orphan.
      mach_port_deallocate(mach_task_self(), port);
      port = sb_lookup();
      if (!sb_send(port, b.data, b.len)) return 0;
    }
  }
}
