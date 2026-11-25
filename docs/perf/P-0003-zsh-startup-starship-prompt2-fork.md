---
id: P-0003
title: Synchronous starship prompt --continuation fork on Zsh startup
status: confirmed
severity: P3
hot_path: zsh-startup
found: 2026-11-25 @ 0e4a670
method: profiled
baseline: 7.06 ms starship section · 4.63 ms standalone starship prompt --continuation (isolated zsh -i -c exit, warm cache)
target: —
commit: —
result: —
manual_check: —
---

## Bottleneck
`zsh/zshrc:195` runs `source_command_cache starship starship init zsh`. Even
though `starship.zsh` is cached and `zcompile`d, the generated script evaluates
`PROMPT2="$(/opt/homebrew/bin/starship prompt --continuation)"` synchronously
during shell startup to compute the static continuation prompt.

## Baseline
- Isolated warm Zsh startup (`HOME=<tmp>` with repo `zsh/zshenv` and
  `zsh/zshrc`, `EPOCHREALTIME` marks, macOS arm64, Homebrew binaries):
  - `starship` section (`Shell integrations` → `after_starship`): 7.06 ms (~13% of 52.5 ms warm wall-clock)
- Standalone `starship prompt --continuation` (10 runs): 4.63 ms median (4.38–5.83 ms).

## Impact
Spawns an extra `starship` process on every shell startup (~5–7 ms) for a
static continuation prompt string.

## Optimization plan
—

## Result
—

## Attempts
none

## Manual check
—
