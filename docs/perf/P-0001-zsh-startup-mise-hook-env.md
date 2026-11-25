---
id: P-0001
title: Synchronous mise hook-env subprocess on every Zsh startup
status: confirmed
severity: P2
hot_path: zsh-startup
found: 2026-11-25 @ 0e4a670
method: profiled
baseline: 13.24 ms in _mise_hook · 16.31 ms total mise section · 12.55 ms standalone mise hook-env (isolated zsh -i -c exit, warm cache)
target: —
commit: —
result: —
manual_check: —
---

## Bottleneck
`zsh/zshrc:196` runs `source_command_cache mise mise activate zsh`. Although
the activation script itself is cached and `zcompile`d, the generated
`mise.zsh` immediately invokes `_mise_hook` at source time, which forks and
executes `/opt/homebrew/bin/mise hook-env --shell-pid $$ -s zsh` synchronously
before the first prompt is ready. Cost is paid on every interactive shell
startup (every new terminal tab or split) and scales with the number of
configured `mise` runtimes/config files inspected along the directory tree.

## Baseline
- Isolated warm Zsh startup (`HOME=<tmp>` with repo `zsh/zshenv` and
  `zsh/zshrc`, `zprof` + `EPOCHREALTIME` marks, macOS arm64, Homebrew binaries):
  - Total warm `zsh -i -c exit` wall-clock: 52.5 ms median (52.1–53.6 ms, 5 runs)
  - `mise` section (`after_starship` → `after_mise`): 16.31 ms (~31% of warm wall-clock)
  - `_mise_hook` in `zprof`: 13.24 ms (34.59% of profiled function time)
- Standalone `mise hook-env -s zsh` (10 runs): 12.55 ms median (11.89–14.88 ms).

## Impact
Single largest contributor (~31%) to interactive shell startup latency on every
new terminal tab or split.

## Optimization plan
—

## Result
—

## Attempts
none

## Manual check
—
