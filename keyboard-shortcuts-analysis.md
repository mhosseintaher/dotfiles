# Comprehensive Keyboard Shortcuts Analysis

This document analyzes all keyboard shortcuts across your dotfiles configuration to identify potential collisions and provide an organized overview.

## Applications Analyzed

1. **Neovim** - From existing keybinds markdown
2. **Vim** - `.vimrc` configuration  
3. **Zed Editor** - `keymap.json` configuration
4. **tmux** - `tmux.conf` configuration
5. **AeroSpace** - `aerospace.toml` configuration
6. **Karabiner** - `karabiner.json` configuration
7. **Superfile** - `hotkeys.toml` configuration

## 🔥 Major Collision Analysis

### ❌ **Critical Conflicts**

| Shortcut | Application 1 | Action 1 | Application 2 | Action 2 | Severity |
|----------|---------------|----------|---------------|----------|----------|
| `Ctrl+C` | **Neovim** | Escape | **Zed** | Cancel/Escape | 🟡 **Low** (Same purpose) |
| `Ctrl+H/J/K/L` | **Neovim** | Window navigation | **Zed** | Pane navigation | 🟡 **Low** (Same purpose) |
| `Ctrl+H/J/K/L` | **tmux** | Pane navigation | **Neovim/Zed** | Window/Pane nav | 🟡 **Low** (Same purpose) |
| `Alt+H/J/K/L` | **AeroSpace** | Focus windows | **AeroSpace** | Move windows (Shift) | 🟢 **None** (Related) |
| `Ctrl+F` | **Neovim** | tmux-sessionizer | **Superfile** | Toggle footer | 🔴 **High** |
| `Space` | **Neovim** | Leader key | **AeroSpace** | None | 🟢 **None** |
| `Caps Lock` | **Karabiner** | Hyper key | **System** | Caps Lock | 🟡 **Low** (Remapped) |

### ⚠️ **Potential Conflicts**

| Shortcut | Application 1 | Action 1 | Application 2 | Action 2 | Context |
|----------|---------------|----------|---------------|----------|---------|
| `Alt+1/2/3` | **AeroSpace** | Workspace 1/2/3 | **Karabiner** | Apps | Different purpose |
| `Alt+Tab` | **AeroSpace** | Workspace back/forth | **System** | App switcher | AeroSpace overrides |
| `Ctrl+E` | **Zed** | Tab switcher | **Superfile** | Extract file | Different apps |
| `J/K` | **Superfile** | List up/down | **Neovim** | Down/Up | Different contexts |

---

## 📋 Complete Shortcut Inventory

### **🎯 Neovim Shortcuts**
*From existing analysis - 100+ keybinds already documented*

**Key Leaders:** `Space` (primary), conflicts already identified in your nvim markdown

---

### **⚡ Vim (.vimrc) Shortcuts**

| Shortcut | Mode | Action |
|----------|------|--------|
| `jj` | Insert | Escape to normal mode |
| `:au FocusLost *` | Auto | Save all buffers on focus lost |

---

### **🖊️ Zed Editor Shortcuts**

| Shortcut | Context | Action |
|----------|---------|--------|
| `Ctrl+E H` | Global | Tab switcher toggle |
| `Space P F` | Global | File finder toggle |
| `Space P S` | Global | Deploy search |
| `Ctrl+O P` | Global | Open recent projects |
| `Space E E` | Global | Toggle right dock |
| `Ctrl+W Z` | Editor | Toggle zoom |
| `Ctrl+H` | Insert | Show signature help |
| `Ctrl+^` | Normal | Alternate file |
| `Ctrl+W F` | Normal | New center terminal |
| `Shift+K` | Normal | Hover |
| `Ctrl+C` | Normal | Cancel |
| `Ctrl+H/L/K/J` | Normal | Activate pane direction |
| `=` | Visual | Format |
| `Shift+J/K` | Visual | Move line up/down |
| `G ]` | Normal/Visual | Go to diagnostic |
| `G [` | Normal/Visual | Go to prev diagnostic |
| `G R` | Normal/Visual | Find all references |
| `Space V C A` | Normal/Visual | Toggle code actions |
| `Space M P` | Normal/Visual | Format |
| `Space V` | Normal/Visual | Go to definition split |
| `Space R N` | Normal/Visual | Rename |
| `Space G D` | Normal/Visual | Toggle hunk diff |
| `Space T I` | Normal/Visual | Toggle inlay hints |
| `Space C Z` | Normal/Visual | Toggle centered layout |
| `Space M P` | Normal/Visual | Markdown preview to side |
| `Space F P` | Normal/Visual | Open recent project |
| `G F` | Normal/Visual | Open excerpts |
| `Ctrl+J/K` | Editor | Menu select next/prev |

**File Explorer (ProjectPanel):**
| Shortcut | Action |
|----------|--------|
| `A` | New file |
| `Shift+A` | New directory |
| `R` | Rename |
| `D` | Delete |
| `X` | Cut |
| `C` | Copy |
| `P` | Paste |
| `Q` | Close panel |
| `Ctrl+H/L/K/J` | Move to pane |

