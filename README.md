# Dotfiles

A symlink-based macOS configuration for Zsh, Neovim, tmux, Ghostty, Git,
Homebrew, and related command-line tools.

## Overview

`install.sh` installs software, links the managed configuration into the home
directory, and applies the macOS preferences used by this setup. Because the
links point back to this repository, edits made through the installed paths are
kept under version control here.

## Requirements

- macOS
- Git and an internet connection
- Permission to install Homebrew packages and applications

Homebrew is installed automatically when it is not already available. The
Neovim configuration targets Neovim 0.12 or newer, which provides the built-in
[`vim.pack`](https://neovim.io/doc/user/pack/) plugin manager; the Brewfile
installs a suitable version.

## What the Installer Changes

Before running the installer, be aware that it:

- Installs the base Homebrew bundle and either the `personal` or `work` bundle.
- For the `personal` profile, taps and trusts the third-party
  `vascomfnunes/audio` Homebrew tap.
- Downloads and installs PyRadio and Zinit when they are missing.
- Installs the Mise-managed runtimes (Ruby, Node.js, and Python) via
  `mise install`.
- Replaces managed configuration files with symlinks into this repository.
- Creates empty local stub files (`~/.zshrc.local`, `~/.gitconfig.local`,
  `~/.tmux-workspace.local`, and `~/.hushlogin`) when they are missing.
- Creates a launchd agent that reloads the tmux theme when macOS appearance
  changes.
- Runs `brew autoremove` and `brew cleanup`.
- Applies the macOS preferences defined at the end of `install.sh` and restarts
  Dock, Finder, and Control Center.

Existing regular files at managed file paths, such as `~/.zshenv`, are replaced
by symlinks. Existing non-symlink directories managed as a whole, such as the
Neovim and PyRadio configuration directories, cause the installer to stop so
that their contents are not overwritten. Back up local configuration before
the first run.

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/vascomfnunes/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the installer

```bash
# Personal profile (the default)
./install.sh
./install.sh personal

# Work profile
./install.sh work

# Also upgrade installed Homebrew packages and applications
./install.sh personal --upgrade-brew
./install.sh work --upgrade-brew

# Show usage
./install.sh --help
```

Some macOS preference changes require a logout or restart to take effect.

## Profiles

The installer accepts the `personal` and `work` profiles:

- `brew/Brewfile`: Base packages installed on every machine.
- `brew/Brewfile.personal`: Packages installed by the personal profile.
- `brew/Brewfile.work`: Packages installed by the work profile.

Running the installer without a profile selects `personal`.

## Local Configuration

Use these untracked files in the home directory for machine-specific settings,
secrets, or work configuration:

- `~/.zshrc.local`: Sourced at the end of `.zshrc`.
- `~/.gitconfig.local`: Included by the main Git configuration.
- `~/repos/.gitconfig`: Included for repositories below `~/repos`; useful for
  context-specific Git identity or signing settings.
- `~/.tmux-workspace.local`: Optional settings for the workspace created by a
  bare `tmux` command.

For example:

```sh
TMUX_WORKSPACE_SESSION="Session Name"
TMUX_WORKSPACE_PROJECT="$HOME/repos/project"
TMUX_WORKSPACE_RADIO_WIDTH="15%"
```

Without those tmux settings, the workspace uses the current user name for its
session, the home directory for its Neovim window, and 15% of the window for the
radio column. If the configured project directory does not exist, it falls back
to the home directory.

## Maintenance

### Commit Style

This project uses plain imperative commit titles rather than Conventional
Commit prefixes.

- Start with an imperative verb: `Add`, `Fix`, `Improve`, `Remove`, or similar.
- Use sentence case with no trailing period.
- Keep the title at 50 characters when practical, with 72 as the hard limit.
- Keep each commit focused on one coherent change.
- Add a body only when the motivation, trade-offs, or important implementation
  details are not clear from the title and diff. Wrap body text at 72 characters.

### Updating Configurations

Edit a managed path directly, such as `nvim ~/.config/zsh/.zshrc`, then review
and commit the corresponding repository change:

```bash
cd ~/dotfiles
git status
git add zsh/zshrc
git commit -m "Update Zsh configuration"
git push
```

### Updating the System

The `dotupdate` shell function pulls the latest repository changes and runs the
installer again. Pass the machine's profile explicitly on work machines:

```bash
dotupdate                 # personal profile
dotupdate personal
dotupdate work
dotupdate work --upgrade-brew
```

### Updating Neovim Plugins

Neovim installs plugins through its built-in `vim.pack` support and records
their revisions in `nvim/nvim-pack-lock.json`.

- `:PackUpdate` updates configured plugins.
- `:PackRestore` restores plugin revisions from the committed lockfile.

Review and commit lockfile changes after intentionally updating plugins.

### Adding New Packages

1. Add the package to `brew/Brewfile`, `brew/Brewfile.personal`, or
   `brew/Brewfile.work`.
2. Run `./install.sh personal` or `./install.sh work` as appropriate.

### Adding New Dotfiles

1. Move the configuration into this repository.
2. Add its destination directory and symlink to `install.sh`.
3. If the destination is a directory managed as a whole, add it to the
   installer's preflight check so an existing directory is never removed.
4. Run the installer and verify the resulting link before committing.

## Components

- **Shell:** Zsh with Zinit, Starship, Atuin, direnv, fzf, and zoxide.
- **Terminal:** Ghostty with automatic Catppuccin light and dark themes.
- **Editor:** Neovim 0.12+ with native `vim.pack` package management and a
  committed plugin lockfile.
- **Multiplexer:** tmux with seamless Neovim navigation, a restorable workspace,
  PyRadio, weather and battery status, and automatic light/dark themes.
- **Runtime management:** Mise with pinned Ruby, Node.js, and Python versions.
- **Security:** GPG agent and SSH configuration, including SSH connection
  multiplexing.
- **Utilities:** Highlights include bat, eza, fd, fzf, ripgrep, pipx, uv, wget,
  and yarn. The Brewfiles are the source of truth for the complete package list.
- **Scripts:** Utilities installed into `~/.local/bin`, including `serve` and
  the tmux status/workspace helpers.
