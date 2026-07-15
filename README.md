# Dotfiles

A symlink-based dotfiles management system for macOS, featuring Zsh, Neovim, Tmux, and Homebrew.

## Overview

This repository uses a simple symlinking strategy managed by a shell script. Running the installer creates symbolic links in your home directory that point back to this repository, ensuring your configuration stays version-controlled.

## Installation

### 1. Clone the repository
```bash
git clone https://github.com/vascomfnunes/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run the installer
The installer will set up Homebrew, install dependencies, and create the necessary symlinks.

**⚠️ Warning:** Existing configuration files (like `~/.zshenv`) will be overwritten by symlinks to the versions in this repo. Back up any local changes first.

```bash
# Default installation (uses 'personal' profile)
./install.sh

# Work installation
./install.sh work
```

## Profiles

Homebrew dependencies are split into profiles to keep environments separate:

- `brew/Brewfile`: Base packages installed on every machine.
- `brew/Brewfile.personal`: Packages specific to personal use.
- `brew/Brewfile.work`: Packages specific to work use.

To use a specific profile, pass its suffix to the install script: `./install.sh <profile_name>`.

## Local Configuration

For machine-specific settings or sensitive data (API keys, work emails) that should not be committed to the repository, use the following files in your home directory:

- `~/.zshrc.local`: Sourced at the end of `.zshrc`.
- `~/.gitconfig.local`: Sourced by the main `.gitconfig`.

## Maintenance

### Updating Configurations
Since your configuration files are symlinked, you can edit them directly (e.g., `nvim ~/.config/zsh/.zshrc`) and the changes will be reflected in this repo. Simply commit and push the changes:

```bash
cd ~/dotfiles
git add .
git commit -m "Update aliases"
git push
```

### Updating the System
A convenience alias `dotupdate` is provided to pull latest changes and re-run the installer:
```bash
dotupdate
```

### Adding New Packages
1. Add the package to the appropriate `Brewfile` in the `brew/` directory.
2. Run `./install.sh` to ensure everything is synced.

### Adding New Dotfiles
1. Move your config file into this repository.
2. Add a new `ln -sf` command to `install.sh`.
3. Re-run `./install.sh`.

## Components
- **Zsh**: Managed with `zinit` for plugins, `starship` for prompt. Config located in `~/.config/zsh`.
- **Terminal**: `ghostty` configuration.
- **Editor**: `nvim` (Neovim) with a custom minimal `init.lua` (no plugin manager required).
- **Multiplexer**: `tmux` with automatic light/dark mode detection.
- **Security**: `GPG` (gnupg) and `SSH` configuration.
- **Runtime**: `mise` (runtime manager) for managing programming languages and tools.
- **Tools**:
  - `zoxide`: A smarter `cd` command.
  - `atuin`: SQLite-powered shell history.
  - `eza`: A modern replacement for `ls`.
  - `bat`: A `cat` clone with syntax highlighting.
  - `fd`: A simple, fast and user-friendly alternative to `find`.
  - `ripgrep` (rg): A line-oriented search tool.
  - `fzf`: A command-line fuzzy finder.
  - `direnv`: Directory-specific environment variables.
- **Scripts**: Custom utilities in `~/.local/bin` (e.g., `serve` for quick HTTP serving).
