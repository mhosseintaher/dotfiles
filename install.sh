#!/bin/bash
#
# macOS Dev Environment Bootstrap Script
# ---------------------------------------
# Installs Xcode CLI tools, oh-my-zsh, Homebrew with useful formulae and casks,
# applies macOS defaults, and sets up dotfiles.
# Safe to re-run: each install step is skipped when its target already exists.
#
# TODO:
#   - Scan Applications folder and persist list for future installations
#   - Detect and persist list of all installed terminal applications

set -euo pipefail
trap 'echo "❌ install.sh failed at line $LINENO: $BASH_COMMAND" >&2' ERR

echo "🔧 Starting macOS environment setup..."

## 1. Install Xcode CLI Tools
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS detected..."
    if xcode-select -p &>/dev/null; then
        echo "✅ Xcode CLI tools already installed"
    else
        echo "📦 Installing Xcode CLI tools..."
        xcode-select --install || true
        # the installer is a GUI dialog that returns at once: wait for it before any git step
        echo "⏳ Finish the Xcode CLI tools dialog; waiting for it..."
        # capped at 30 min (360 x 5 s) so a cancelled dialog does not hang the script forever
        for _ in $(seq 360); do xcode-select -p &>/dev/null && break; sleep 5; done
        if ! xcode-select -p &>/dev/null; then
            echo "❌ Xcode CLI tools still missing after 30 min (dialog cancelled?). Run 'xcode-select --install', then re-run install.sh." >&2
            exit 1
        fi
    fi
fi

## 2. Install oh-my-zsh & plugins
# A plain clone, not the upstream installer: that one replaces ~/.zshrc, runs chsh and
# `exec zsh`, and exits 1 when ~/.oh-my-zsh exists. zsh/.zshrc already sources it.
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ oh-my-zsh already installed"
else
    echo "🎨 Installing oh-my-zsh..."
    git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
fi

# Optional plugins (uncomment if needed)
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

## 3. Install Homebrew
if command -v brew &>/dev/null || [ -x /opt/homebrew/bin/brew ]; then
    echo "✅ Homebrew already installed"
else
    echo "🍺 Installing Homebrew..."
    # NONINTERACTIVE makes the installer use `sudo -n`, so cache the password first
    sudo -v
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Apple Silicon installs to /opt/homebrew, which is not on this script's PATH yet
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi
# One install that fails (app already in /Applications, renamed or disabled cask) only warns,
# so a re-run still reaches the later steps; failures are listed at the end
failed=()
brew() {
    if [ "${1:-}" = install ]; then
        command brew "$@" || { echo "⚠️  brew $* failed, continuing" >&2; failed+=("${*:2}"); }
    else
        command brew "$@"
    fi
}
brew analytics off

## 4. Brew taps
echo "📚 Adding Homebrew taps..."
brew tap FelixKratz/formulae
brew tap nikitabobko/tap
brew tap stripe/stripe-cli

## 5. Install Brew formulae
echo "📦 Installing formulae..."

# Core utilities
brew install coreutils

# Shell tools
brew install zsh-autosuggestions zsh-syntax-highlighting stow fzf bat fd zoxide ripgrep

# Development utilities
brew install lua luajit luarocks git lazygit tmux neovim starship tree-sitter-cli cmatrix
brew install eza htop jq curl wget cmake pyenv rbenv

# UI tools from taps
brew install felixkratz/formulae/sketchybar
brew install stripe/stripe-cli/stripe

# Dev environment
brew install nvm sqlite
brew install switchaudio-osx

## 6. Install Homebrew casks
echo "🖥 Installing casks..."
brew install --cask raycast karabiner-elements keycastr betterdisplay linearmouse
brew install --cask nikitabobko/tap/aerospace
brew install --cask font-hack-nerd-font font-jetbrains-mono-nerd-font font-sf-pro

# Terminal applications
brew install --cask ghostty

## 7. macOS system settings
echo "⚙️ Applying macOS defaults..."
defaults write com.apple.Dock autohide -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
defaults write com.apple.dock "expose-group-by-app" -bool true
defaults write com.apple.dock "mru-spaces" -bool false
defaults write com.apple.spaces spans-displays -bool true

csrutil status

## 8. Clone dotfiles repository
if [ ! -d "$HOME/dotfiles" ]; then
    echo "📂 Cloning dotfiles repository..."
    git clone https://github.com/mhosseintaher/dotfiles.git "$HOME/dotfiles"
fi

## 9. Stow dotfiles
# (GNU coreutils go on PATH from the stowed zsh/.zprofile)
echo "📦 Stowing dotfiles..."
cd "$HOME/dotfiles"
stow --restow -t ~ aerospace atuin ghostty karabiner linearmouse nvim scripts sketchybar starship tmux tmux-sessionizer vim zsh
# apps that write their own state next to the config: link files only, never fold the dir into the repo
stow --restow --no-folding -t ~ home superfile zed
# enable the secret guard (.githooks/pre-commit) for commits from this clone
git -C "$HOME/dotfiles" config core.hooksPath .githooks

## 10. Install tmux plugin manager (tmux.conf runs it from ~/.config/tmux/.tmux/plugins/tpm)
if [ -d "$HOME/.config/tmux/.tmux/plugins/tpm" ]; then
    echo "✅ TPM already installed"
else
    echo "🧩 Installing TPM..."
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/.tmux/plugins/tpm"
fi

## 11. Install atuin
echo "🔍 Installing atuin..."
echo "We should install atuin after stowing dotfiles for it to work properly"
brew install atuin

if [ ${#failed[@]} -gt 0 ]; then
    echo "⚠️  These brew installs failed (see the warnings above):"
    printf '   • %s\n' "${failed[@]}"
fi
echo "🎉 Setup complete!"
