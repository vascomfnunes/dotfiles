---
id: B-0003
title: MANPAGER is unset in login shells because zshenv checks bat before PATH includes Homebrew
status: fixed
severity: P3
area: shell-and-terminal
found: 2026-11-25 @ 18f0fab
method: reproduced
reachability: ui
commit: 181e63e
test: none — no Zsh behavioral test suite
manual_check: none
---

## Problem
`zsh/zshenv:30-32` runs `if command -v bat >/dev/null 2>&1; then export MANPAGER="sh -c 'col -bx | bat -l man -p'"; fi`.
In Zsh login shell startup on macOS, `~/.zshenv` runs before `/etc/zprofile`
(which invokes `path_helper` and adds `/opt/homebrew/bin` from `/etc/paths.d/homebrew`).
Because `bat` is installed by Homebrew in `/opt/homebrew/bin/bat` and
`zsh/zshenv:4` only prepends `$HOME/.local/bin`, `command -v bat` fails during
login shell startup and `MANPAGER` is never exported.

## Trigger
Start a fresh macOS login Zsh shell with default system `PATH` (e.g., opening a
new Ghostty tab or running
`env -i HOME="$tmp" PATH="/usr/bin:/bin:/usr/sbin:/sbin" zsh -lc 'print -r -- "${MANPAGER-<unset>}"'`
with `.zshenv` linked to `zsh/zshenv`).

## Impact
`man` falls back to the default system pager instead of using `bat` in top-level
login shells (it only works in nested shells that inherit an already-populated
`PATH`).

## Fix
Moved the `bat`-guarded `MANPAGER` export from `zsh/zshenv:28-32` into the
existing `if command -v bat` block in `zsh/zshrc:115-118`, which runs after
`/etc/zprofile` adds Homebrew to `PATH` (`181e63e`).

## Test
`none — no Zsh behavioral test suite`: reproduced and verified before/after
with `env -i HOME="$tmp" ... PATH="/usr/bin:/bin:/usr/sbin:/sbin" zsh -lic`
and `zsh -n zsh/zshrc zsh/zshenv`.

## Manual check
none
