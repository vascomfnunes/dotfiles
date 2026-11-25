---
id: B-0004
title: Commit message prefix stripping fails on macOS BSD sed
status: fixed
severity: P2
area: bin-helpers
found: 2026-11-25 @ 82e9c9e
method: reproduced
reachability: ui
commit: 4fb76fb
test: none — no bin/ behavioral test suite
manual_check: none
---

## Problem
`bin/git-commit-ai:173-176` uses basic regular expression alternation in
`sed`:
`-e '1s/^\(Commit message\|Message\|Subject\):[[:space:]]*//'`.
`\|` is a GNU `sed` extension; macOS `/usr/bin/sed` (BSD `sed`) treats `\|` as
a literal pipe character, so none of `Commit message:`, `Message:`, or
`Subject:` is ever stripped from the first line of the AI output.

## Trigger
Run `sanitize` (or `git commit-ai --print` with an AI response beginning with
`Commit message: Fix bug` on macOS):
`printf 'Commit message: Fix bug\n' | LC_ALL=C /usr/bin/sed -e '1s/^\(Commit message\|Message\|Subject\):[[:space:]]*//'`
outputs `Commit message: Fix bug` unchanged.

## Impact
Generated commit messages that include a `Commit message:`, `Message:`, or
`Subject:` preamble retain that prefix in the subject line.

## Fix
Replaced the GNU BRE alternation `-e` in `bin/git-commit-ai:176` with three
portable POSIX `sed` `-e` expressions for `Commit message:`, `Message:`, and
`Subject:` (`4fb76fb`).

## Test
`none — no bin/ behavioral test suite`: verified all three prefixes strip to
`Fix bug` with macOS `/usr/bin/sed`, plus `sh -n bin/git-commit-ai` and
`shellcheck bin/git-commit-ai`.

## Manual check
none
