#!/bin/sh

set -eu

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This script targets macOS only (launchd, defaults)." >&2
  exit 1
fi

PROFILE="personal"
UPGRADE_BREW=0
DOTFILES_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.local/bin:$PATH"

cd "$DOTFILES_DIR"


##### Arguments

usage() {
  echo "Usage: $0 [personal|work] [--upgrade-brew]"
}

for arg in "$@"; do
  case "$arg" in
    --upgrade-brew)
      UPGRADE_BREW=1
      ;;
    personal|work)
      PROFILE="$arg"
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

PROFILE_BREWFILE="brew/Brewfile.$PROFILE"
if [ ! -f "$PROFILE_BREWFILE" ]; then
  echo "Unknown profile: $PROFILE" >&2
  echo "Expected profile file: $PROFILE_BREWFILE" >&2
  exit 1
fi

# Fail before installing packages or replacing other configuration if a
# directory managed as a symlink would be overwritten.
for path in \
  "$HOME/.config/nvim" \
  "$HOME/.config/pyradio" \
  "$HOME/.config/tmux/themes" \
  "$HOME/.config/yazi"
do
  if [ -e "$path" ] && [ ! -L "$path" ]; then
    echo "Existing non-symlink config found at $path" >&2
    echo "Move it aside before re-running install.sh." >&2
    exit 1
  fi
done


##### Homebrew

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "📦 Installing Homebrew dependencies..."
brew update
if [ "$PROFILE" = "personal" ]; then
  brew tap vascomfnunes/audio
  brew trust vascomfnunes/audio
fi
brew bundle --file=brew/Brewfile
brew bundle --file="$PROFILE_BREWFILE"
if [ "$UPGRADE_BREW" -eq 1 ]; then
  brew upgrade
fi


##### PyRadio

# The pyradio package on PyPI is an obsolete 2013 release. Use the maintained
# project's installer, which installs the current release through pipx.
if ! command -v pyradio >/dev/null 2>&1; then
  echo "📻 Installing pyradio..."
  pyradio_tmp="$(mktemp -d)"
  trap 'rm -rf "$pyradio_tmp"' EXIT HUP INT TERM
  curl -fsSL \
    https://raw.githubusercontent.com/coderholic/pyradio/master/pyradio/install.py \
    -o "$pyradio_tmp/install.py"
  python3 -m venv "$pyradio_tmp/venv"
  "$pyradio_tmp/venv/bin/python" -m pip install --quiet requests rich
  "$pyradio_tmp/venv/bin/python" "$pyradio_tmp/install.py" --isolate
  rm -rf "$pyradio_tmp"
  trap - EXIT HUP INT TERM
fi
# Ensure netifaces is available for pyradio's remote-control server, which is
# used by the tmux status bar script.
if ! pipx runpip pyradio show netifaces >/dev/null 2>&1; then
  pipx inject pyradio netifaces
fi


##### Directories

echo "📂 Creating directories..."
mkdir -p \
  "$HOME/.config/ghostty" \
  "$HOME/.config/btop/themes" \
  "$HOME/.config/tmux" \
  "$HOME/.config/git" \
  "$HOME/.config/zsh" \
  "$HOME/.config/mise" \
  "$HOME/.local/bin" \
  "$HOME/.gnupg" \
  "$HOME/.ssh/sockets"
chmod 700 "$HOME/.gnupg" "$HOME/.ssh" "$HOME/.ssh/sockets"


##### Symlinks

echo "🔗 Creating symlinks..."
ln -sf "$DOTFILES_DIR/zsh/zshenv" "$HOME/.zshenv"
ln -sf "$DOTFILES_DIR/zsh/zshrc" "$HOME/.config/zsh/.zshrc"
ln -sf "$DOTFILES_DIR/git/gitconfig" "$HOME/.config/git/config"
ln -sf "$DOTFILES_DIR/git/gitignore" "$HOME/.config/git/ignore"

