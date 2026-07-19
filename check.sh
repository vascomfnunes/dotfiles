#!/bin/sh

set -eu

DOTFILES_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
cd "$DOTFILES_DIR"

echo "Checking POSIX shell syntax..."
sh -n install.sh bin/serve tmux/scripts/*.sh

echo "Checking Zsh syntax..."
zsh -n zsh/zshrc zsh/zshenv

echo "Running ShellCheck..."
shellcheck install.sh bin/serve tmux/scripts/*.sh

echo "Running Neovim tests..."
nvim_test_tmp=$(mktemp -d)
trap 'rm -rf "$nvim_test_tmp"' EXIT HUP INT TERM
mkdir -p "$nvim_test_tmp/state" "$nvim_test_tmp/data" "$nvim_test_tmp/cache"
for test in nvim/tests/*_spec.lua; do
  XDG_STATE_HOME="$nvim_test_tmp/state" \
    XDG_DATA_HOME="$nvim_test_tmp/data" \
    XDG_CACHE_HOME="$nvim_test_tmp/cache" \
    nvim --headless -u NONE -l "$test" "$DOTFILES_DIR"
done
rm -rf "$nvim_test_tmp"
trap - EXIT HUP INT TERM

echo "Checking patch whitespace..."
git diff --check
git diff --cached --check

echo "All checks passed."
