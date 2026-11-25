---
id: B-0008
title: Commit log Enter action fails to parse ANSI-colored or indented commit lines
status: fixed
severity: P2
area: nvim-git
found: 2026-11-25 @ c162be0
method: code reading
reachability: ui
commit: 1b77a9d
test: git log ANSI commit parse (nvim/tests/keymaps_spec.lua) · ran focused (nvim --headless -u NONE -l nvim/tests/keymaps_spec.lua "$PWD", passed)
manual_check: none
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
Updated `show_commit` (`nvim/lua/git/keymaps.lua:40`) to parse `selected` with
`selected_git_commit` (`git.parsers.selected_commit`) instead of raw
`selected[1]:match("^(%x+)")` (`1b77a9d`).

## Test
Added regression test in `nvim/tests/keymaps_spec.lua`; failed before the fix
(`commit log enter did not parse ANSI-colored commit`) and passed after
(`nvim --headless -u NONE -l nvim/tests/keymaps_spec.lua "$PWD"`).

## Manual check
none
