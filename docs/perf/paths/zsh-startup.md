# zsh-startup

Method and cell grades: [index](../index.md). Newest record first.

## Open suspicions

- `zsh/zshrc:176-183` — synchronous `source "$ZINIT_HOME/zinit.zsh"` and Turbo
  registration (`fzf-tab`, `zsh-autosuggestions`, `zsh-syntax-highlighting`)
  were skipped in the isolated `$HOME` benchmark because `$ZINIT_HOME` lives in
  the live user directory outside the sandbox. Settled by profiling a real
  `HOME` (or copying `zinit.git` into an isolated temp `HOME`) with `zprof`.
- `zsh/zshrc:18-24` — loading a populated `HISTFILE` (`SAVEHIST=50000`,
  `HISTSIZE=60000`, `setopt share_history`) was not measured because the
  isolated run started with an empty history file. Settled by timing `zsh -i -c
  exit` with a synthetic 50,000-line history file.

## 2026-11-25 @ 0e4a670

- **Paths examined** — `zsh/zshenv`, `zsh/zshrc`, `starship.toml`, plus the
  generated init caches (`starship.zsh`, `mise.zsh`, `zoxide.zsh`, `fzf.zsh`,
  `atuin.zsh`).
- **Measurements** — Isolated `$HOME` benchmark (macOS arm64, Homebrew binaries,
  `ZDOTDIR=$tmp/.config/zsh` symlinked to repo `zsh/zshenv` and `zsh/zshrc`):
  - Cold `zsh -i -c exit`: 326.6 ms (first run, populates `zcompdump` + 5 init
    caches; `compinit` 156.05 ms in `zprof`).
  - Warm `zsh -i -c exit` (non-PTY, stdin TTY): 50.7–54.3 ms; PTY (5 runs):
    52.5 ms median (52.1–53.6 ms).
  - Warm `zshrc` `EPOCHREALTIME` + `zprof` breakdown (44.18 ms inside `zshrc`):
    `Optional command replacements` 4.51 ms, `compinit -C` 3.56 ms (2.58 ms in
    `compinit`), `starship` 7.06 ms, `mise` 16.31 ms (`_mise_hook` 13.24 ms,
    34.59% of `zprof`), `zoxide` 0.89 ms, `fzf` 2.44 ms, `atuin` 9.02 ms.
  - Standalone subprocess medians (10 runs each): `mise hook-env -s zsh`
    12.55 ms, `atuin uuid` 5.74 ms, `atuin __internal pty-proxy-active`
    5.22 ms, `starship prompt --continuation` 4.63 ms, bare `zsh -f -c exit`
    3.59 ms, 5× `$(command -v zsh)` 7.66 ms vs 5× `$commands[zsh]` 6.10 ms.
- **Categories investigated** — Applied: algorithmic complexity and scaling
  (cold `compinit` 795 `compdef` calls, `HISTSIZE` scaling), I/O and subprocess
  overhead, concurrency/scheduling (synchronous vs deferred tool hooks),
  caching and redundant work (`source_command_cache`, `zcompdump`), startup
  cost. Did not apply: database/query patterns (no DB at shell startup),
  memory/GC pressure (short-lived init scripts), UI/layout, real-time paths,
  payload/transfer footprint.
- **Bottlenecks** — `P-0001` (`confirmed`, `P2`), `P-0002` (`confirmed`, `P3`),
  `P-0003` (`confirmed`, `P3`), `P-0004` (`confirmed`, `P3`).
- **Excluded** — Live `$HOME/.zshrc.local` (machine-specific, untracked),
  `$HOME/.local/share/zinit` (outside sandbox), live `HISTFILE`, and post-startup
  interactive `starship prompt` rendering in large Git repositories.
- **Uncertainty** — Two open suspicions above (`zinit.zsh` synchronous load and
  50,000-line `HISTFILE` load) remain unmeasured in the isolated environment.
