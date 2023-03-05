#!/usr/bin/env bash

function msg() {
	local text="$1"
	local div_width="80"
	printf "%${div_width}s\n" ' ' | tr ' ' -
	printf "%s\n" "$text"
}

function main() {
	print_logo
	msg "Installing homebrew"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	msg "Installing packages"
	brew install stow neovim bat git gnupg lazygit mpd mpc \
		mpv ncmpcpp htop newsboat tmux vifm w3m weechat imageoptim-cli \
    node go yarn wget git-delta gum universal-ctags ripgrep reattach-to-user-namespace \
    pinentry openssl gnupg jq go exa fd the_silver_searcher \
    pandoc wget gnu-sed rbenv ruby-build

	msg "Installing casks"
	brew install --cask alacritty brave-browser appcleaner \
		dash iina bitwarden

	msg "Creating dotfiles symlinks"
	stow -R alacritty bat bin git gnupg htop lazygit mpd mpv \
		ncmpcpp newsboat nvim pgcli ssh tmux vifm w3m weechat zsh misc

  msg "Installing node dependencies"
  npm install -g live-server
  npm install -g stylelint stylelint-config-standard stylelint-config-sass-guidelines stylelint-selector-bem-pattern postcss-scss

	msg "Installing fonts"
	cp fonts/Library/Fonts/*.ttf ~/Library/Fonts

	msg "Installing misc files"
	cp misc/Pictures/vasco.jpeg ~/Pictures

  msg "Initializing rbenv"
  cd ~
  eval "$(rbenv init -)"
  msg "Initializing Ruby"
  rbenv install 3.1.3
  rbenv global 3.1.3
  gem install bundler solargraph solargraph-rails typecheck erb-formatter bundler-audit
  solargraph download-core
  yard gems -safe

	msg "Setup complete"
	echo "Restart the terminal to complete installation."
}

function print_logo() {
	cat <<'EOF'

  █▀▄ █▀█ ▀█▀ █▀▀ █ █░░ █▀▀ █▀
  █▄▀ █▄█ ░█░ █▀░ █ █▄▄ ██▄ ▄█

EOF
}

main "$@"
