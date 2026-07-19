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

echo "Checking patch whitespace..."
git diff --check

echo "All checks passed."
