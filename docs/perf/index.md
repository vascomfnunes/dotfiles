# Performance index

Which hot paths were profiled, their budgets, and what the next investigation
should settle. Evidence lives in one file per hot path under `paths/`.
Method: `find-perf`, `plan-perf`, `optimize-perf`.

## Reading a cell

| Cell | Meaning |
| --- | --- |
| `YYYY-MM-DD @ commit [profiled]` | An evidence record supports it. |
| `YYYY-MM-DD @ commit [partial: <what>]` | Investigated, but the record leaves a gap. |
| `—` | Never profiled. |

A date with no evidence record is partial, however recent.

Re-read the index before writing, change only your own row, and leave the others
as you found them.

## Commands

- Benchmark: `zsh -i -c exit` (Zsh startup); `nvim --headless --startuptime <tmpfile> +q` (Neovim startup); `./check.sh` (check suite)
- Profiler: `zmodload zsh/zprof` (Zsh); `nvim --startuptime` and `vim.uv.hrtime()` (Neovim)
- Focused test: `sh agents/test-install-skills.sh` (skills) or `nvim --headless -u NONE -l nvim/tests/<spec>_spec.lua "$PWD"` with isolated `XDG_{STATE,DATA,CACHE}_HOME` (Neovim)
- Build (release): `none`
- Rules that restrict running them: Do not run `./install.sh` during profiling (it mutates `$HOME`, installs packages, and writes macOS `defaults`). Keep Neovim tests and benchmarks isolated from live user state where possible.

## Hot paths

| Hot path | Entry point | Budget | Last profile | State |
| --- | --- | --- | --- | --- |
| zsh-startup | `zsh/zshenv` | none | — | — |
| nvim-startup | `nvim/init.lua` | none | — | — |
| nvim-statusline | `nvim/lua/statusline.lua` | none | — | — |
| nvim-completion | `nvim/lua/completion.lua` | none | — | — |
| nvim-git-refresh | `nvim/lua/git.lua` | none | — | — |
| nvim-file-open | `bin/nvim-edit` | none | — | — |
| check-suite | `check.sh` | none | — | — |

## Exclusions

| Path | Reason |
| --- | --- |
| `nvim/nvim-pack-lock.json` | generated lockfile (managed by Neovim `vim.pack`) |
| `mise/mise.lock` | generated lockfile (managed by `mise`) |
| `btop/LICENSE`, `btop/themes/*.theme` | vendored Catppuccin theme files |
| `yazi/flavors/` | generated (gitignored, deployed by `ya pkg install`) |
| `.gitignore`, `AGENTS.md`, `CLAUDE.md`, `LICENSE`, `README.md`, `docs/` | repository metadata, documentation, and registers |
