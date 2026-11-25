# Bug register

One file per known defect, `<id>-<slug>.md`. Ids are zero-padded, monotonic and
never reused; a new entry takes the highest existing id plus one, created
exclusively (`set -C` in the shell, or an `O_EXCL` create) and retried with the
next id if the name already exists.

## Entry

```md
---
id: B-0001
title: A pasted section can place clips before beat zero
status: open
severity: P2
area: arrangement
found: 2026-01-01 @ abc1234
method: code reading
reachability: hostile input
commit: —
test: —
manual_check: —
---

## Problem
The mechanism, with `path:line`.

## Trigger
The concrete input, interleaving or state that produces the wrong outcome.

## Impact
What the user loses or sees.

## Fix
The smallest correction and its commit — filled when fixed.

## Test
The named regression test, its file, and whether it ran.

## Manual check
Only when a person must confirm it; `none` otherwise.
```

Avoid `:` inside frontmatter values; separate clauses with `·`. Quote a value
only when a colon is unavoidable.

## Rules

- `status`: `open` · `fixed` · `deferred` · `wontfix`. Lifecycle only.
- `severity`: `P0` data loss, corruption, security breach or unusable product ·
  `P1` major failure with a workaround · `P2` significant wrong behaviour,
  performance or usability · `P3` minor. The consequence goes in **Impact**.
- `method`: `code reading` · `reproduced` · `owner report`.
- `reachability`: `ui` · `public api` · `hostile input` · `internal`. Severity
  follows from it.
- `commit`: short hash of the fix commit when fixed, `—` while open. The fix is
  committed before the entry, so the hash always names an existing commit.
- `test`: `—` while open, `none — <reason>`, `written, not run`, or
  `<name> (<file>) · ran focused (<command>, <result>)`.
- `manual_check`: `—` while open, `none`, `pending — <what to try>`, or
  `done <date>`.

A finding without a named trigger and a wrong outcome is not an entry; it
belongs on its area's `Open suspicions` line. Never weaken an entry to close
it: if the mechanism was wrong, correct the entry and say so.
