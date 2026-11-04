# Dotfiles repository

This repository is the source of truth for the machine configuration. The
installer symlinks most files into `$HOME`; edit the repository copy, not the
symlinked destination.

Read `README.md` and `install.sh` before adding a managed path.

## Before committing

Run the repository checks:

```sh
./check.sh
```

This validates POSIX shell, Zsh, JavaScript, and JSON syntax, runs ShellCheck
and the Neovim test suite, rejects private home paths in tracked agent configs,
and checks staged and unstaged changes for whitespace errors.

Do not commit machine-specific overrides such as `~/.zshrc.local`,
`~/.gitconfig.local`, `~/.tmux-workspace.local`, or secrets.

## Layout

- `install.sh` — installer, profile selection, symlinks, and `merge_json`.
- `zsh/`, `tmux/`, `nvim/`, `ghostty/`, `git/`, `mise/`, `brew/` — managed
  configuration.
- `agents/` — global agent instructions and the project template.
- `bin/` and `tmux/scripts/` — POSIX `sh` helpers symlinked to
  `~/.local/bin`.
- `opencode/`, `codex/`, `claude/` — JSON baselines merged into live configs.

## Conventions

- Shell helpers are POSIX `sh` with `set -eu`. Run `shellcheck` on them.
- Neovim uses 0.12's native `vim.pack`; do not introduce a plugin manager.
  Lazy-load through `nvim/lua/lazyload.lua` and record revisions in
  `nvim/nvim-pack-lock.json`. Never edit the lockfile by hand.
- tmux configuration is a single `tmux/tmux.conf` plus `tmux/scripts/`.
- Agent configuration must use `$HOME`, never absolute home-directory paths.
- Use `dotlink` for static files and `merge_json` for files that an
  application rewrites atomically.
- Update the README when behavior, installation, or local overrides change.

## Adding a managed file

1. Move the configuration into this repository.
2. Add its destination directory and symlink to `install.sh`.
3. If the destination is a directory managed as a whole, add it to the
   installer's preflight check so an existing directory is never removed.
4. If the application rewrites its config atomically, store the baseline and
   add a `merge_json` call instead of a symlink.
5. Run the installer and verify the resulting link before committing.

## Commits

Use the style in `README.md`: imperative, sentence case, no Conventional
Commit prefix, 50-character subject (72 hard limit), body wrapped at 72 columns
with `- ` bullets. Run `./check.sh` first.