# Directory symlinks use -n so an existing link is replaced instead of the
# new link being created inside the directory it points to.
ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ln -sfn "$DOTFILES_DIR/yazi" "$HOME/.config/yazi"
ln -sf "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
ln -sf "$DOTFILES_DIR/btop/themes/catppuccin_latte.theme" "$HOME/.config/btop/themes/catppuccin_latte.theme"
ln -sf "$DOTFILES_DIR/btop/themes/catppuccin_mocha.theme" "$HOME/.config/btop/themes/catppuccin_mocha.theme"
ln -sf "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
ln -sfn "$DOTFILES_DIR/tmux/themes" "$HOME/.config/tmux/themes"
ln -sf "$DOTFILES_DIR/gpg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
ln -sf "$DOTFILES_DIR/ssh/config" "$HOME/.ssh/config"
ln -sf "$DOTFILES_DIR/mise/config.toml" "$HOME/.config/mise/config.toml"

# PyRadio's config dir is symlinked as a whole: pyradio saves playlists by
# writing a temp file and renaming it over stations.csv, which would replace
# a per-file symlink with a regular file.
ln -sfn "$DOTFILES_DIR/pyradio" "$HOME/.config/pyradio"
# PyRadio watches this generated theme and repaints when the appearance agent
# swaps its contents. Keep mutable state in ~/.cache rather than the repository.
ln -sf "$HOME/.cache/pyradio-catppuccin-auto.pyradio-theme" \
  "$DOTFILES_DIR/pyradio/themes/catppuccin-auto.pyradio-theme"
ln -sf "$DOTFILES_DIR/bin/serve" "$HOME/.local/bin/serve"
ln -sf "$DOTFILES_DIR/tmux/scripts/weather-status.sh" "$HOME/.local/bin/tmux-weather-status"
ln -sf "$DOTFILES_DIR/tmux/scripts/pyradio-status.sh" "$HOME/.local/bin/tmux-pyradio-status"
ln -sf "$DOTFILES_DIR/tmux/scripts/pyradio-art.sh" "$HOME/.local/bin/tmux-pyradio-art"
ln -sf "$DOTFILES_DIR/tmux/scripts/battery-status.sh" "$HOME/.local/bin/tmux-battery-status"
ln -sf "$DOTFILES_DIR/tmux/scripts/btop-themed.sh" "$HOME/.local/bin/btop-themed"
ln -sf "$DOTFILES_DIR/tmux/scripts/theme-reload.sh" "$HOME/.local/bin/tmux-theme-reload"
ln -sf "$DOTFILES_DIR/tmux/scripts/workspace.sh" "$HOME/.local/bin/tmux-workspace"

# Flavor sources are pinned in package.toml; Yazi deploys their generated
# files into the ignored flavors directory.
echo "🎨 Installing Yazi flavors..."
ya pkg install

# gpg-agent.conf points pinentry-program at this stable path, so it works
# regardless of where Homebrew installs pinentry-mac.
if command -v pinentry-mac >/dev/null 2>&1; then
  ln -sf "$(command -v pinentry-mac)" "$HOME/.local/bin/pinentry-mac"
fi


##### tmux theme launchd agent

# Reload tmux's config when the macOS appearance changes so the Catppuccin
# variant in tmux.conf follows Light/Dark mode. The plist is generated here
# rather than symlinked because launchd is unreliable with symlinked plists.
echo "🌗 Installing tmux theme reload agent..."
mkdir -p "$HOME/Library/LaunchAgents"
TMUX_THEME_PLIST="$HOME/Library/LaunchAgents/com.vascomfnunes.tmux-theme-reload.plist"
cat > "$TMUX_THEME_PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.vascomfnunes.tmux-theme-reload</string>
  <key>ProgramArguments</key>
  <array>
    <string>$HOME/.local/bin/tmux-theme-reload</string>
  </array>
  <key>WatchPaths</key>
  <array>
    <string>$HOME/Library/Preferences/.GlobalPreferences.plist</string>
  </array>
