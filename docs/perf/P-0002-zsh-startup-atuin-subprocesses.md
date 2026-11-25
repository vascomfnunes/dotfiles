---
id: P-0002
title: Synchronous atuin subprocess forks on every TTY Zsh startup
status: confirmed
severity: P3
hot_path: zsh-startup
found: 2026-11-25 @ 0e4a670
method: profiled
baseline: 9.02 ms atuin section · 5.74 ms atuin uuid · 5.22 ms atuin pty-proxy-active (isolated zsh -i -c exit, warm cache)
target: —
commit: —
result: —
manual_check: —
---

## Bottleneck
`zsh/zshrc:211-213` runs `source_command_cache atuin atuin init zsh` whenever
stdin is a TTY (`[[ -t 0 ]]`). Even with `atuin.zsh` cached and `zcompile`d,
sourcing the generated script synchronously executes `atuin uuid` (to populate
`ATUIN_SESSION`) and `atuin __internal pty-proxy-active` on every interactive
TTY shell startup.

## Baseline
- Isolated warm Zsh startup (`HOME=<tmp>` with repo `zsh/zshenv` and
  `zsh/zshrc`, `EPOCHREALTIME` marks, macOS arm64, Homebrew binaries):
  - `atuin` section (`Local overrides` → `end`): 9.02 ms (~17% of 52.5 ms warm wall-clock)
- Standalone subprocess benchmarks (10 runs each):
  - `atuin uuid`: 5.74 ms median (5.21–5.92 ms)
  - `atuin __internal pty-proxy-active`: 5.22 ms median (5.00–7.17 ms)

## Impact
Adds ~9 ms of synchronous process-spawn overhead to every interactive terminal
startup.

## Optimization plan
—

## Result
—

## Attempts
none

## Manual check
—
