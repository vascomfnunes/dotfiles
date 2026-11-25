---
id: B-0005
title: git-commit-ai --help truncates GIT_AI_MAX_DIFF and GIT_AI_EDITOR
status: open
severity: P3
area: bin-helpers
found: 2026-11-25 @ 82e9c9e
method: code reading
reachability: ui
commit: —
test: —
manual_check: —
---

## Problem
`bin/git-commit-ai:21-23` implements `usage()` as
`sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'`. The header comment documenting
environment variables extends through line 14 (`GIT_AI_MAX_DIFF` on line 13 and
`GIT_AI_EDITOR` on line 14), so `usage()` cuts off the last two environment
variables.

## Trigger
Run `bin/git-commit-ai --help`.

## Impact
Users checking `--help` never see `GIT_AI_MAX_DIFF` or `GIT_AI_EDITOR`.

## Fix
—

## Test
Run `sh bin/git-commit-ai --help` and assert the output includes
`GIT_AI_MAX_DIFF` and `GIT_AI_EDITOR`.

## Manual check
none