**Terminal:**
| Shortcut | Action |
|----------|--------|
| `Ctrl+H/L/K/J` | Activate pane direction |
| `Ctrl+W F` | New center terminal |

---

### **🧮 tmux Shortcuts**

| Shortcut | Action |
|----------|--------|
| `Ctrl+B` | Prefix key |
| `R` | Reload config |
| `\|` | Split horizontal |
| `-` | Split vertical |
| `V` | Copy mode |
| `F` | tmux-sessionizer |
| `J/K/L/H` | Resize pane (with prefix) |
| `M` | Maximize pane |
| `O` | sessionx plugin |
| `N` | New session prompt |

**Copy Mode:**
| Shortcut | Action |
|----------|--------|
| `V` | Begin selection |
| `Y` | Copy selection |

---

### **🚀 AeroSpace Shortcuts**

**Window Management:**
| Shortcut | Action |
|----------|--------|
| `Alt+H/J/K/L` | Focus left/down/up/right |
| `Alt+Shift+H/J/K/L` | Move left/down/up/right |
| `Alt+/` | Layout tiles |
| `Alt+,` | Layout accordion |
| `Alt+Tab` | Workspace back-and-forth |
| `Alt+Shift+Tab` | Move workspace to monitor |

**Workspaces:**
| Shortcut | Workspace | Purpose |
|----------|-----------|---------|
| `Alt+1/2/3` | 1/2/3 | Numbered |
| `Alt+B` | B | Browser |
| `Alt+C` | C | Cursor |
| `Alt+D` | D | Database |
| `Alt+E` | E | TickTick |
| `Alt+F` | F | Finder |
| `Alt+M` | M | Messages |
| `Alt+N` | N | Notes |
| `Alt+P` | P | Calendar |
| `Alt+I` | I | ClickUp |
| `Alt+T` | T | Terminal |
| `Alt+X` | X | VSCode |

**Move to Workspace (with Shift):**
All above with `Alt+Shift+<key>` to move windows

**Modes:**
| Shortcut | Mode/Action |
|----------|-------------|
| `Alt+Shift+;` | Service mode |
| `Alt+Shift+R` | Resize mode |
| `Alt+Shift+-/=` | Resize smart |

**Resize Mode:**
| Shortcut | Action |
|----------|--------|
| `H/J/K/L` | Resize width/height |
| `B` | Balance sizes |
| `Enter/Esc` | Exit mode |

**Service Mode:**
| Shortcut | Action |
|----------|--------|
| `Esc` | Reload config |
| `R` | Reset layout |
| `F` | Toggle floating |
| `Backspace` | Close all but current |
| `Alt+Shift+H/J/K/L` | Join with direction |

---

### **⚡ Karabiner Shortcuts (Hyper Key System)**

**Base Hyper Key:** `Caps Lock` → Hyper when held, Escape when tapped

**Direct Hyper Shortcuts:**
| Shortcut | Action |
|----------|--------|
| `Hyper+T` | Open Ghostty |
| `Hyper+B` | Open Zen Browser |
| `Hyper+F` | Open Finder |
| `Hyper+1` | Open DaVinci Resolve |
| `Hyper+2` | Open OBS Studio |

**Hyper+O Sublayer (Open Apps):**
| Shortcut | App |
|----------|-----|
| `Hyper+O M` | Obsidian |
| `Hyper+O N` | Notion |
| `Hyper+O D` | Discord |
| `Hyper+O I` | Messages |
| `Hyper+O P` | Music |
| `Hyper+O V` | Visual Studio Code |
| `Hyper+O C` | Google Chrome |
| `Hyper+O W` | WezTerm |

**Hyper+W Sublayer (Window Management via Raycast):**
| Shortcut | Action |
|----------|--------|
| `Hyper+W Y` | Previous desktop |
| `Hyper+W O` | Next desktop |
| `Hyper+W K` | Top half |
| `Hyper+W J` | Bottom half |
| `Hyper+W H` | Left half |
| `Hyper+W L` | Right half |
| `Hyper+W Enter` | Maximize |
| `Hyper+W M` | Focus next window |
| `Hyper+W ;` | Hide window |
| `Hyper+W U` | Previous tab |
| `Hyper+W I` | Next tab |
| `Hyper+W N` | Next window |
| `Hyper+W B` | Back |
| `Hyper+W F` | Forward |
| `Hyper+W D` | Next display |

**Hyper+S Sublayer (System Controls):**
| Shortcut | Action |
|----------|--------|
| `Hyper+S U` | Volume up |
| `Hyper+S J` | Volume down |
| `Hyper+S I` | Brightness up |
| `Hyper+S K` | Brightness down |
| `Hyper+S L` | Lock screen |
| `Hyper+S P` | Play/pause |
| `Hyper+S ;` | Fast forward |
| `Hyper+S D` | Do not disturb |
| `Hyper+S T` | Toggle appearance |
| `Hyper+S C` | Open camera |

