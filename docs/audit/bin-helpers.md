# bin-helpers

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ 82e9c9e

- **Paths examined** — `bin/btop-themed`, `bin/git-commit-ai`, `bin/nvim-edit`, `bin/serve`. Traced sinks: `btop-themed` config generation, `defaults read`, `awk` rewrite, `mktemp`/`mv -f`/`trap`, `exec btop`; `git-commit-ai` arg parsing, `usage()`, `git add --update`, `mktemp -d`/`trap`, prompt construction, `opencode`/`codex`/`claude` execution, `jq` parsing, `sanitize()` `sed`/`awk` pipeline, `git commit --file`; `nvim-edit` `--no-wait` parsing, `NVIM_SERVER` socket resolution, process-tree ancestor walk (`ps`), TTY guard, `nvim --server ... --remote-expr` / `--remote` / `--listen`; `serve` port default and `python3 -m http.server`.
- **Invariants checked** — POSIX `sh` + `set -eu` compliance across all 4 helpers; atomic config update and cleanup on `btop-themed`; `git-commit-ai` `usage()` matches header comment (`bin/git-commit-ai:22`, failed -> `B-0005`); `git-commit-ai` `sanitize()` strips CR, wrapping fences, quotes, and `Commit message:`/`Message:`/`Subject:` prefixes on macOS BSD `sed` (`bin/git-commit-ai:176`, failed -> `B-0004`); `nvim-edit` refuses non-interactive/agent parents and deadlocking nested `NVIM` calls, replaces stale sockets via `--listen` (verified with `nvim --headless -u NONE --listen`).
- **Risks investigated** — Applied: logic correctness (`B-0004`, `B-0005`), concurrency/races (`mktemp` unique temp files/dirs), ownership/lifetime/cleanup (`trap` cleanup on `btop-themed` and `git-commit-ai`; `git-commit-ai:218` intentionally preserves message file on failed commit), error handling (`set -eu`, `die`, `refuse`), data integrity (`btop-themed` atomic `mv -f`), trust boundaries (diff treated as untrusted data in prompt, bounded by `GIT_AI_MAX_DIFF`; `ps` ancestor walk handles empty/non-numeric ppid), filesystem operations (`rm -rf "$tmp_dir"` on `mktemp -d`), missing regression coverage (only `sh -n` and `shellcheck` run in `check.sh`), documented contracts vs behaviour (`B-0004`, `B-0005`). Not applicable: confinement/isolation, serialization, extension lifecycle, user-intent/undo, performance/scaling, cross-area contracts (deferred to `nvim-server-contract`).
- **Defects** — `B-0004` (`P2`, `ui`), `B-0005` (`P3`, `ui`).
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — Read `check.sh` (`sh -n` and `shellcheck` on all 4 scripts). No behavioral tests exist for `bin/`. Reproduced `B-0004` with macOS `/usr/bin/sed` and verified `nvim --headless -u NONE --listen` on a stale socket file (`exit 0`).
