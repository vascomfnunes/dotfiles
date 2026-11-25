---
id: B-0001
title: Fresh install aborts linking OpenCode AGENTS.md before creating directory
status: fixed
severity: P1
area: install-and-checks
found: 2026-11-25 @ 3472aa2
method: code reading
reachability: ui
commit: 8fbd460
test: none — no correct seam
manual_check: none
---

## Problem
`install.sh:216` calls `dotlink agents/AGENTS.md .config/opencode/AGENTS.md`,
which runs `ln -sfn "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.config/opencode/AGENTS.md"`.
However, `$HOME/.config/opencode` is not created in the `mkdir -p` block at
`install.sh:114-122` and is not created until four lines later at
`install.sh:220` (`mkdir -p "$HOME/.config/opencode/agents"`). Because
`install.sh` runs with `set -eu`, `ln` fails with `No such file or directory`
and aborts the installer.

## Trigger
Run `./install.sh` (personal or work profile) on a machine where
`$HOME/.config/opencode` does not yet exist (for example, a fresh macOS setup).

## Impact
`./install.sh` aborts partway through the symlink phase before linking OpenCode
subagents, merging `opencode/cli.json`, installing Yazi flavors, cloning Zinit,
installing Mise runtimes and agent skills, or applying macOS defaults.

## Fix
Moved creation of `$HOME/.config/opencode/agents` into the main `Directories`
`mkdir -p` block (`install.sh:120`) before the symlink phase runs (`8fbd460`).

## Test
`none — no correct seam`: `install.sh` runs top-to-bottom with Homebrew and
macOS `defaults` side effects and has no isolated symlink-phase test seam.
Verified syntax and ShellCheck with `./check.sh`.

## Manual check
none