**Hyper+V Sublayer (Vim Navigation):**
| Shortcut | Action |
|----------|--------|
| `Hyper+V H/J/K/L` | Arrow keys |
| `Hyper+V S` | Ctrl+J |
| `Hyper+V D` | Cmd+Shift+D |
| `Hyper+V U` | Page down |
| `Hyper+V I` | Page up |

**Hyper+C Sublayer (Media Controls):**
| Shortcut | Action |
|----------|--------|
| `Hyper+C P` | Play/pause |
| `Hyper+C N` | Next track |
| `Hyper+C B` | Previous track |

**Hyper+R Sublayer (Raycast Extensions):**
| Shortcut | Action |
|----------|--------|
| `Hyper+R 1` | Connect Bluetooth device 1 |
| `Hyper+R 2` | Connect Bluetooth device 2 |
| `Hyper+R C` | Color picker |
| `Hyper+R N` | Raycast notes |
| `Hyper+R E` | Emoji search |
| `Hyper+R P` | Confetti |
| `Hyper+R H` | Clipboard history |

**Hyper+P Sublayer (Project/File Search):**
| Shortcut | Action |
|----------|--------|
| `Hyper+P S` | Search files |
| `Hyper+P F` | Folder search |

**Hyper+M Sublayer (Management):**
| Shortcut | Action |
|----------|--------|
| `Hyper+M F` | File manager |

---

### **📁 Superfile Shortcuts**

**Global Navigation:**
| Shortcut | Action |
|----------|--------|
| `Enter` | Confirm |
| `Ctrl+C` | Quit |
| `K/J` | List up/down |
| `PgUp/PgDown` | Page up/down |
| `N` | New file panel |
| `Q` | Close file panel |
| `Tab/Shift+Tab` | Next/prev panel |
| `F` | Toggle preview |
| `O` | Sort options |
| `R` | Reverse sort |

**Focus Control:**
| Shortcut | Action |
|----------|--------|
| `Ctrl+P` | Process bar |
| `Ctrl+S` | Sidebar |
| `Ctrl+D` | Metadata |

**File Operations:**
| Shortcut | Action |
|----------|--------|
| `A` | Create file/directory |
| `R` | Rename |
| `Y` | Copy |
| `X` | Cut |
| `P` | Paste |
| `D` | Delete |

**Advanced Operations:**
| Shortcut | Action |
|----------|--------|
| `Ctrl+E` | Extract file |
| `Ctrl+A` | Compress file |
| `E` | Open with editor |
| `Shift+E` | Open directory with editor |

**Other:**
| Shortcut | Action |
|----------|--------|
| `Shift+P` | Pin directory |
| `.` | Toggle dot files |
| `M` | Change panel mode |
| `?` | Help menu |
| `:` | Command line |
| `Shift+Y` | Copy path |
| `C` | Copy PWD |
| `Ctrl+F` | Toggle footer |

**Normal Mode:**
| Shortcut | Action |
|----------|--------|
| `-` | Parent directory |
| `/` | Search bar |

**Select Mode:**
| Shortcut | Action |
|----------|--------|
| `Shift+J/K` | Select up/down |
| `Shift+A` | Select all |

---

## 🎯 Collision Resolution Recommendations

### **High Priority Fixes**

1. **`Ctrl+F` Conflict:**
   - **Neovim:** tmux-sessionizer 
   - **Superfile:** Toggle footer
   - **Solution:** Change Superfile to `Ctrl+Shift+F` or `Alt+F`

2. **Modal Context Separation:**
   - Most conflicts are context-separated (different apps)
   - Vim/Neovim conflicts are already documented in your nvim markdown

### **Medium Priority**

1. **Consider Namespace Consistency:**
   - AeroSpace uses `Alt+` prefix consistently ✅
   - Karabiner uses `Hyper+` prefix consistently ✅
   - Consider `Ctrl+` vs `Cmd+` standardization across editors

### **Low Priority** 

1. **Harmonize Navigation:**
   - `Ctrl+H/J/K/L` is consistently used for navigation across Neovim, Zed, tmux ✅
   - This is actually good consistency

---

## 📊 Summary Statistics

- **Total Applications Analyzed:** 7
- **Total Shortcuts Documented:** 200+
- **Critical Conflicts:** 1 (`Ctrl+F`)
- **Potential Conflicts:** 4
- **Well-Separated Systems:** 6/7 (85%)

**Conflict Severity:**
- 🔴 **High:** 1 conflict
- 🟡 **Medium:** 4 conflicts  
- 🟢 **Low/None:** 195+ shortcuts

## 🏆 Overall Assessment

Your keyboard shortcut system is **very well organized** with excellent separation:

✅ **Strengths:**
- Consistent modal separation (App-specific contexts)
- Logical prefixes (Alt+ for AeroSpace, Hyper+ for Karabiner)
- Vim-style navigation unified across editors
- Comprehensive coverage without major overlaps

⚠️ **Areas for Improvement:**
- One critical conflict to resolve (`Ctrl+F`)
- Consider standardizing some cross-app patterns
- Document tmux-sessionizer shortcuts integration

🎯 **Recommendation:** Focus on fixing the `Ctrl+F` conflict and your setup will be excellent!
