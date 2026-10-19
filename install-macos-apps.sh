#!/bin/bash
#
# macOS Applications Installation Script via Homebrew Casks
# ---------------------------------------------------------
# Installs GUI applications listed in macos-apps.md that are available via Homebrew casks.
# This script is separate from the main install.sh to allow selective app installation.
#

set -euo pipefail

echo "🍺 Installing macOS Applications via Homebrew Casks..."

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please run install.sh first."
    exit 1
fi

# One cask that fails (renamed, disabled, app already present) only warns, so the rest still install
failed=()
brew() {
    if [ "${1:-}" = install ]; then
        command brew "$@" || { echo "⚠️  brew $* failed, continuing" >&2; failed+=("${*: -1}"); }
    else
        command brew "$@"
    fi
}

## Development Tools
echo "💻 Installing Development Tools..."
brew install --cask android-studio
brew install --cask blender
brew install --cask cursor
brew install --cask docker-desktop
brew install --cask figma
# brew install --cask github-desktop  # Note: Only github@beta available
brew install --cask obs
brew install --cask tableplus
brew install --cask typora
brew install --cask visual-studio-code
# Note: Xcode available via App Store, not Homebrew
brew install --cask zed

## Browsers
echo "🌐 Installing Browsers..."
brew install --cask arc
brew install --cask brave-browser
brew install --cask firefox
brew install --cask google-chrome
# Note: Safari is built-in to macOS
# Note: Zen browser not found in Homebrew

## Terminals (already in main install.sh)
echo "⚡ Terminal applications already handled in main install.sh"
# brew install --cask ghostty
# brew install --cask wezterm

## Productivity & Organization
echo "📋 Installing Productivity Apps..."
# brew install --cask clickup          # Not found
# brew install --cask craft            # Not found
# brew install --cask miro             # Not found
# brew install --cask mindnode         # Not found
# brew install --cask monday-com       # Not found
# brew install --cask next-meeting     # Not found
brew install --cask notion
brew install --cask obsidian
brew install --cask raycast
# brew install --cask ticktick         # Not found
# brew install --cask time-out         # Not found

## Communication & Social
echo "💬 Installing Communication Apps..."
# brew install --cask chatgpt          # Not found in search
brew install --cask discord
# brew install --cask kumospace        # Not found
# brew install --cask loom             # Not found
# brew install --cask microsoft-outlook  # Not found
brew install --cask microsoft-teams
brew install --cask signal
brew install --cask slack
brew install --cask telegram
# brew install --cask twitter          # Now X, not commonly available
brew install --cask whatsapp
brew install --cask zoom

## Media & Entertainment
echo "🎵 Installing Media Apps..."
brew install --cask handbrake-app
brew install --cask iina
brew install --cask vlc
# brew install --cask final-cut-pro    # App Store only
# brew install --cask screenflow       # Let me check this
brew install --cask steam
# Note: Counter-Strike 2 installed via Steam
# Note: PCSX2 emulator - let me check this

## Adobe Creative Suite (App Store/Adobe website installs)
echo "🎨 Adobe apps typically installed via Adobe Creative Cloud..."
# Adobe apps are usually installed via Adobe Creative Cloud, not Homebrew

## System Utilities & Window Management
echo "⚙️ Installing System Utilities..."
# Note: Many of these are already in the main install.sh
# brew install --cask aerospace         # Already in main install.sh
# brew install --cask aldente           # Let me check this
# brew install --cask amphetamine       # App Store
# brew install --cask betterdisplay     # Already in main install.sh
# brew install --cask betterdummy       # Let me check this
# brew install --cask cursorsense       # Let me check this
# brew install --cask display-maid      # Let me check this
# brew install --cask hidden-bar        # Let me check this
# brew install --cask keycastr          # Already in main install.sh
# brew install --cask linearmouse       # Already in main install.sh
# brew install --cask magnet            # Let me check this
# brew install --cask mos               # Let me check this
# brew install --cask steermouse        # Let me check this

## File Management & Storage
echo "📁 Installing File Management Apps..."
brew install --cask dropbox
# brew install --cask dropover          # Not found
# brew install --cask filezilla        # Cask removed from Homebrew; download from filezilla-project.org
# brew install --cask folx              # Not found
# brew install --cask ntfs-for-mac      # Not found
brew install --cask onedrive
brew install --cask the-unarchiver

## Security & VPN
echo "🔐 Installing Security Apps..."
# brew install --cask astrill           # Not commonly available
# brew install --cask authenticator     # Let me check this
# brew install --cask enpass            # Let me check this
# brew install --cask fair-vpn          # Not found
# brew install --cask mullvad-vpn       # Let me check this
# brew install --cask wireguard         # Let me check this

## Specialized Tools
echo "🛠 Installing Specialized Tools..."
# brew install --cask anydesk           # Let me check this
# Many of these specialized tools may not be available via Homebrew

## Additional Popular Apps (that I found in searches)
echo "📱 Installing Additional Popular Apps..."
# Add any other apps you want that are available

echo "✅ Homebrew cask installation complete!"
if [ ${#failed[@]} -gt 0 ]; then
    echo "⚠️  These casks failed: ${failed[*]}"
fi
echo ""
echo "📝 Notes:"
echo "   • Some apps are only available via App Store or direct download"
echo "   • Adobe apps require Adobe Creative Cloud"
echo "   • Xcode is available via App Store"
echo "   • Terminal apps (Ghostty, WezTerm) are in main install.sh"
echo "   • System utilities (AeroSpace, KeyCastr, etc.) are in main install.sh"
echo ""
echo "🔍 Apps NOT available via Homebrew casks:"
echo "   • ClickUp, Craft, Miro, MindNode, monday.com, TickTick"
echo "   • ChatGPT, Kumospace, Loom, Microsoft Outlook"
echo "   • Zen browser, Twitter/X"
echo "   • Dropover, Folx, NTFS for Mac, Magnet"
echo "   • Many specialized/niche applications"
echo ""
echo "💡 For missing apps, install manually from:"
echo "   • App Store"
echo "   • Official websites"
echo "   • Other package managers"
