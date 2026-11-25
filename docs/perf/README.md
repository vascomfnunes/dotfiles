# Performance register

One file per bottleneck, `<id>-<slug>.md`. Ids are zero-padded, monotonic and
never reused; a new entry takes the highest existing id plus one, created
exclusively (`set -C` in the shell, or an `O_EXCL` create) and retried with the
next id if the name already exists.

## Entry

```md
---
id: P-0001
title: Redundant JSON decode on every startup frame
status: suspected
severity: P2
hot_path: startup
found: 2026-01-01 @ abc1234
method: code reading
baseline: not measured — no benchmark command yet
target: —
commit: —
result: —
manual_check: —
---

## Bottleneck
The mechanism, with `path:line`, and the scaling input that triggers it.

## Baseline
Exact command, build mode, workload, environment and observed metric — or
`not measured — <reason>` while `suspected`.

## Impact
What user-visible latency, throughput, memory or resource budget is affected.

## Optimization plan
Filled by `plan-perf` after grilling trade-offs with the user: chosen approach,
accepted trade-offs, target delta, blast radius, verification method and any
related ADR.

## Result
Filled by `optimize-perf` when `optimized`: what changed, its commit, the
before/after measurement on the same command, and functional test verification.

## Attempts
Failed or reverted optimization attempts, with date, approach tried and observed
numbers so future runs do not repeat dead ends. `none` until needed.

## Manual check
Only when a person must confirm it (e.g., visual smoothness, real hardware);
`none` otherwise.
```

Avoid `:` inside frontmatter values; separate clauses with `·`. Quote a value
only when a colon is unavoidable.

## Rules

- `status`: `suspected` · `confirmed` · `planned` · `optimized` · `refuted` ·
  `deferred` · `wontfix`.
  - `suspected`: concrete static mechanism, no measured baseline yet.
  - `confirmed`: reproducible baseline measurement recorded.
  - `planned`: optimization plan grilled and approved by the user; ready for
    `optimize-perf`.
  - `optimized`: implemented, verified against functional tests and measurement,
    and committed.
  - `refuted`: measurement proved the bottleneck is negligible or absent.
- `severity`: `P0` budget breach making the product unusable or OOM/hang ·
  `P1` severe budget breach on a primary hot path · `P2` noticeable latency,
  throughput or memory drag · `P3` minor overhead.
- `method`: `profiled` · `benchmarked` · `code reading` · `owner report`.
- `baseline`: `<metric> (<command>, <build mode>)` or
  `not measured — <reason>`.
- `target`: `—` until planned, then the agreed target delta or budget
  (e.g., `p95 < 50ms` or `>= 30% allocation reduction`).
- `commit`: short hash of the optimization commit when `optimized`, `—`
  otherwise. The code change is committed before the entry is updated.
- `result`: `—` until `optimized`, then
  `<before> -> <after> (<delta>) · ran (<command>)` or
  `not measured — <reason>`.
- `manual_check`: `—` until `optimized`, then `none`,
  `pending — <what to try>`, or `done <date>`.

An unverified hunch without a concrete mechanism is not an entry; it belongs on
its hot path's `Open suspicions` list. Never promote `suspected` to `confirmed`
without a measurement, and never execute an optimization whose status is not
`planned`.
