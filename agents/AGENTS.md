# Global agent instructions

These instructions apply to every repository on this machine. A project-level
`AGENTS.md` overrides them where it is more specific.

## Environment

- macOS on Apple silicon. Interactive shells are Zsh; repository scripts are
  POSIX `sh`.
- Runtimes are managed by Mise (`ruby`, `node`, `python`). Run `mise install`
  after cloning a project and prefer `mise exec --` over global installs.
- Terminal: Ghostty with tmux. Editor: Neovim 0.12 or newer.
- Prefer `rg` and `fd` for search. `bat`, `eza`, `jq`, and `tree-sitter` are
  available; use `ast-grep` when it is installed.

## Working agreements

- Do not push, force-push, rewrite history, or delete branches unless asked.
- Do not run `git reset --hard`, `git clean -fd`, or `rm -rf` on user data.
- Do not commit secrets, credentials, `.env` files, or machine-specific paths.
- Keep diffs focused. Do not reformat or refactor unrelated code.
- Match the surrounding style and use the project's formatter and linter.
- If a task is ambiguous or destructive, ask before acting.
- Report what you changed and what you verified. Do not claim success without
  running a check.

## Editor handoff

Neovim may run as a shared server at `$NVIM_SERVER`.

- To open a file in the user's running Neovim without blocking:
  `nvim-edit --no-wait <file>`
- Never invoke an interactive editor from an agent. `git commit` without `-m`
  will be refused rather than hang.
- Commit with `git commit -m "..."` or `git commit -F <file>`.

## Verification

- Before declaring work complete, run the project's documented check:
  `just check`, `make check`, `npm test`, `bin/ci`, or `./check.sh`.
- If no check exists, say so and list the commands you ran manually.
- Report failures with the exact command and the relevant output.
- Add or update tests when behavior changes.

## Git

- Use the repository's commit style. When it is undocumented, write an
  imperative subject in sentence case, no trailing period, and a short body
  that explains why.
- Keep each commit to one coherent change.
- Never bypass hooks with `--no-verify` unless the user asks.
- Sign commits only if the repository already requires it.

## Secrets and safety

- Never print or copy `~/.ssh`, `~/.gnupg`, keychain contents, or `.env` files.
- Ask before adding dependencies, changing schemas, or running migrations.
- Do not send repository contents to external services unless the user asks.

## Music and audio

- Audio work is CLI-accessible: `ffmpeg`, `ffprobe`, `sox` (when installed),
  `mpv`, and `rubberband`. Prefer non-destructive processing and write new
  files rather than overwriting sources.
- Never modify DAW project files (`.als`, `.logicx`, `.flp`, `.ptx`, `.rpp`)
  in place. Work on a copy and leave the original untouched.
- For plugin builds, run the project's `pluginval` and `auval` checks and
  report the validation level used.

## Communication

- Be concise. Lead with the result, then the reasoning.
- Cite files as `path:line` so the user can jump to them.
- Show the diff for non-trivial edits.
- Do not narrate routine tool calls.
