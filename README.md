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
- Downloads Zinit when it is missing.
- Installs the Mise-managed runtimes (Ruby, Node.js, and Python) via
  `mise install`.
- Installs the OpenCode Quota and Context7 plugins globally using
  `opencode plugin add`. Context7 documentation queries use a hosted service.
- Installs pinned global agent skills into
  `~/.agents/skills`, preserving existing skills with the same names.
- Replaces managed configuration files with symlinks into this repository.
- Merges tracked OpenCode configuration into its live JSON file (OpenCode
  rewrites its own config).
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
```

Without those tmux settings, the workspace uses the current user name for its
session and the home directory for all windows. If the configured project directory
does not exist, it falls back to the home directory.

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

OpenCode panes show a marker in the tmux window name: `●` while a session is
working and `✓` when it finishes. OpenCode reports its activity through a
plugin. Launch it directly:

```sh
opencode
```

The agent helpers only update tmux window markers; they do not send macOS
notifications. OpenCode's own attention notifications are configured separately
in `cli.json`.

The installer merges the tracked `opencode/cli.json` baseline into its live
file instead of symlinking it. OpenCode replaces its configuration atomically,
which would break a symlink; merging preserves keys that only exist in the
live file. Existing standalone Codex and Claude Code configuration is left
untouched. The dashboard and commit helper retain compatibility with those
tools if installed separately.
OpenCode plugins are installed through a generated shim because OpenCode does
not load a symlinked plugin file as a plugin.

The first workspace window is a Zsh shell in the home directory. The second
starts Neovim and the third starts OpenCode in the configured project directory.
Existing sessions are reattached without changing their windows.
On macOS, when Ghostty starts a new workspace and no tmux server is running,
the workspace starts through launchd so quitting Ghostty does not terminate
the server. Existing servers are not restarted or moved.
Use `prefix + p` to open or hide the radio and cover art popup. Playback
continues while it is hidden; open it again to return to the same session.
The radio pane uses fzf to search the stations in `radio/stations.tsv` and mpv
to play them. Edit that file to add stations, one name and URL per line,
separated by a tab. Use the arrow keys or Ctrl-N/P to navigate, Enter to play a
station, Ctrl-S to stop playback, and Ctrl-X to close the selector and stop
playback and end the radio session. Use `prefix + p` to start it again.
The artwork pane looks up the current track, and the tmux status bar displays
the title when the stream provides it. Use `prefix + m` for the artwork popup.

Run `y` directly from Zsh when you want the shell to follow Yazi's final
directory after it exits.

## Agent Instructions

Agent instructions live in three layers:

- `agents/AGENTS.md` is the global baseline. The installer links it to
  `~/.config/opencode/AGENTS.md`.
- `AGENTS.md` in this repository describes the dotfiles architecture and
  conventions. `CLAUDE.md` imports it for Claude Code.
- `agents/templates/AGENTS.md` is a starting point for new projects:

  ```sh
  cp ~/dotfiles/agents/templates/AGENTS.md ./AGENTS.md
  printf '@AGENTS.md\n' > ./CLAUDE.md   # Claude Code
  ```

Keep project-specific commands (install, test, lint, build) in the project
file, not in the global baseline.

The installer adds debugging, planning, code-review, issue creation, skill
discovery, reverse engineering, project structure, and Swift development skills
alongside Caveman and Vercel Web Design Guidelines. The reverse-engineering
skill provides instructions only; its REA MCP server and analysis tools require
separate setup. Existing skills are preserved rather than updated.

The installer adds the Caveman skills without installing Caveman's proxy and
adds Web Design Guidelines for UI reviews. The latter fetches the latest
guidelines when used. Existing skills are not updated or overwritten; update
the pinned revisions in `agents/install-skills.sh` for new installations.

## Shared Neovim Server

In Neovim, `<leader>e` opens the mini.files explorer. Navigate with `h` and
`l`, then press `gp` on a directory to select it as the project.
The selected directory stays active when switching file buffers and becomes the
global directory used for sessions and pins. The selection lasts until you
choose another project or restart Neovim.
Existing buffers and LSP clients are not closed or restarted.

`nvim-edit` opens files in a running Neovim server when one exists and falls
back to a normal editor otherwise. The tmux workspace starts a shared Neovim
server if one is not already running; otherwise it starts a normal editor.
`NVIM_SERVER` is exported from `~/.zshenv`.

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
  Yazi and btop popups, an fzf/mpv radio, weather and battery status, and automatic
  light/dark themes.
- **Agents:** OpenCode with shared `AGENTS.md` instructions, tmux window
  markers, and an fzf pane dashboard.
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
