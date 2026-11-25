---
id: B-0006
title: Concurrent :GemTags runs race on tag_file and tag_file.tmp
status: open
severity: P2
area: nvim-lang-and-project
found: 2026-11-25 @ ab80aa3
method: code reading
reachability: ui
commit: —
test: —
manual_check: —
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
—

## Test
Add a regression test in `nvim/tests/tags_spec.lua` that invokes `:GemTags`
twice while the first `vim.system` call is pending and asserts that the second
invocation is rejected without spawning a second `vim.system` job.

## Manual check
none
