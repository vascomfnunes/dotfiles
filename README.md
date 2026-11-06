# Dotfiles

macOS configuration for Zsh, Neovim, Ghostty, Git, Homebrew, and agent
tooling. `install.sh` symlinks the managed files into `$HOME`, so edits made
through the installed paths land in this repository.

## Requirements

- macOS with Git and an internet connection.
- Permission to install Homebrew packages and casks.

Homebrew is installed automatically when missing. The Brewfiles install
Neovim 0.12 or newer, which provides the `vim.pack` plugin manager.

## Install

```bash
git clone https://github.com/vascomfnunes/dotfiles.git ~/dotfiles
cd ~/dotfiles

./install.sh                       # personal profile (default)
./install.sh work                  # work profile
./install.sh personal --upgrade-brew
```

Run `./install.sh --help` for usage.

The installer installs packages, links managed configuration, merges the
OpenCode config, installs Mise runtimes and pinned agent skills, and applies
macOS defaults. Existing files at managed paths are replaced by symlinks; an
existing non-symlink `~/.config/nvim` or `~/.config/yazi` stops the installer,
so back those up first. Some macOS changes need a logout or restart.

## Profiles

- `brew/Brewfile`: packages installed on every machine.
- `brew/Brewfile.personal`: personal profile.
- `brew/Brewfile.work`: work profile.

## Local Configuration

Keep machine-specific settings in these untracked files:

- `~/.zshrc.local`: sourced at the end of Zsh startup.
- `~/.gitconfig.local`: included by the main Git config.
- `~/repos/.gitconfig`: included for repositories below `~/repos`.

OpenCode rewrites its config atomically, so `install.sh` merges
`opencode/cli.json` into `~/.config/opencode/cli.json` instead of linking it.

## Updating

`dotupdate` pulls the latest changes and reruns the installer:

```bash
dotupdate                  # personal profile
dotupdate work
dotupdate work --upgrade-brew
```

Neovim plugins use the committed `nvim/nvim-pack-lock.json`. Run `:PackUpdate`
to update and `:PackRestore` to restore the lockfile revisions; commit lockfile
changes after updating. Add new packages to the relevant Brewfile and rerun the
installer.

## Checks

```bash
./check.sh
```

This validates shell, Zsh, and JSON syntax, runs ShellCheck and the Neovim
tests, checks agent skill installation and config privacy, and rejects
whitespace errors. Commit style and repository conventions are in `AGENTS.md`.

## Components

- **Shell:** Zsh with Zinit, Starship, Atuin, fzf, and zoxide.
- **Terminal:** Ghostty with Catppuccin themes and a `Ctrl+A` leader.
- **Editor:** Neovim 0.12+ with `vim.pack`, a plugin lockfile, and a shared
  server. `v` hands files to it; `nvim-edit` blocks for `$EDITOR` callers.
- **Agents:** OpenCode configuration, shared `AGENTS.md`, and pinned skills.
- **Runtimes:** Mise with pinned Ruby, Node.js, and Python versions.
- **Security:** GPG agent and SSH config with keychain integration.
- **Utilities:** The Brewfiles are the package source of truth. Shell helpers
  in `bin/` are linked into `~/.local/bin`.
