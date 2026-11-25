# nvim-git

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ c162be0

- **Paths examined** — `nvim/lua/git.lua`, `nvim/lua/git/keymaps.lua`, `nvim/lua/git/operation.lua`, `nvim/lua/git/parsers.lua`, `nvim/lua/git/status.lua`, `nvim/tests/git_parsers_spec.lua`. Traced sinks: `vim.system` git commands (`fetch`, `pull`, `commit`, `push`, `switch`, `stash`, `add`, `reset`, `abort`, `show`, `for-each-ref`, `status`), `vim.fn.jobstart` terminal commands (`continue`, `amend`, `rebase -i`, `merge`, `cherry-pick`), `git-commit-ai --print` + `edit_commit_message` temp file write/delete (`BufWriteCmd`), `VimLeavePre` timer cleanup, `fzf-lua` pickers and `CodeDiff` command invocations.
- **Invariants checked** — `operations[root]` + `index.lock` + `git.operation.detect` gate conflicting Git commands (`git.lua:75-101`); `git/status.lua` single-flight `checker` coalesces forced updates without stale overwrite; `git/keymaps.lua:106` shell-escapes branch name and `git.lua:570,587` passes `--` and validates commit hex; `edit_commit_message` preserves draft file on commit failure and deletes on success; `show_commit` (`git/keymaps.lua:40`) bypassed `git.parsers.selected_commit` -> `B-0008`.
- **Risks investigated** — Applied: logic correctness (`B-0008`), async ordering/cancellation/staleness (`git/status.lua` single-flight `checker`, `operations[root]` lock, `stop_progress()` timer stop/close), ownership/lifetime/cleanup (`VimLeavePre` timer close, `BufWipeout` augroup cleanup, `bufhidden = "wipe"`), error handling (`git_error`, `job <= 0` cleanup, `BufWriteCmd` error path), data integrity (temp commit draft kept on failure), trust boundaries (`shellescape`, `fnameescape`, `^%x+$` commit check), filesystem operations (`index.lock` check, `writefile`/`delete`), missing regression coverage (`git.lua` operations and `git/status.lua` have no specs; `keymaps_spec.lua` does not execute `git_log` `actions.enter`), documented contracts vs behaviour. Not applicable: confinement/isolation, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling, cross-area contracts.
- **Defects** — `B-0008` (`P2`, `ui`).
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — Read `nvim/tests/git_parsers_spec.lua` (passed in `./check.sh` during step 2). Missing specs: `git/status.lua`, `git.lua` command/operation flows, and `show_commit` ANSI parsing.