</dict>
</plist>
EOF
launchctl bootout "gui/$(id -u)/com.vascomfnunes.tmux-theme-reload" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$TMUX_THEME_PLIST"
# Populate the watched PyRadio theme immediately instead of waiting for the
# next macOS preferences change.
"$HOME/.local/bin/tmux-theme-reload"


##### Local config stubs

echo "📝 Setting up local config files..."
for stub in .zshrc.local .gitconfig.local .hushlogin .tmux-workspace.local; do
  [ -f "$HOME/$stub" ] || : > "$HOME/$stub"
done


##### Shell plugin manager

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME/.git" ]; then
  echo "⚡ Installing zinit..."
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi


##### Trust and agent refresh

if command -v gpgconf >/dev/null 2>&1; then
  gpgconf --kill gpg-agent
  gpgconf --launch gpg-agent
fi

if command -v mise >/dev/null 2>&1; then
  export MISE_TRUSTED_CONFIG_PATHS="$DOTFILES_DIR/mise/config.toml"
  # Trust the config file to avoid the security prompt
  mise trust "$DOTFILES_DIR/mise/config.toml"
  echo "💎 Installing Mise runtimes and developer tools..."
  mise install --yes
fi


##### Cleanup

echo "🧹 Cleaning up Homebrew..."
brew autoremove
brew cleanup


##### macOS defaults

echo "📝 Setting up macOS system settings..."

# Language
defaults write -globalDomain AppleLanguages -array en-GB

# Pointer Control >  Trackpad Options > Dragging Style: Three Finger Drag
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Menu Bar Controls > Bluetooth > Show in Menu Bar
defaults write "com.apple.controlcenter" "NSStatusItem Visible Bluetooth" -bool true

# Menu Bar Controls > Screen Mirroring > Don't Show in Menu Bar
defaults write "com.apple.airplay" showInMenuBarIfPresent -bool false

# Menu Bar Controls > Sound > Always Show in Menu Bar
defaults write "com.apple.controlcenter" "NSStatusItem Visible Sound" -bool true

# Menu Bar Only > Spotlight > Don't Show in Menu Bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

# Ask Siri
defaults write com.apple.Siri SiriPrefStashedStatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false

# Dock > Size:
defaults write com.apple.dock tilesize -int 36

# Dock > Magnification (size)
defaults write com.apple.dock largesize -int 54

# Dock > Magnification (enabled)
defaults write com.apple.dock magnification -bool true

# Dock > Minimize windows using: Scale effect
defaults write com.apple.dock mineffect -string "scale"

# Dock > Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Dock > Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Dock > Automatically hide and show the Dock (duration)
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Dock > Automatically hide and show the Dock (delay)
defaults write com.apple.dock autohide-delay -float 0

# Show recent applications in Dock
defaults write com.apple.dock "show-recents" -bool false

# Play feedback when volume is changed
defaults write -globalDomain "com.apple.sound.beep.feedback" -int 1

# Key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1

# Delay until repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Keyboard navigation
defaults write -globalDomain AppleKeyboardUIMode -int 2

# Txt Input > Don't show Input menu in menu bar
defaults write com.apple.TextInputMenu visible -bool false

# Txt Input > Correct spelling automatically
defaults write -globalDomain NSAutomaticSpellingCorrectionEnabled -bool true

# Txt Input > Capitalise words automatically
defaults write -globalDomain NSAutomaticCapitalizationEnabled -bool true

# Trackpad - Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Don't warn before changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Finder > View > As List
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Finder > View > Show Path Bar
defaults write com.apple.finder ShowPathbar -bool true


##### Restart affected apps

# Kill affected apps
for app in "Dock" "Finder" "ControlCenter"; do
  killall "${app}" > /dev/null 2>&1 || true
done

echo "Done. Note that some of these changes require a logout/restart to take effect."
