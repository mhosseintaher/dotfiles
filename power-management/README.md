# Power Management

macOS power/sleep configuration for battery longevity and sensible idle behaviour.

Run `setup.sh` on a fresh Mac to restore all settings:

```bash
chmod +x ~/dotfiles/power-management/setup.sh
~/dotfiles/power-management/setup.sh
```

---

## Sleep Timers (`pmset`)

These are applied via `setup.sh` using `sudo pmset`.

### On Battery

| Setting          | Value | Meaning                                              |
|------------------|-------|------------------------------------------------------|
| `displaysleep`   | 10    | Display turns off after 10 min idle                  |
| `sleep`          | 1     | System sleeps 1 min after display off (~11 min total)|
| `hibernatemode`  | 25    | Safe sleep: RAM written to disk, power fully cut     |
| `powernap`       | 0     | No background activity during sleep                  |
| `ttyskeepawake`  | 0     | Terminal sessions don't prevent sleep                |
| `womp`           | 0     | No wake on network access                            |
| `standby`        | 1     | Standby enabled                                      |

`hibernatemode 25` is the aggressive mode — the Mac behaves like it's off. Wake time is slower but battery is fully preserved.

### On AC (Plugged In)

| Setting          | Value | Meaning                                               |
|------------------|-------|-------------------------------------------------------|
| `displaysleep`   | 30    | Display turns off after 30 min idle                   |
| `sleep`          | 60    | System sleeps 60 min after display off (90 min total) |
| `hibernatemode`  | 3     | Standard sleep: RAM stays powered, fast wake          |
| `powernap`       | 1     | Background activity allowed (mail, backups, etc.)     |
| `ttyskeepawake`  | 1     | Active terminal sessions keep the system awake        |
| `womp`           | 0     | No wake on network access                             |
| `standby`        | 1     | Standby enabled                                       |

`ttyskeepawake 1` on AC means if you have a long-running terminal process, the Mac will stay awake until it finishes.

### Verify current settings

```bash
pmset -g custom
```

---

## Battery Charge Limit (AlDente Pro)

[AlDente Pro](https://apphousekitchen.com) limits how high the battery charges to reduce long-term degradation.

Current configuration (set inside the AlDente app, not via script):

| Setting             | Value | Meaning                                                  |
|---------------------|-------|----------------------------------------------------------|
| Charge limit        | 85%   | Stops charging above 85%                                 |
| Sailing Mode        | On    | Holds battery steady at the limit without yo-yoing       |
| Heat Protect Mode   | On    | Pauses charging when battery temperature exceeds 35°C    |
| MagSafe LED control | On    | MagSafe light reflects AlDente state, not system state   |

AlDente is not configured via a script — restore its settings manually from the app after reinstalling macOS.

---

## Prevent Sleep On Demand (Amphetamine)

[Amphetamine](https://apps.apple.com/app/amphetamine/id937984704) is installed for manual use when you need to temporarily prevent the Mac from sleeping (e.g. during a long download or presentation).

Triggers are disabled — activate sessions manually from the menu bar.

---

## USB Devices and Sleep

External USB devices (hubs, Ergodox EZ keyboard, drives) register a `0x4=USB` kernel assertion with macOS. This is automatic macOS behaviour — not a manual configuration. It can prevent deeper sleep states while those devices are connected.

Check active assertions at any time:

```bash
pmset -g log | tail -30
```
