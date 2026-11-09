#!/bin/sh

set -eu

DOTFILES_DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"
cd "$DOTFILES_DIR"

echo "Checking POSIX shell syntax..."
sh -n install.sh agents/*.sh bin/serve bin/git-commit-ai bin/nvim-edit bin/btop-themed

echo "Checking Zsh syntax..."
zsh -n zsh/zshrc zsh/zshenv

echo "Checking JSON..."
jq empty opencode/cli.json

echo "Checking agent config privacy..."
if grep -R -n '/Users/' opencode; then
  echo "Absolute home paths must not be tracked; use \$HOME instead." >&2
  exit 1
fi

echo "Checking OpenCode agent links..."
for agent in opencode/agents/*.md; do
  name=${agent#opencode/agents/}
  if ! grep -F "dotlink $agent .config/opencode/agents/$name" install.sh >/dev/null; then
    echo "Missing dotlink for $agent in install.sh." >&2
    exit 1
  fi
done

echo "Running ShellCheck..."
shellcheck install.sh agents/*.sh bin/serve bin/git-commit-ai bin/nvim-edit bin/btop-themed

echo "Checking agent skill installation..."
sh agents/test-install-skills.sh

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
