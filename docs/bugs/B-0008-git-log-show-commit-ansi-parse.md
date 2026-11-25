---
id: B-0008
title: Commit log Enter action fails to parse ANSI-colored or indented commit lines
status: open
severity: P2
area: nvim-git
found: 2026-11-25 @ c162be0
method: code reading
reachability: ui
commit: —
test: —
manual_check: —
---

## Problem
`nvim/lua/git/keymaps.lua:39-41` (`show_commit`, bound to `<CR>` in the
`<leader>gl` commit log picker) extracts the commit hash with
`selected[1]:match("^(%x+)")` instead of using `selected_git_commit`
(`require("git.parsers").selected_commit`, already imported on line 5). Unlike
`selected_git_commit`, the raw match does not strip ANSI escape sequences or
leading whitespace.

## Trigger
Select a commit line beginning with an ANSI color sequence (e.g.,
`"\27[33mdeadbeef\27[0m yesterday Fix bug"`) or leading whitespace in the
`<leader>gl` commit picker and press `<CR>`.

## Impact
`show_commit` returns early without opening the commit preview buffer.

## Fix
—

## Test
Add a regression test in `nvim/tests/keymaps_spec.lua` invoking `git_log`'s
`actions.enter` with an ANSI-colored commit line and asserting `git show` is
invoked with the parsed commit hash.

## Manual check
none
