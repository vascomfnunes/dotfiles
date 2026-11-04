# <Project> agent instructions

<!--
Copy this file to the repository root as `AGENTS.md`. Claude Code users should
also create `CLAUDE.md` with the single line `@AGENTS.md`, or symlink it.
Delete sections that do not apply and replace every placeholder.
-->

## What this is

<One paragraph: purpose, main entry points, and anything surprising about the
codebase.>

## Stack

- Language and runtime:
- Framework:
- Package manager:
- Database and external services:

## Commands

| Task    | Command   |
| ------- | --------- |
| Install | `<...>`   |
| Dev     | `<...>`   |
| Test    | `<...>`   |
| Lint    | `<...>`   |
| Format  | `<...>`   |
| Build   | `<...>`   |

Run the narrowest useful command while iterating and the full check before
declaring work complete.

## Architecture

<Key directories and the flow between them. Call out generated files, vendored
code, and anything that must not be edited by hand.>

## Conventions

- <Error handling, logging, naming, and testing patterns>
- <Formatting and lint rules, and the command that enforces them>
- <Commit message style>

## Boundaries

- Do not edit: `<generated/`, `vendor/`, lockfiles>
- Do not run: `<destructive commands, deploys, migrations>`
- Ask before: `<schema changes, dependency upgrades, public API changes>`

## Definition of done

- [ ] Tests added or updated
- [ ] `<check command>` passes
- [ ] No secrets or machine-specific paths added
- [ ] Diff is focused and explained
