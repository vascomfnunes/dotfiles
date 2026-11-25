---
id: B-0006
title: Concurrent :GemTags runs race on tag_file and tag_file.tmp
status: fixed
severity: P2
area: nvim-lang-and-project
found: 2026-11-25 @ ab80aa3
method: code reading
reachability: ui
commit: c62431d
test: concurrent :GemTags guard (nvim/tests/tags_spec.lua) · ran focused (nvim --headless -u NONE -l nvim/tests/tags_spec.lua "$PWD", passed)
manual_check: none
---

## Problem
`nvim/lua/tags.lua:89-136` sets `vim.g.gemtags_running = true` and starts an
asynchronous pipeline (`bundle list --paths` -> `ripper-tags --tag-file
<tag_file>` -> `awk ... > <tag_file>.tmp && mv <tag_file>.tmp <tag_file>`), but
`generate_gem_tags()` never checks whether a run is already in progress.

## Trigger
Invoke `:GemTags` a second time before the first asynchronous `ripper-tags` run
finishes.

## Impact
Two `ripper-tags` / `awk` / `mv` processes concurrently write to the same
`tag_file` and `tag_file.tmp` (risking a corrupted tags file or failed `mv`),
and the first run to finish clears `vim.g.gemtags_running = nil` while the
second run is still executing.

## Fix
Added an early guard at the top of `generate_gem_tags()` (`nvim/lua/tags.lua:90-93`)
that notifies and returns when `vim.g.gemtags_running` is already set
(`c62431d`).

## Test
Added concurrent `:GemTags` regression test in `nvim/tests/tags_spec.lua`;
failed before the fix (`concurrent :GemTags spawned a second job`) and passed
after (`nvim --headless -u NONE -l nvim/tests/tags_spec.lua "$PWD"`).

## Manual check
none
