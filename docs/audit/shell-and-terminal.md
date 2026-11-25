# shell-and-terminal

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ 783ff5c

- **Paths examined** — Re-read `zsh/zshenv` and `zsh/zshrc` after `B-0003` (`181e63e`), plus unchanged `starship.toml`, `ghostty/config`, `yazi/package.toml`, `yazi/theme.toml`.
- **Invariants checked** — Confirmed `MANPAGER` is exported inside `zsh/zshrc:115-118` after `/etc/zprofile` adds Homebrew to `PATH`; re-verified `source_command_cache`, `dotupdate`, `y()`, `zcompdump`, and Zinit loading.
- **Risks investigated** — Applied: logic correctness, error handling, filesystem operations, concurrency/races, documented contracts vs behaviour. Not applicable: confinement/isolation, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling, cross-area contracts (checked in boundary audits).
- **Defects** — none (previously registered `B-0003` verified fixed).
- **Excluded** — `yazi/flavors/` (generated, gitignored).
- **Uncertainty** — none.
- **Tests** — `none run` in this step (`zsh -n` and login-shell `MANPAGER` check passed at `181e63e` with no subsequent changes).

## 2026-11-25 @ 18f0fab

- **Paths examined** — `zsh/zshenv`, `zsh/zshrc`, `starship.toml`, `ghostty/config`, `yazi/package.toml`, `yazi/theme.toml`. Traced sinks: environment exports and `PATH`/`MANPAGER` setup (`zsh/zshenv:3-32`), state/cache directory creation (`zsh/zshrc:10-13`), `dotupdate` path resolution and subshell execution (`zsh/zshrc:67-74`), `source_command_cache` atomic cache write and `zcompile` (`zsh/zshrc:77-103`), `y()` temp file creation and `cd` (`zsh/zshrc:121-132`), `zcompdump` age check and `compinit` (`zsh/zshrc:150-162`), Zinit plugin loading (`zsh/zshrc:173-182`), local override sourcing (`zsh/zshrc:205-212`), and Ghostty/Starship/Yazi config keys.
- **Invariants checked** — `ZDOTDIR`/`PATH`/`NVIM_SERVER`/`EDITOR`/`VISUAL`/`MANPAGER` exports (`zsh/zshenv`, failed on `MANPAGER` in login shell startup -> `B-0003`); `dotupdate` `${${(%):-%x}:A:h:h}` resolution inside a sourced function (verified via isolated zsh test); cache atomicity and failure cleanup in `source_command_cache` (`mv -f` on success, `rm -f` on failure); Yazi flavor names matching `package.toml` and `theme.toml`; Ghostty `nvim/` key table and `Ctrl+A` leader bindings.
- **Risks investigated** — Applied: logic correctness (`B-0003`, verified `dotupdate` `%x`), concurrency/races (`source_command_cache` uses PID temp file for `.zsh`; `.zwc` compile is non-atomic on simultaneous first launch, low impact), ownership/lifetime/cleanup (`y()` `cwd_file` removed on normal exit), error handling (`source_command_cache` discards failed output), filesystem operations (`mkdir -p`, `mv -f`, `rm -f`), missing regression coverage (only `zsh -n` syntax check exists), documented contracts vs behaviour (`B-0003`). Not applicable: confinement/isolation, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling, cross-area contracts (deferred to `nvim-server-contract` and `install-path-contract`).
- **Defects** — `B-0003` (`P3`, `ui`).
- **Excluded** — `yazi/flavors/` (generated, gitignored).
- **Uncertainty** — none.
- **Tests** — Read `check.sh` (`zsh -n zsh/zshrc zsh/zshenv`). No behavioral Zsh tests exist. Reproduced `B-0003` with `env -i HOME="$tmp" PATH="/usr/bin:/bin:/usr/sbin:/sbin" zsh -lc 'print -r -- "MANPAGER=${MANPAGER-<unset>}"'`.
