---
id: B-0002
title: Privacy check skips tracked agent files under agents/
status: open
severity: P3
area: install-and-checks
found: 2026-11-25 @ 3472aa2
method: code reading
reachability: internal
commit: —
test: —
manual_check: —
---

## Problem
`AGENTS.md` states that `./check.sh` "rejects private home paths in tracked
agent configs" and that agent configuration must use `$HOME` rather than
absolute home-directory paths. `agents/AGENTS.md` is linked directly into
`~/.config/opencode/AGENTS.md` (`install.sh:216`), yet `check.sh:18` runs
`grep -R -n '/Users/' opencode` and does not scan `agents/`.

## Trigger
Add an absolute path such as `/Users/alice/foo` to `agents/AGENTS.md`,
`agents/templates/AGENTS.md`, or `agents/install-skills.sh` and run
`./check.sh`.

## Impact
`./check.sh` passes with exit code 0 and fails to catch private home-directory
paths in tracked agent configuration under `agents/`.

## Fix
—

## Test
Add a regression check verifying that a `/Users/` match under `agents/` causes
the privacy check in `check.sh` to fail non-zero.

## Manual check
none
