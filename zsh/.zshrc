# Clone zcomet if necessary
if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi

source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

# Use 'zcomet_self-update' to update zcomet itself
# Use 'zcomet_update' to update all plugins

zcomet load sindresorhus/pure
zcomet load zap-zsh/supercharge
zcomet load zap-zsh/vim
zcomet load agkozak/zsh-z
zcomet load zsh-users/zsh-completions
zcomet load hlissner/zsh-autopair
zcomet trigger yarn buonomo/yarn-extra-completion

# This ones last, and in this order
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

# Run compinit and compile its cache
zcomet compinit

export EDITOR='nvim'
export VISUAL='nvim'
export PLAYER='mpv'
export BROWSER_CLI='w3m'

export PATH="/usr/local/sbin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/bin:$PATH"

# | NAVIGATION |
setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.

# | HISTORY |
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.

# Autosuggestions colours
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5b534d'

# fzf
# After installing fzf with Homebrew, run '/opt/homebrew/opt/fzf/install'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

local color00='#282828'
local color01='#3c3836'
local color02='#5b534d'
local color03='#665c54'
local color04='#bdae93'
local color05='#d5c4a1'
local color06='#ebdbb2'
local color07='#fbf1c7'
local color08='#ea6962'
local color09='#fe8019'
local color0A='#d8a657'
local color0B='#a9b665'
local color0C='#8ec07c'
local color0D='#83a598'
local color0E='#d3869b'
local color0F='#d8a657'

export FZF_DEFAULT_OPTS="--height 60% \
--border sharp \
--prompt '∷ ' \
--pointer ▶ \
--marker ⇒"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS"\
" --color=bg+:$color00,bg:$color00,spinner:$color0C,hl:$color0D"\
" --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C"\
" --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D"

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -n 10'"

# aliases
alias vi='nvim'
alias v='fd --type f --hidden --exclude .git --exclude .cache --exclude Library --exclude .local | fzf-tmux -p --reverse | xargs nvim'
alias ls='exa --icons'
alias kill_rails='kill -9 $(lsof -t -i:3000)'
alias la='ls -la'
alias c='clear'
alias :q='exit'
alias df='df -h'
alias cat='bat'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias diff='diff --color=auto'
alias grep="grep --color=auto --exclude-dir={.git,artwork,node_modules,vendor}"
alias rspec='rspec -f d'
alias music='ncmpcpp'
alias yarn_interactive_upgrade='yarn upgrade-interactive --latest'

# Git
alias gP="git push"
alias gc="git commit"
alias gf="git fetch"
alias gp="git pull"
alias gr="git restore"
alias gco="git checkout"
alias gb="git branch"
alias gs="git status"
alias gl='git log'
alias ga="git add"
alias gd="git diff"
alias lg="lazygit"
alias gclean="git clean -f -d"

# Tmux
alias t="tmux -u"
alias ta="tmux -u a"
alias tls="tmux ls"
alias tks="tmux kill-session -t"

# Weechat (workaround for downloading script list under macOS)
alias weechat="OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES weechat"

# ctags
# For now, I just care about Rails projects
# where LSP is not so great for Gems&Co and tags deliver a much better job...
alias ctags='ctags --tag-relative -R --sort=yes --languages=ruby,scss,javascript --exclude=.git --exclude=doc --exclude=coverage --exclude=log --exclude=public --exclude=tmp --exclude=node_modules . $(bundle list --paths)'

# source environment variables that we do not want in source control
source ~/.env_variables

# GPG
export GPG_TTY=$(tty)

# rbenv for Ruby
eval "$(rbenv init -)"
