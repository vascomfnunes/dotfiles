# agents-and-opencode

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ 8fef5c8

- **Paths examined** — `agents/install-skills.sh`, `agents/test-install-skills.sh`, `agents/AGENTS.md`, `agents/templates/AGENTS.md`, `opencode/cli.json`, `opencode/agents/cavecrew-builder.md`, `opencode/agents/cavecrew-investigator.md`, `opencode/agents/cavecrew-reviewer.md`. Traced sinks: `skill_installed`, `install_skill` (`cp -R`), `install_hub_skill` (`curl`, `jq`, `shasum`, frontmatter generation), `download_source` (`curl`, `tar -xzf`), `mktemp -d`/`trap` cleanup, and OpenCode agent permission blocks.
- **Invariants checked** — All GitHub skill sources pinned to full commit SHAs; `skills-hub.ai` skill (`refactor`) verifies SHA-256 of `.instructions` before writing to `$HOME/.agents/skills`; existing skills (files, directories, symlinks, `.md`) across all three skill roots are preserved; temp directory cleaned up on `EXIT HUP INT TERM`; valid JSON in `opencode/cli.json`; no `/Users/` paths in tracked agent files; subagent permissions match their documented roles.
- **Risks investigated** — Applied: logic correctness, ownership/lifetime/cleanup (`trap 'rm -rf "$skills_tmp"'`), error handling (`set -eu`, missing `SKILL.md`, checksum mismatch), data integrity (refuses bad hash before copying), trust boundaries and validation (pinned revisions, SHA-256 check, `@json` escaping for YAML frontmatter), filesystem operations (`cp -R`, `mkdir -p`), missing regression coverage (`test-install-skills.sh` covers idempotency, preservation, and bad checksum, though not missing `SKILL.md` or symlinked existing skills), documented contracts vs behaviour. Not applicable: concurrency/races, confinement/isolation, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling, cross-area contracts (deferred to `install-path-contract`).
- **Defects** — none.
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — Read `agents/test-install-skills.sh`; verified via `./check.sh` (`sh agents/test-install-skills.sh`, `shellcheck agents/*.sh`, `jq empty opencode/cli.json`) during earlier steps. Missing test cases: existing skill as symlink or `.md` file, missing `SKILL.md` in archive, and `curl` failure.
