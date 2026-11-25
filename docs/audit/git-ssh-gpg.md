# git-ssh-gpg

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

- `git/gitconfig:38` — `difftool.codediff.cmd` passes `+"CodeDiff file $LOCAL $REMOTE"` without quoting `$LOCAL`/`$REMOTE` (unlike `mergetool.codediff.cmd` at line 44, which quotes `\"$MERGED\"`), so paths containing spaces may split into extra arguments. `blocked — depends on how the external codediff.nvim plugin parses :CodeDiff file arguments.`

## 2026-11-25 @ abf3914

- **Paths examined** — `git/gitconfig`, `git/gitignore`, `ssh/config`, `gpg/gpg-agent.conf`. Traced sinks: `core.editor` (`nvim-edit`), `difftool.codediff.cmd` and `mergetool.codediff.cmd`, `gpg.program`, `includeIf`/`include` paths, `credential.*.helper`, SSH `ControlMaster`/`ControlPath` ordering, and `pinentry-program`.
- **Invariants checked** — Valid Git config syntax (verified with `git config --file git/gitconfig --list`); `Host github.com bitbucket.org` disables multiplexing before `Host *` (OpenSSH first-match-wins); `IgnoreUnknown AddKeysToAgent,UseKeychain` guards macOS-specific SSH options; `ControlPath ~/.ssh/sockets/%C` hashes connection tuple under socket path length limits; global gitignore excludes `.env`, `*secrets.env*`, and local Claude settings; GPG signing and `pinentry-program` path align with `install.sh`.
- **Risks investigated** — Applied: logic correctness (SSH `Host` precedence, Git `includeIf`), trust boundaries and validation (`difftool.codediff.cmd` unquoted `$LOCAL`/`$REMOTE` -> open suspicion), data integrity (`mergetool.keepBackup = false`, `rerere.enabled = true`), documented contracts vs behaviour (`README.md` local config overrides `~/.gitconfig.local` and `~/repos/.gitconfig`). Not applicable: concurrency/races, async/cancellation, confinement/isolation, ownership/lifetime, error handling, state transitions, partial failure, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling, cross-area contracts (deferred to `install-path-contract`).
- **Defects** — none.
- **Excluded** — none.
- **Uncertainty** — Open suspicion at `git/gitconfig:38` (`blocked` on external `codediff.nvim` argument parsing).
- **Tests** — No automated tests exist for `git/`, `ssh/`, or `gpg/`. Ran `GIT_CONFIG_GLOBAL=/dev/null /opt/homebrew/bin/git config --file git/gitconfig --list` (exit 0).
