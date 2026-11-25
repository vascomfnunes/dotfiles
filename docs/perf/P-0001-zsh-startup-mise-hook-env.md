---
id: P-0001
title: Synchronous mise hook-env subprocess on every Zsh startup
status: planned
severity: P2
hot_path: zsh-startup
found: 2026-11-25 @ 0e4a670
method: profiled
baseline: 13.24 ms in _mise_hook · 16.31 ms total mise section · 12.55 ms standalone mise hook-env (isolated zsh -i -c exit, warm cache)
target: <= 40 ms warm zsh -i -c exit median (>= 12 ms reduction) · <= 1 ms sync mise startup
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
- **Chosen approach:** Hybrid shims + deferred activation.
  1. Prepend `${XDG_DATA_HOME:-$HOME/.local/share}/mise/shims` to `PATH` in
     `zsh/zshenv` (only when not already present, or alongside
     `$HOME/.local/bin`) so Mise-managed runtimes are immediately resolvable in
     non-interactive shells, `zsh -i -c`, and `~/.zshrc.local` at 0 ms startup
     cost.
  2. Defer `source_command_cache mise mise activate zsh` in `zsh/zshrc` via
     `zinit wait lucid` (using an `atload` / `id-as` turbo snippet) when
     `$ZINIT_HOME/zinit.zsh` is present, falling back to synchronous activation
     when Zinit is not installed.
- **Accepted trade-offs:**
  - Slightly more moving parts (`zsh/zshenv` shim path + deferred `zsh/zshrc`
    activation with synchronous fallback).
  - Commands invoked before the first prompt finishes loading (e.g., `zsh -i -c`
    or `~/.zshrc.local`) dispatch through Mise shims rather than direct install
    paths; interactive commands after the first prompt use direct paths and full
    `chpwd`/`precmd` hooks (`python.uv_venv_auto = true`).
- **Target delta & revert threshold:**
  - Target: isolated warm `zsh -i -c exit` median `52.5 ms -> <= 40 ms`
    (`>= 12 ms` / `>= 23%` reduction) with synchronous `mise` startup cost
    `<= 1 ms` in `zprof`.
  - Revert if warm startup regresses or improves by `< 5 ms`.
- **Blast radius:**
  - Touches `zsh/zshenv` and `zsh/zshrc` only.
  - Neovim (`nvim/lua/plugins.lua`, `lsp.lua`, `tags.lua`) calls `mise x --`
    directly and is unaffected.
  - `mise/config.toml` (`python.uv_venv_auto = true`, idiomatic version files)
    remains fully supported once deferred activation completes.
- **Verification method:**
  - Benchmark: isolated warm `zsh -i -c exit` (PTY, 5 runs) + `zprof` breakdown
    exercising the deferred Zinit path (and separately checking the no-Zinit
    fallback).
  - Functional tests: `./check.sh` and an isolated `zsh -i -c 'command -v ruby'`
    check confirming shim resolution before deferred activation.
  - Manual check (after `optimize-perf`): open a fresh Ghostty tab, confirm
    `which ruby` resolves to the direct `mise` install path after prompt load,
    and confirm `cd` into a `uv` project activates the venv.
- **ADR:** none (localized, easily reversible shell config change).

## Result
—

## Attempts
none

## Manual check
—
