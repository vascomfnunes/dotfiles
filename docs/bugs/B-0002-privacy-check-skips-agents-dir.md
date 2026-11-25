---
id: B-0002
title: Privacy check skips tracked agent files under agents/
status: fixed
severity: P3
area: install-and-checks
found: 2026-11-25 @ 3472aa2
method: code reading
reachability: internal
commit: f7173fd
test: none — no correct seam
manual_check: none
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
Updated `check.sh:18` to pass both `agents` and `opencode` to
`grep -R -n '/Users/'` (`f7173fd`).

## Test
`none — no correct seam`: `check.sh` is the top-level check runner without an
isolated test harness for its own assertions. Verified with `./check.sh` and
`shellcheck check.sh`.

## Manual check
none
