# nvim-server-contract

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ ee8aa43

- **Paths examined** — Cross-checked `zsh/zshenv`, `zsh/zshrc`, `bin/nvim-edit`, `git/gitconfig`, `agents/AGENTS.md`, `nvim/init.lua`, `nvim/lua/sessions.lua`. Traced contract points: `NVIM_SERVER` socket formula, `EDITOR`/`VISUAL`/`core.editor` blocking contract, `v()` -> `nvim-edit --no-wait` handoff, `NVIM` nested deadlock guard, agent/non-TTY refusal, and shared server `--listen`/`--remote` lifecycle.
- **Invariants checked** — Socket path formula in `zsh/zshenv:8` and `bin/nvim-edit:25` is identical; blocking `$EDITOR` callers (`git/gitconfig:10`, `zsh/zshenv:12-13`) always receive a blocking local `nvim` rather than non-blocking `--remote`; `v()` passes `--no-wait` so a running server receives `--remote` and a cold start launches `--listen "$socket"`; nested `NVIM` calls bypass `--server` to prevent deadlock; non-interactive/agent callers are refused as documented in `agents/AGENTS.md:29-35`; `sessions.lua` keys by global cwd (`getcwd(-1, -1)`).
- **Risks investigated** — Applied: cross-area contracts, logic correctness, concurrency/races (stale socket replacement by `--listen` verified in step 5), error handling (non-TTY and agent-parent refusal), documented contracts vs behaviour (`README.md` and `agents/AGENTS.md` match `bin/nvim-edit` and `zsh/zshrc`). Not applicable: confinement/isolation, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling.
- **Defects** — none.
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — No cross-area integration tests exist for the `v`/`nvim-edit`/server contract; `none run` in this step (verified `--listen` stale-socket behavior in step 5).
