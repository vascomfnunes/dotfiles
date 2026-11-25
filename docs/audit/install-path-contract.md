# install-path-contract

Method and cell grades: [index](index.md). Newest record first.

## Open suspicions

none

## 2026-11-25 @ 3d750ba

- **Paths examined** — Re-checked cross-area install/path contract across `install.sh`, `check.sh`, `zsh/{zshenv,zshrc}`, `git/gitconfig`, `ssh/config`, `gpg/gpg-agent.conf`, `agents/install-skills.sh`, `opencode/{cli.json,agents/*.md}`, and `bin/btop-themed` (unchanged since `0f7346c`).
- **Invariants checked** — All `dotlink` parent directories created before linking (`install.sh:114-124`), `ZDOTDIR`/`ZINIT_HOME` parity, SSH socket dir permissions (`700`), `pinentry-mac` link, `btop` theme/wrapper paths, OpenCode `AGENTS.md`/`agents/*.md`/`cli.json` paths, and `check.sh` privacy/link checks.
- **Risks investigated** — Applied: cross-area contracts, logic correctness, filesystem permissions, documented contracts vs behaviour. Not applicable: concurrency/races, async/cancellation, confinement/isolation, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling.
- **Defects** — none.
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — `none run` in this step (full `./check.sh` passed at `0f7346c` with no subsequent code changes).

## 2026-11-25 @ 0f7346c

- **Paths examined** — Cross-checked `install.sh`, `check.sh`, `zsh/zshenv`, `zsh/zshrc`, `git/gitconfig`, `ssh/config`, `gpg/gpg-agent.conf`, `agents/install-skills.sh`, `opencode/cli.json`, `opencode/agents/*.md`, `bin/btop-themed`. Traced contract points: `ZDOTDIR` and Zinit paths, `~/.zshrc.local`/`~/.gitconfig.local` stubs, `~/.ssh/sockets` permissions and `ControlPath`, `~/.local/bin/pinentry-mac` link and `gpg-agent.conf`, `btop` themes and wrapper, OpenCode `AGENTS.md`/`agents/*.md`/`cli.json` paths, `mise` config/lock paths, and whole-directory preflight for `nvim`/`yazi`.
- **Invariants checked** — Every `dotlink` parent directory in `install.sh` is created before linking (after `B-0001` fix `8fbd460`); `ZINIT_HOME` matches verbatim between `install.sh:259` and `zsh/zshrc:173`; `ZDOTDIR` and dual `.zshenv` links match `zsh/zshenv:3`; `ssh/config:30` matches `install.sh:122-123` (`chmod 700`); `gpg/gpg-agent.conf:2` matches `install.sh:245`; all 4 `bin/` helpers are linked in `install.sh:210-213` and linted in `check.sh:9,33`; all 3 `opencode/agents/*.md` are linked and checked by `check.sh:24-30`; privacy check covers both `agents` and `opencode` (after `B-0002` fix `f7173fd`).
- **Risks investigated** — Applied: cross-area contracts, logic correctness, filesystem permissions (`chmod 700` on `.gnupg`/`.ssh`/`.ssh/sockets`, `chmod 600` on merged `cli.json`), documented contracts vs behaviour (`README.md` and `AGENTS.md`). Not applicable: concurrency/races, async/cancellation, confinement/isolation, resource limits, serialization, extension lifecycle, user-intent/undo, performance/scaling.
- **Defects** — none.
- **Excluded** — none.
- **Uncertainty** — none.
- **Tests** — Ran `PATH="/opt/homebrew/bin:$PATH" GIT_CONFIG_GLOBAL=/dev/null ./check.sh` (all checks passed, including all 7 Neovim specs and `agents/test-install-skills.sh`).
