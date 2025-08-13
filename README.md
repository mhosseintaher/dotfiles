# macOS Dotfiles

These are my personal dotfiles for macOS.

Who this is for:
- Beginners who want a guided, copy‑paste friendly setup
- Anyone who wants a clear explanation of what each tool/command does

What you’ll get after setup:
- A modern terminal environment (Zsh, Starship, fzf, zoxide, tmux, Neovim)
- Consistent configs synced via Git using GNU Stow (symlinks)
- Optional GUI apps via Homebrew Casks

Note: These configs are tailored for my setup and may need adjustments for yours.

---

## 📂 Additional Directories to Back Up

Before resetting your Mac, **manually back up** the following directories from `$HOME` (they’re excluded here due to size or privacy):

```
~/.ssh
~/.config/raycast
~/Fonts
```

Copy them back to `$HOME` after reinstalling macOS.

---

## ⚡ Quick Install (Script Method)

What this does: Runs a single script that installs developer tools (Xcode CLI), Homebrew (package manager), shells and CLI tools, recommended fonts and apps, applies some macOS preferences, clones these dotfiles, and links them into your home folder using GNU Stow. It is safe to re-run.

1. **(Optional)** Install Xcode Command Line Tools:  
   Why: Provides compilers and developer utilities required by many tools (including Homebrew).  
   ```bash
   xcode-select --install
   ```

2. **Install Homebrew**:  
   Why: Homebrew is the package manager for macOS that installs CLI tools and apps.  
   ```bash
   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Install Git**:  
   Why: Git is the version control system used to clone and update these dotfiles.  
   ```bash
   brew install git
   ```

4. **Clone This Repo**:  
   Why: Downloads the dotfiles into `~/dotfiles`.  
   ```bash
   git clone https://github.com/mhosseintaher/dotfiles.git $HOME/dotfiles
   ```

5. **Run Install Script**:  
   Why: Automates the rest: installs packages and apps, applies defaults, and links configs with Stow.  
   ```bash
   chmod +x ~/dotfiles/install.sh
   /bin/bash ~/dotfiles/install.sh
   ```

---

## 🛠 Manual Install

### 1. Install Required Tools

What these are and why you need them:
- **Xcode Command Line Tools**: Apple’s developer toolchain (compilers, headers). Required for building many packages.
- **Homebrew**: The macOS package manager. Installs CLI tools and desktop apps.
- **Essential Packages**: The core utilities and shells used by this setup (e.g., `zsh`, `fzf`, `tmux`, `neovim`).

Install Xcode Command Line Tools  
```bash
xcode-select --install
```

Install Homebrew  
```bash
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install essential CLI tools  
What these do (short list):
- `neovim` (modern Vim), `tmux` (terminal multiplexer), `starship` (prompt), `fzf` (fuzzy finder), `fd` (find alternative), `eza` (ls alternative), `bat` (cat with syntax highlighting), `zoxide` (smart cd), `stow` (symlink manager), `nvm` (Node version manager)
```bash
brew install neovim eza fzf fd stow bat zoxide zsh-autosuggestions zsh-syntax-highlighting git starship tmux nvm coreutils
```

Add GNU coreutils to PATH  
Why: macOS ships BSD utilities; adding GNU versions ensures consistent behavior with Linux‑style scripts.  
```bash
echo 'PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"' >> ~/.zshrc
```

---

### 2. Tmux Setup

What is tmux? A terminal multiplexer that lets you split panes, create windows, and keep sessions alive even if the terminal closes.

```bash
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Tip: After you start tmux, press `prefix` + `I` (usually `Ctrl-b I`) to install plugins via TPM.

---

### 3. Git Setup

What is Git? A version control system used to track and sync these configs.

Check Git version:  
```bash
git --version
```

**Install with Homebrew** (preferred):  
```bash
brew install git
```
(Homebrew installs Git at `/opt/homebrew/bin/git`)

**Install with Xcode Tools** (alternative):  
```bash
xcode-select --install
```
(Xcode installs Git at `/usr/bin/git`)

---

### 4. GNU Stow for Dotfiles

What is GNU Stow? A symlink “manager.” It takes folders inside this repo (e.g., `zsh`, `nvim`) and creates symbolic links in your home directory so apps see them as if they were real files in `~`. This keeps your home clean and your configs version‑controlled.

How it works (conceptually):
- Repo: `~/dotfiles/zsh/.zshrc` → Stow creates a symlink at `~/.zshrc` pointing back to the file in the repo
- Non‑destructive: Removing symlinks doesn’t delete your actual config files in the repo
- Reversible: You can “unstow” to remove links

Install GNU Stow  
```bash
brew install stow
```

Prepare your home structure  
- Ensure required directories (e.g., `~/.config`) exist before running Stow:  
  ```bash
  mkdir -p ~/.config
  ```

Clone and stow  
`stow .` will symlink everything inside the repo into your home directory. Run this from the repo root.
```bash
git clone https://github.com/Sin-cy/dotfiles.git ~
cd ~/dotfiles
stow .
```

Stow selectively  
Use `-t ~` to choose the target directory (your home). This links only selected modules.
```bash
stow -t ~ nvim
stow -t ~ zsh
stow -t ~ starship
```

Unstow (remove links):
```bash
stow -D -t ~ zsh
```

Verify links:
```bash
ls -l ~/.zshrc
# should show -> ~/dotfiles/zsh/.zshrc
```

---

> Note: If you have Atuin installed, it auto-creates `~/.config/atuin` and may break Stow symlinks.
> Stow Atuin configs before installing, or uninstall and reinstall it after symlinking.

---

## ❓ What are these tools?

- Zsh: The shell (command line) you type into
- Oh My Zsh: A framework for managing Zsh configuration and plugins
- Starship: Fast, minimal shell prompt
- fzf: Fuzzy finder for files and commands
- zoxide: Smarter `cd` command for jumping to directories
- tmux: Terminal multiplexer (panes, windows, sessions)
- Neovim: Modern Vim-based editor
- GNU Stow: Symlink manager for dotfiles
- Homebrew: Package manager for macOS

---

## 🧰 Troubleshooting

- Stow says a file already exists and refuses to link
  - Remove or backup the existing file, then re-run stow, or use `stow -D` to clean old links first

- Shell shows a “compinit” error referencing `_alacritty`
  - Cause: A broken Zsh completion symlink left behind by a removed app
  - Fix:
    ```bash
    rm -f /opt/homebrew/share/zsh/site-functions/_alacritty
    rm -f ~/.zcompdump*
    zsh -ic 'exit'  # regenerate completion cache
    ```

- Atuin breaks stow links under `~/.config/atuin`
  - Uninstall Atuin, stow the `atuin` folder, then reinstall

---

## ✅ After installation

- Open a new terminal window or run `exec zsh` to reload shell
- In tmux, press `prefix` + `I` to install plugins
- In Neovim, run `:checkhealth` to verify dependencies
