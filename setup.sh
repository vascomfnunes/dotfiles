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
  for i in $(cat homebrew_packages); do brew install "$i"; done

	msg "Installing casks"
	brew install --cask alacritty appcleaner dash iina

	msg "Creating dotfiles symlinks"
	stow -R alacritty bat bin git gnupg htop lazygit mpd mpv \
		ncmpcpp newsboat nvim pgcli ssh tmux vifm w3m weechat fish misc

  msg "Installing node dependencies"
  npm install -g live-server
  npm install -g stylelint stylelint-config-standard stylelint-config-sass-guidelines stylelint-selector-bem-pattern postcss-scss

	msg "Installing fonts"
	cp fonts/Library/Fonts/*.ttf ~/Library/Fonts

	msg "Installing misc files"
	cp misc/Pictures/vasco.jpeg ~/Pictures

  msg "Initializing rbenv"
  cd $HOME
  eval "$(rbenv init -)"
  msg "Initializing Ruby"
  rbenv install 3.2.2
  rbenv global 3.2.2
  gem install bundler typecheck erb-formatter bundler-audit
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
