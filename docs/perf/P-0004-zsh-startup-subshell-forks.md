---
id: P-0004
title: Redundant subshell forks in source_command_cache and compinit check
status: confirmed
severity: P3
hot_path: zsh-startup
found: 2026-11-25 @ 0e4a670
method: benchmarked
baseline: 7.66 ms for 5x $(command -v) vs 6.10 ms for 5x $commands[] · 6 subshell forks per startup (zsh -f microbenchmark)
target: —
commit: —
result: —
manual_check: —
---

## Bottleneck
Two startup helpers in `zsh/zshrc` fork subshells for operations Zsh provides
in-process:
- `zsh/zshrc:83` (`source_command_cache`) runs `bin_path="$(command -v "$bin")"`
  inside a command substitution on all 5 calls (`starship`, `mise`, `zoxide`,
  `fzf`, `atuin`), instead of reading the built-in `$commands[$bin]` hash.
- `zsh/zshrc:153` runs `$(zstat +mtime -- "$zcompdump")` inside a command
  substitution on every startup, instead of `zstat -A` / `zstat -H` to assign
  the mtime in-process.

## Baseline
- `zsh -f -c 'for i in 1 2 3 4 5; do x=$(command -v zsh); done'` (10 runs):
  7.66 ms median (7.31–8.09 ms)
- `zsh -f -c 'for i in 1 2 3 4 5; do x=$commands[zsh]; done'` (10 runs):
  6.10 ms median (5.86–6.67 ms)
- Delta: ~1.56 ms for 5 `command -v` subshells (~0.31 ms per fork), plus 1
  additional fork for `$(zstat +mtime ...)`.

## Impact
Minor fixed overhead (~2 ms across 6 unnecessary forks) on every interactive
shell startup.

## Optimization plan
—

## Result
—

## Attempts
none

## Manual check
—
