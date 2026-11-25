# nvim-lang-and-project

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ b57921b

- **Paths examined** — Re-read `nvim/lua/tags.lua` and `nvim/lua/lsp.lua` after `B-0006` (`c62431d`) and `B-0007` (`c0423e3`), plus unchanged `completion.lua`, `css_classes.lua`, `project.lua`, and all 4 specs (`css_classes_spec.lua`, `lsp_spec.lua`, `project_spec.lua`, `tags_spec.lua`).
- **Invariants checked** — Confirmed `generate_gem_tags` rejects concurrent runs while `vim.g.gemtags_running` is set (`tags.lua:90-93`); confirmed `enable_signature_help` deletes `DotfilesSignatureHelp<buf>:<client>` on matching `LspDetach` (`lsp.lua:54-62`); re-verified `completion.lua`, `css_classes.lua`, and `project.lua`.
- **Risks investigated** — Applied: logic correctness, async ordering/cancellation/staleness, ownership/lifetime/cleanup, error handling, data integrity, trust boundaries, filesystem operations, missing regression coverage, documented contracts vs behaviour. Not applicable: confinement/isolation, resource limits, serialization, user-intent/undo, performance/scaling, cross-area contracts.
- **Defects** — none (previously registered `B-0006` and `B-0007` verified fixed with regression tests).
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — `none run` in this step (`css_classes_spec.lua`, `lsp_spec.lua`, `project_spec.lua`, `tags_spec.lua` passed in `./check.sh` at `0f7346c` with no subsequent changes).

## 2026-11-25 @ ab80aa3

- **Paths examined** — `nvim/lua/lsp.lua`, `nvim/lua/completion.lua`, `nvim/lua/css_classes.lua`, `nvim/lua/tags.lua`, `nvim/lua/project.lua`, `nvim/tests/css_classes_spec.lua`, `nvim/tests/project_spec.lua`, `nvim/tests/tags_spec.lua`. Traced sinks: `LspAttach` handlers (`enable_completion`, `enable_signature_help`, `enable_document_highlight`), `vim.lsp.rpc.start` (`ruby_lsp`), `completion.lua` deferred documentation popup styling, `css_classes.lua` filesystem walk and in-process LSP server, `tags.lua` `git rev-parse`, `with_file` `vim.bo.tags` mutation, `definition_or_tag` async LSP + `tjump` fallback, `generate_gem_tags` 3-stage `vim.system` pipeline and `sh -c` `awk`/`mv` sanitize, and `project.lua` `lcd`/`cd` and `MiniFilesBufferCreate` keymap.
- **Invariants checked** — `LspAttach`/`LspDetach` symmetry for buffer-local autocmds (`lsp.lua:29-85`, failed for `enable_signature_help` -> `B-0007`); `completion.lua` generation counter prevents stale deferred styling after `CompleteChanged`/`CompleteDone`; `css_classes.lua` UTF-16 column math and excluded directories (`node_modules`, `public/assets`, `public/packs`); `tags.lua` restores `vim.bo.tags` and `tagfunc` on error and checks `context_valid()` before async fallback, but fails to guard concurrent `:GemTags` runs (`tags.lua:89-136` -> `B-0006`); `project.lua` caches per-buffer root and respects explicit `selected_root`.
- **Risks investigated** — Applied: logic correctness, async ordering/cancellation/staleness (`tags.lua` `context_valid()` and concurrent `:GemTags` race -> `B-0006`; `completion.lua` `documentation_request` counter), ownership/lifetime/cleanup (`lsp.lua` `LspDetach` leak -> `B-0007`), error handling (`pcall` around `treesitter`, `readfile`, `tjump`, `nvim_win_set_config`), data integrity (concurrent `tag_file.tmp` overwrite in `B-0006`), trust boundaries (`shellescape(tag_file)` in `tags.lua:98`, `fnameescape` in `tags.lua:20` and `project.lua:22,34`), filesystem operations, missing regression coverage (`lsp.lua`, `completion.lua`, and `:GemTags` in `tags.lua` have no specs), documented contracts vs behaviour. Not applicable: confinement/isolation, resource limits, serialization, user-intent/undo, performance/scaling, cross-area contracts.
- **Defects** — `B-0006` (`P2`, `ui`), `B-0007` (`P3`, `internal`).
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — Read `nvim/tests/css_classes_spec.lua`, `nvim/tests/project_spec.lua`, `nvim/tests/tags_spec.lua` (all passed in `./check.sh` during step 2). Missing specs: `lsp.lua` attach/detach lifecycle, `completion.lua`, and `:GemTags` concurrency/error paths.
