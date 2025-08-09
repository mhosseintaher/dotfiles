#!/bin/bash
#
# macOS Dev Environment Bootstrap Script
# ---------------------------------------
# Installs Xcode CLI tools, oh-my-zsh, Homebrew with useful formulae and casks,
# applies macOS defaults, and sets up dotfiles.
#
# TODO:
#   - Scan Applications folder and persist list for future installations
#   - Detect and persist list of all installed terminal applications

set -e

echo "🔧 Starting macOS environment setup..."

## 1. Install Xcode CLI Tools
if [[ "$(uname)" == "Darwin" ]]; then
    echo "macOS detected..."
    if xcode-select -p &>/dev/null; then
        echo "✅ Xcode CLI tools already installed"
    else
        echo "📦 Installing Xcode CLI tools..."
        xcode-select --install
    fi
fi

## 2. Install oh-my-zsh & plugins
echo "🎨 Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Optional plugins (uncomment if needed)
# git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

## 3. Install Homebrew
echo "🍺 Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
brew install lua luajit luarocks git lazygit tmux neovim starship tree-sitter cmatrix
brew install eza htop jq curl wget cmake pyenv rbenv

# UI tools from taps
brew install felixkratz/formulae/sketchybar
brew install stripe/stripe-cli/stripe

# Dev environment
brew install nvm sqlite

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

## 9. Add GNU coreutils to PATH
echo 'export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"' >> ~/.zshrc

## 10. Stow dotfiles
echo "📦 Stowing dotfiles..."
cd "$HOME/dotfiles" || exit
stow -t ~ aerospace atuin ghostty karabiner linearmouse nvim sketchybar starship superfile tmux tmux-sessionizer vim zed zsh

## 11. Install atuin
echo "🔍 Installing atuin..."
echo "We should install atuin after stowing dotfiles for it to work properly"
brew install atuin

echo "🎉 Setup complete!"
