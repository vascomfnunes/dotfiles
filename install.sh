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
brew tap halpworld/tap
brew trust --formula halpworld/tap/halpradio
if [ "$PROFILE" = "personal" ]; then
  brew tap vascomfnunes/audio
  brew trust vascomfnunes/audio
fi
brew bundle --file=brew/Brewfile
brew bundle --file="$PROFILE_BREWFILE"
if [ "$UPGRADE_BREW" -eq 1 ]; then
  brew upgrade
fi


##### slk

if [ "$PROFILE" = "work" ]; then
  echo "💬 Installing slk..."
  slk_version="$(
    curl -fsSL https://api.github.com/repos/gammons/slk/releases/latest |
      sed -n 's/.*"tag_name":[[:space:]]*"v\([^"]*\)".*/\1/p'
  )"
  if [ -z "$slk_version" ]; then
    echo "Could not determine the latest slk version." >&2
    exit 1
  fi

  slk_tmp="$(mktemp -d)"
  trap 'rm -rf "$slk_tmp"' EXIT HUP INT TERM
  curl -fsSL \
    "https://github.com/gammons/slk/releases/latest/download/slk_${slk_version}_darwin_arm64.tar.gz" \
    -o "$slk_tmp/slk.tar.gz"
  tar -xzf "$slk_tmp/slk.tar.gz" -C "$slk_tmp"
  sudo mkdir -p /usr/local/bin
  sudo install -m 0755 "$slk_tmp/slk" /usr/local/bin/slk
  rm -rf "$slk_tmp"
  trap - EXIT HUP INT TERM
fi


##### Directories

echo "📂 Creating directories..."
mkdir -p \
  "$HOME/.config/ghostty" \
  "$HOME/.config/btop/themes" \
  "$HOME/.config/opencode/plugins" \
  "$HOME/.config/tmux" \
  "$HOME/.config/git" \
  "$HOME/.config/zsh" \
  "$HOME/.config/mise" \
  "$HOME/.config/radio" \
  "$HOME/.local/bin" \
  "$HOME/.gnupg" \
  "$HOME/.ssh/sockets"
chmod 700 "$HOME/.gnupg" "$HOME/.ssh" "$HOME/.ssh/sockets"


##### Symlinks

# -n replaces an existing directory link instead of creating the new link
# inside the directory it points to.
dotlink() {
  ln -sfn "$DOTFILES_DIR/$1" "$HOME/$2"
}

# Merge a tracked JSON baseline into a live config. OpenCode rewrites its
# config files by renaming a temporary file over the
# destination, which replaces a symlink. Keep those destinations as real files
# and reapply the repository baseline on every install.
merge_json() {
  filter=$1
  source_file="$DOTFILES_DIR/$2"
  dest_file="$HOME/$3"

  mkdir -p "$(dirname "$dest_file")"

  if [ ! -f "$dest_file" ]; then
    cp "$source_file" "$dest_file"
    chmod 600 "$dest_file"
    return 0
  fi

  tmp_file="${dest_file}.tmp.$$"
  if jq -s "$filter" "$dest_file" "$source_file" > "$tmp_file"; then
    chmod 600 "$tmp_file"
    mv -f "$tmp_file" "$dest_file"
  else
    rm -f "$tmp_file"
    echo "Could not merge $source_file into $dest_file" >&2
    return 1
  fi
}

echo "🔗 Creating symlinks..."
dotlink zsh/zshenv .zshenv
# ZDOTDIR is exported, so nested shells read $ZDOTDIR/.zshenv rather than
# ~/.zshenv. Link both paths to keep the environment identical everywhere.
dotlink zsh/zshenv .config/zsh/.zshenv
dotlink zsh/zshrc .config/zsh/.zshrc
dotlink starship.toml .config/starship.toml
dotlink git/gitconfig .config/git/config
dotlink git/gitignore .config/git/ignore
dotlink ghostty/config .config/ghostty/config
dotlink btop/themes/catppuccin_latte.theme .config/btop/themes/catppuccin_latte.theme
dotlink btop/themes/catppuccin_mocha.theme .config/btop/themes/catppuccin_mocha.theme
dotlink tmux/tmux.conf .config/tmux/tmux.conf
dotlink gpg/gpg-agent.conf .gnupg/gpg-agent.conf
dotlink ssh/config .ssh/config
dotlink mise/config.toml .config/mise/config.toml
dotlink mise/mise.lock .config/mise/mise.lock
dotlink radio/stations.tsv .config/radio/stations.tsv

# Directories managed as a whole.
dotlink nvim .config/nvim
dotlink yazi .config/yazi
dotlink tmux/themes .config/tmux/themes

dotlink bin/serve .local/bin/serve
dotlink bin/git-commit-ai .local/bin/git-commit-ai
dotlink bin/nvim-edit .local/bin/nvim-edit
dotlink bin/agent-hook .local/bin/agent-hook
dotlink tmux/scripts/weather-status.sh .local/bin/tmux-weather-status
dotlink tmux/scripts/radio-status.sh .local/bin/tmux-radio-status
dotlink tmux/scripts/radio-player.sh .local/bin/tmux-radio-player
dotlink tmux/scripts/radio-art.sh .local/bin/tmux-radio-art
dotlink tmux/scripts/battery-status.sh .local/bin/tmux-battery-status
dotlink tmux/scripts/btop-themed.sh .local/bin/btop-themed
dotlink tmux/scripts/cheatsheet.sh .local/bin/tmux-cheatsheet
dotlink tmux/scripts/theme-reload.sh .local/bin/tmux-theme-reload
dotlink tmux/scripts/workspace.sh .local/bin/tmux-workspace
dotlink tmux/scripts/agent-status.sh .local/bin/agent-status
dotlink tmux/scripts/agent-dashboard.sh .local/bin/tmux-agent-dashboard

# OpenCode's shared agent instructions.
dotlink agents/AGENTS.md .config/opencode/AGENTS.md

# OpenCode does not load a symlinked plugin file as a plugin: it reports an
# empty ID and never calls setup. Install a real shim that re-exports the
# repository implementation; remove the old symlink name as well.
rm -f "$HOME/.config/opencode/plugins/agent-status.js" \
  "$HOME/.config/opencode/plugins/tmux-agent-status.js"
printf 'export { default } from "%s/opencode/plugins/tmux-agent-status.js"\n' \
  "$DOTFILES_DIR" > "$HOME/.config/opencode/plugins/tmux-agent-status.js"
chmod 644 "$HOME/.config/opencode/plugins/tmux-agent-status.js"


##### Mutable agent configuration

# These files are rewritten by their applications, so merge the tracked
# baseline instead of linking it. User-added keys survive; tracked keys are
# restored on every install.
echo "🤖 Merging agent configuration..."
# shellcheck disable=SC2016 # jq variables, not shell variables.
merge_json \
  '.[0] as $live | .[1] as $base | ($live * $base)' \
  opencode/cli.json .config/opencode/cli.json

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
# Apply the current appearance immediately.
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

echo "🧩 Installing OpenCode Quota plugin..."
opencode plugin add @slkiser/opencode-quota
echo "🧩 Installing Context7 plugin..."
opencode plugin add @upstash/context7-opencode
echo "🪨 Installing global agent skills..."
sh "$DOTFILES_DIR/agents/install-skills.sh"


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
