# nvim-core

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ 8dc3982

- **Paths examined** — Re-checked `nvim/init.lua`, `nvim/lua/{options,keymaps,lazyload,packs,plugins,pins,statusline,sessions}.lua`, `nvim/tests/statusline_spec.lua` (unchanged since `fa5bc4b`), and updated `nvim/tests/keymaps_spec.lua` (`1b77a9d`).
- **Invariants checked** — Native `vim.pack` and `lazyload.lua` loaders, `sessions.lua` escaping and empty-session guard, `pins.lua` persistence, `statusline.lua` `%` escaping and `LspDetach` cleanup, `keymaps.lua` reference copying and `BufReadPost` guard.
- **Risks investigated** — Applied: logic correctness, async ordering/staleness, ownership/lifetime/cleanup, error handling, data integrity, filesystem operations, plugin lifecycle, missing regression coverage, documented contracts vs behaviour. Not applicable: concurrency/races, confinement/isolation, resource limits, user-intent/undo, performance/scaling, cross-area contracts.
- **Defects** — none.
- **Excluded** — `nvim/nvim-pack-lock.json` (generated lockfile).
- **Uncertainty** — none.
- **Tests** — `none run` in this step (`keymaps_spec.lua` and `statusline_spec.lua` passed in `./check.sh` at `0f7346c` with no subsequent changes).

## 2026-11-25 @ fa5bc4b

- **Paths examined** — `nvim/init.lua`, `nvim/lua/options.lua`, `nvim/lua/keymaps.lua`, `nvim/lua/lazyload.lua`, `nvim/lua/packs.lua`, `nvim/lua/plugins.lua`, `nvim/lua/pins.lua`, `nvim/lua/statusline.lua`, `nvim/lua/sessions.lua`, `nvim/tests/keymaps_spec.lua`, `nvim/tests/statusline_spec.lua`. Traced sinks: `vim.pack.add` / `packadd` (`packs.lua`), `setup_once` and `GitConflictDetected`/`Resolved` diagnostic toggling (`lazyload.lua`), `vim.system` (`ToolsSync`), `treesitter.install():await` (`plugins.lua:44`), `io.open(..., "w")` (`pins.lua:21`), `mksession!`/`source` (`sessions.lua:28,37`), clipboard `setreg` and `BufReadPost` cursor restore (`keymaps.lua`), and `LspProgress`/`LspDetach` statusline rendering (`statusline.lua`).
- **Invariants checked** — Native `vim.pack` usage with lazy loading through `lazyload.lua` (`packs.lua`, verified Neovim 0.12 `:help vim.pack.add()` that `load = false` performs `:packadd!` and `load = function() end` defers runtimepath); `sessions.lua` escapes `%` in session filenames via `vim.fn.fnameescape` (verified in Neovim 0.12) and skips saving empty sessions; `pins.lua` keys by global cwd (`getcwd(-1, -1)`); `statusline.lua` escapes `%` in dynamic values and clears progress on `LspDetach`; `keymaps.lua` skips cursor restore for `COMMIT_EDITMSG`/`MERGE_MSG`.
- **Risks investigated** — Applied: logic correctness, async ordering/staleness (`treesitter.install():await` checks `nvim_buf_is_valid`, `LspDetach` clears orphaned progress entries), ownership/lifetime/cleanup (`BufWipeout` clears `diagnostics_enabled[buf]`), error handling (`pcall` around `vim.treesitter.start`, `nvim_win_set_cursor`, `vim.json.decode`), data integrity (`sessions.lua` refuses to overwrite with empty session; `pins.lua` uses in-place `io.open("w")` — low risk for single-user interactive toggle), filesystem operations (`fnameescape` on `edit`/`mksession!`/`source`/`packadd`), extension/plugin lifecycle (`setup_once` idempotency, `PackChanged` hooks), missing regression coverage (`pins.lua`, `sessions.lua`, `packs.lua`, `lazyload.lua` have no specs), documented contracts vs behaviour. Not applicable: concurrency/races (single-threaded Neovim Lua loop), confinement/isolation, resource limits, user-intent/undo, performance/scaling, cross-area contracts (deferred to `nvim-server-contract`).
- **Defects** — none.
- **Excluded** — `nvim/nvim-pack-lock.json` (generated lockfile).
- **Uncertainty** — none.
- **Tests** — Read `nvim/tests/keymaps_spec.lua` and `nvim/tests/statusline_spec.lua` (both ran and passed in `./check.sh` during step 2). Missing specs for `pins.lua`, `sessions.lua`, `packs.lua`, and `lazyload.lua`. Verified `vim.fn.fnameescape` and `:help vim.pack.add()` in Neovim 0.12 headless.
