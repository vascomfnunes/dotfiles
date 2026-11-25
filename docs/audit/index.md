# Audit register

Which areas were read, how deeply, and what the next reading should settle.
Evidence lives in one file per area beside this index. Method: the `find-bugs`
skill.

## Reading a cell

| Cell | Meaning |
| --- | --- |
| `YYYY-MM-DD @ commit [audited]` | An evidence record supports it. |
| `YYYY-MM-DD @ commit [partial: <what>]` | Read, but the record leaves a gap. |
| `—` | Never audited. |

A date with no evidence record is partial, however recent.

One audit writes a repository at a time. Re-read the index before writing, change
only your own row, and leave the others as you found them.

In the tables, the cell is split as shown: `Last audit` holds
`YYYY-MM-DD @ commit` and `State` holds `[audited]`, `[partial: <what>]` or `—`.
A filled row reads `| install | install.sh | 2026-01-01 @ abc1234 | [audited] |`.

## Commands

- Focused test: `sh agents/test-install-skills.sh` (skills) or `nvim --headless -u NONE -l nvim/tests/<spec>_spec.lua "$PWD"` with isolated `XDG_{STATE,DATA,CACHE}_HOME` (Neovim)
- Lint: `shellcheck install.sh agents/*.sh bin/serve bin/git-commit-ai bin/nvim-edit bin/btop-themed` (plus `sh -n`, `zsh -n zsh/zshrc zsh/zshenv`, `jq empty opencode/cli.json`)
- Build: `none`
- Check: `./check.sh`
- Rules that restrict running them: Do not run `./install.sh` during audits (it mutates `$HOME`, installs packages, and writes macOS `defaults`).

## Areas

| Area | Owns | Last audit | State |
| --- | --- | --- | --- |
| install-and-checks | `install.sh`, `check.sh`, `brew/Brewfile`, `brew/Brewfile.*`, `mise/config.toml` | 2026-11-25 @ 3472aa2 | [audited] |
| shell-and-terminal | `zsh/zshenv`, `zsh/zshrc`, `starship.toml`, `ghostty/config`, `yazi/package.toml`, `yazi/theme.toml` | 2026-11-25 @ 18f0fab | [audited] |
| bin-helpers | `bin/btop-themed`, `bin/git-commit-ai`, `bin/nvim-edit`, `bin/serve` | 2026-11-25 @ 82e9c9e | [audited] |
| agents-and-opencode | `agents/install-skills.sh`, `agents/test-install-skills.sh`, `agents/AGENTS.md`, `agents/templates/AGENTS.md`, `opencode/cli.json`, `opencode/agents/*.md` | 2026-11-25 @ 8fef5c8 | [audited] |
| git-ssh-gpg | `git/gitconfig`, `git/gitignore`, `ssh/config`, `gpg/gpg-agent.conf` | 2026-11-25 @ abf3914 | [audited] |
| nvim-core | `nvim/init.lua`, `nvim/lua/options.lua`, `nvim/lua/keymaps.lua`, `nvim/lua/lazyload.lua`, `nvim/lua/packs.lua`, `nvim/lua/plugins.lua`, `nvim/lua/pins.lua`, `nvim/lua/statusline.lua`, `nvim/lua/sessions.lua`, `nvim/tests/keymaps_spec.lua`, `nvim/tests/statusline_spec.lua` | 2026-11-25 @ fa5bc4b | [audited] |
| nvim-lang-and-project | `nvim/lua/lsp.lua`, `nvim/lua/completion.lua`, `nvim/lua/css_classes.lua`, `nvim/lua/tags.lua`, `nvim/lua/project.lua`, `nvim/tests/css_classes_spec.lua`, `nvim/tests/lsp_spec.lua`, `nvim/tests/project_spec.lua`, `nvim/tests/tags_spec.lua` | 2026-11-25 @ ab80aa3 | [audited] |
| nvim-git | `nvim/lua/git.lua`, `nvim/lua/git/*.lua`, `nvim/tests/git_parsers_spec.lua` | 2026-11-25 @ c162be0 | [audited] |

## Boundaries

Areas two others depend on and neither owns; audited after both sides.

| Boundary | Joins | Last audit | State |
| --- | --- | --- | --- |
| nvim-server-contract | `shell-and-terminal`, `bin-helpers`, `nvim-core` | — | — |
| install-path-contract | `install-and-checks`, `agents-and-opencode`, `git-ssh-gpg`, `shell-and-terminal` | — | — |

## Exclusions

| Path | Reason |
| --- | --- |
| `nvim/nvim-pack-lock.json` | generated lockfile (managed by Neovim `vim.pack`) |
| `mise/mise.lock` | generated lockfile (managed by `mise`) |
| `btop/LICENSE`, `btop/themes/*.theme` | vendored Catppuccin theme files |
| `yazi/flavors/` | generated (gitignored, deployed by `ya pkg install`) |
| `.gitignore`, `AGENTS.md`, `CLAUDE.md`, `LICENSE`, `README.md` | repository metadata and documentation |

## Existing register

| Register | Path | Note |
| --- | --- | --- |
