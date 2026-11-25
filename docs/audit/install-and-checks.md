# install-and-checks

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ 3472aa2

- **Paths examined** — `install.sh`, `check.sh`, `brew/Brewfile`, `brew/Brewfile.personal`, `brew/Brewfile.work`, `mise/config.toml` (plus `mise/mise.lock` and `opencode/cli.json` read across the boundary to verify `mise` Python pinning and `merge_json` behavior). Traced sinks: argument parsing, preflight checks, Homebrew/slk downloads and installs, `mkdir`/`chmod`, `rm`/`rmdir`/`launchctl` cleanup, `dotlink`, `merge_json`, `ya pkg install`, `pinentry-mac` link, local config stubs, Zinit clone, `gpgconf`/`mise`/`opencode` invocations, macOS `defaults`/`killall`, and all `check.sh` validations.
- **Invariants checked** — macOS guard and CLI profile/flag parsing (`install.sh:5-50`); preflight protection of whole-directory symlinks `~/.config/nvim` and `~/.config/yazi` (`install.sh:54-63`); parent directory creation before `dotlink` (`install.sh:114-123,190-223`, failed on line 216 -> `B-0001`); atomic JSON merge preserving user keys and mode 600 (`install.sh:165-187`, verified `jq` fails safely on empty live file); idempotency of local stubs (`install.sh:252-254`); `check.sh` validation coverage against `AGENTS.md`/`README.md` (`check.sh:1-55`, failed privacy scope on line 18 -> `B-0002`); `mise/config.toml` runtime pinning (Python `3.15` is locked to `3.15.2` in `mise/mise.lock`).
- **Risks investigated** — Applied: logic correctness (`B-0001`), concurrency/races (`merge_json` PID temp file, `mktemp -d`), async/cancellation cleanup (`trap` on `slk_tmp` and `nvim_test_tmp`), error handling (`set -eu`, `merge_json` failure branch), invalid state transitions and partial failure, data integrity (`merge_json` atomic replace), trust boundaries and validation (`slk` download, `B-0002`), filesystem/destructive ops (`rm -f`, `rmdir`, `ln -sfn`, preflight), serialization/compatibility (`jq` object merge), missing regression coverage (`install.sh` untested; `check.sh` does not lint itself), documented contracts vs behaviour (`B-0001`, `B-0002`). Not applicable: confinement/isolation (single-threaded shell scripts), resource limits (bounded local configs), extension/plug-in lifecycle (delegated to external CLIs), user-intent consistency (no undo), performance/scaling (one-shot scripts), cross-area contracts (deferred to `install-path-contract` boundary).
- **Defects** — `B-0001` (`P1`, `ui`), `B-0002` (`P3`, `internal`).
- **Excluded** — `mise/mise.lock` (generated lockfile, consulted only to confirm Python version pin); runtime execution of `./install.sh` (restricted by repo audit rules).
- **Uncertainty** — none.
- **Tests** — Read `check.sh`; missing automated tests for `install.sh` (preflight, `dotlink` parent creation, `merge_json` edge cases) and self-linting of `check.sh`. Ran `PATH="/opt/homebrew/bin:$PATH" GIT_CONFIG_GLOBAL=/dev/null ./check.sh` (passed) and `jq -s '.[0] as $live | .[1] as $base | ($live * $base)' /dev/null opencode/cli.json` (failed with error as expected).
