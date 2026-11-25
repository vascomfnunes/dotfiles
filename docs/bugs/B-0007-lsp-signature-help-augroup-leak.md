---
id: B-0007
title: Signature help autocmd leaks on LspDetach
status: open
severity: P3
area: nvim-lang-and-project
found: 2026-11-25 @ ab80aa3
method: code reading
reachability: internal
commit: —
test: —
manual_check: —
---

## Problem
`nvim/lua/lsp.lua:29-54` (`enable_signature_help`) creates a buffer-local
`InsertCharPre` autocmd inside augroup `DotfilesSignatureHelp<buf>:<client_id>`,
but unlike `enable_document_highlight` (`nvim/lua/lsp.lua:72-84`), it never
registers an `LspDetach` handler to delete that augroup when the client
detaches.

## Trigger
Attach an LSP client with `signatureHelpProvider` to a buffer, detach/restart
the client (emitting `LspDetach` and a new `LspAttach` with a new `client_id`),
and type a trigger character in insert mode.

## Impact
The detached client's `DotfilesSignatureHelp<buf>:<old_client_id>` augroup
remains active on the buffer, firing extra `vim.lsp.buf.signature_help`
requests on every trigger character for the lifetime of the buffer.

## Fix
—

## Test
Add a test that triggers `LspAttach` then `LspDetach` for a mock client with
`signatureHelpProvider` and asserts the `DotfilesSignatureHelp<buf>:<id>`
augroup no longer has any `InsertCharPre` autocmds.

## Manual check
none
