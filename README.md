# macOS Dotfiles

These are my personal dotfiles for macOS.  
They are tailored for **my setup** and might not work on your system without adjustments.

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

1. **(Optional)** Install Xcode Command Line Tools:  
   ```bash
   xcode-select --install
   ```

2. **Install Homebrew**:  
   ```bash
   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. **Install Git**:  
   ```bash
   brew install git
   ```

4. **Clone This Repo**:  
   ```bash
   git clone https://github.com/mhosseintaher/dotfiles.git $HOME/dotfiles
   ```

5. **Run Install Script**:  
   ```bash
   chmod +x ~/dotfiles/install.sh
   /bin/bash ~/dotfiles/install.sh
   ```

---

## 🛠 Manual Install

### 1. Install Required Tools

**Xcode Command Line Tools**  
```bash
xcode-select --install
```

**Homebrew**  
```bash
sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Essential Packages**  
```bash
brew install neovim eza fzf fd stow bat zoxide zsh-autosuggestions zsh-syntax-highlighting git starship tmux nvm coreutils
```

Add GNU coreutils to PATH:  
```bash
echo 'PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"' >> ~/.zshrc
```

---

### 2. Tmux Setup

```bash
brew install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

---

### 3. Git Setup

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

Install GNU Stow:  
```bash
brew install stow
```

**Prepare Your Home Structure**  
- Ensure required directories (e.g., `~/.config`) exist before running Stow:  
  ```bash
  mkdir -p ~/.config
  ```

**Clone and Stow**  
```bash
git clone https://github.com/Sin-cy/dotfiles.git ~
cd ~/dotfiles
stow .
```

Or stow selectively:  
```bash
stow -t ~ nvim
stow -t ~ zsh
stow -t ~ starship
```

---

> **Note:** If you have **Atuin** installed, it will auto-create `~/.config/atuin` and may break Stow symlinks.  
> Stow Atuin configs before installing, or uninstall and reinstall it after symlinking.
