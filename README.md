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
- Taps `halpworld/tap` and trusts its `halpradio` formula for both profiles.
- For the `personal` profile, taps and trusts the third-party
  `vascomfnunes/audio` Homebrew tap.
- Installs halpradio through Homebrew and downloads Zinit when it is missing.
- Installs the Mise-managed runtimes (Ruby, Node.js, and Python) via
  `mise install`.
- Replaces managed configuration files with symlinks into this repository.
- Merges tracked OpenCode, Codex, and Claude Code configuration into their live
  JSON files (those applications rewrite their own configs).
- Creates empty local stub files (`~/.zshrc.local`, `~/.gitconfig.local`,
  `~/.tmux-workspace.local`, and `~/.hushlogin`) when they are missing.
- Creates a launchd agent that reloads the tmux theme when macOS appearance
  changes.
- Runs `brew autoremove` and `brew cleanup`.
- Applies the macOS preferences defined at the end of `install.sh` and restarts
  Dock, Finder, and Control Center.

Existing regular files at managed file paths, such as `~/.zshenv`, are replaced
by symlinks. Existing non-symlink directories managed as a whole, such as the
Neovim and Yazi configuration directories, cause the installer to stop so
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
TMUX_WORKSPACE_RADIO_WIDTH="20%"
```

Without those tmux settings, the workspace uses the current user name for its
session, the home directory for all windows, and 20% of the window for the
cover-art pane. If the configured project directory does not exist, it falls
back to the home directory.

The standard workspace also provides tool popups in the active pane's
working directory:

- `prefix + y`: Yazi file manager, including Ghostty image previews through
  tmux and automatically using Catppuccin Latte or Mocha.
- `prefix + b`: btop process and resource monitor, automatically using
  Catppuccin Latte or Mocha to match the current macOS appearance.
- `prefix + S`: searchable command and programming cheatsheets from cht.sh,
  with topic previews and an optional query prompt.
- `prefix + A`: dashboard of panes running OpenCode, Codex, or Claude Code,
  with a live preview of the selected pane; Enter jumps to it.

Agent panes show a marker in the tmux window name: `●` while a session is
working and `✓` when it finishes. OpenCode reports its own activity through a
plugin, and Codex and Claude Code use their native `UserPromptSubmit`, `Stop`,
and `SessionEnd` hooks. Launch them directly:

```sh
opencode
codex
claude
```

The agent helpers only update tmux window markers; they do not send macOS
notifications. OpenCode's own attention notifications are configured separately
in `cli.json`.

The installer merges the tracked `opencode/cli.json`, `codex/hooks.json`, and
`claude/settings.json` baselines into their live files instead of symlinking
them. Those applications replace their configuration atomically, which would
break a symlink; merging also removes stale hook entries and preserves keys
that only exist in the live file. Claude's machine-specific `autoMode` context
and `settings.local.json` stay local and are intentionally not tracked.
OpenCode plugins are installed through a generated shim because OpenCode does
not load a symlinked plugin file as a plugin.

The first workspace window has halpradio and cover art side by side above a
shell, occupying about 38% of the window height. The second and third windows are
plain Zsh shells in the configured project directory.
The radio pane runs halpradio with the Catppuccin theme and opens its Catalog
station list. The initial list is tracked in `halpradio/stations.yaml`, linked
to `~/Library/Application Support/halpradio/stations.yaml`; edits made through
halpradio update that file. An existing independent halpradio station list is
left untouched by the installer. The upper pane looks up artwork for the current
track, and the tmux status bar displays the title. Press `7` to return to Custom
stations, and use `prefix + m` for the artwork popup.

Run `y` directly from Zsh when you want the shell to follow Yazi's final
directory after it exits.

## Agent Instructions

Agent instructions live in three layers:

- `agents/AGENTS.md` is the global baseline. The installer links it to
  `~/.config/opencode/AGENTS.md` and `~/.codex/AGENTS.md`; Claude Code reads it
  through the `@` import in `~/.claude/CLAUDE.md`.
- `AGENTS.md` in this repository describes the dotfiles architecture and
  conventions. `CLAUDE.md` imports it for Claude Code.
- `agents/templates/AGENTS.md` is a starting point for new projects:

  ```sh
  cp ~/dotfiles/agents/templates/AGENTS.md ./AGENTS.md
  printf '@AGENTS.md\n' > ./CLAUDE.md   # Claude Code
  ```

Keep project-specific commands (install, test, lint, build) in the project
file, not in the global baseline.

## Shared Neovim Server

`nvim-edit` opens files in a running Neovim server when one exists and falls
back to a normal editor otherwise. The tmux workspace no longer starts a Neovim
server; launch one yourself with `nvim --listen "$NVIM_SERVER"` when you want
the handoff. `NVIM_SERVER` is exported from `~/.zshenv`.

- `v <file>` hands the file to the running Neovim and returns immediately.
- `$EDITOR`, `$VISUAL`, and Git's `core.editor` use `nvim-edit`, which blocks
  until the editor exits, as Git and other `$EDITOR` callers require.

Neovim 0.12 does not implement `--remote-wait`, so `nvim-edit` uses a blocking
local editor for `$EDITOR` calls and `--remote` only for explicit handoff.
Agents that invoke an interactive editor are refused instead of hanging; see
`agents/AGENTS.md`.

## Maintenance

### Checking Configuration

Run the repository checks before committing configuration changes:

```bash
./check.sh
```

This validates POSIX shell, Zsh, JavaScript, and JSON syntax, runs ShellCheck
and the Neovim test suite, rejects private home paths in tracked agent configs,
and checks staged and unstaged changes for whitespace errors.

### Commit Style

This project uses plain imperative commit titles rather than Conventional
Commit prefixes.

- Start with an imperative verb: `Add`, `Fix`, `Improve`, `Remove`, or similar.
- Use sentence case with no trailing period.
- Keep the title at 50 characters when practical, with 72 as the hard limit.
- Keep each commit focused on one coherent change.
- Add a body: open with a short paragraph on the problem and approach, then
  list the notable changes as `- ` bullets. Wrap body text at 72 characters.
- Markdown is allowed in the body (headings, nested lists, fenced code blocks)
  when it improves clarity.
- Use professional, direct language. Write the body like a concise pull request
  description, including trade-offs or follow-up work when relevant.

### Drafting Commit Messages

`git commit-ai` drafts a message from the staged diff using the first installed
engine among `opencode`, `codex`, and `claude`, then shows it before anything is
committed. The `opencode` engine uses `opencode-go/deepseek-v4.1-flash` by
default; set `GIT_AI_MODEL` to choose another model. Review, edit, regenerate,
or discard the draft:

```bash
git add -p
git commit-ai            # review, edit, or commit the draft
git commit-ai --print    # print the draft and exit
git commit-ai --all      # stage tracked changes first
```

In Neovim, `:GitCommitAI` or `<leader>gG` opens the generated draft in a split
so the full body can be edited in place. Press `:w` (or `:wq`) to commit and
`q` to cancel. `<leader>gc` (`:GitCommit`) remains the manual path. Set
`GIT_AI_ENGINE` to force an engine, `GIT_AI_MODEL` to choose a different
opencode model, and `GIT_AI_EDITOR` to choose the editor used by the shell
command's edit option.

The helper never pushes and never bypasses Git hooks.

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
4. If the application rewrites its config atomically, store the baseline and
   add a `merge_json` call instead of a symlink.
5. Run the installer and verify the resulting link before committing.

## Components

- **Shell:** Zsh with Zinit, Starship, Atuin, fzf, and zoxide.
- **Terminal:** Ghostty with automatic Catppuccin light and dark themes.
- **Editor:** Neovim 0.12+ with native `vim.pack` package management, a
  committed plugin lockfile, and a shared `--listen` server for editor handoff.
- **Multiplexer:** tmux with seamless Neovim navigation, a restorable workspace,
  Yazi and btop popups, halpradio, weather and battery status, and automatic
  light/dark themes.
- **Agents:** OpenCode, Codex, and Claude Code with shared `AGENTS.md`
  instructions, tmux window markers, and an fzf pane dashboard.
- **Runtime management:** Mise with pinned Ruby, Node.js, and Python versions.
- **Security:** GPG agent and SSH configuration. Multiplexing is used for
  general hosts, while GitHub and Bitbucket connections are direct to avoid
  session limits on multiplexed connections.
- **Utilities:** Highlights include bat, btop, eza, fd, fzf, ripgrep, Yazi,
  uv, wget, and yarn. uv can manage user-level Python CLIs such as aider. The Brewfiles are the source of truth
  for the complete package list.
- **Scripts:** Utilities installed into `~/.local/bin`, including `serve`,
  `git-commit-ai`, `nvim-edit`, `agent-hook`, and the tmux status/workspace
  helpers.
