# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Basic zsh settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Basic auto/tab completion
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Load zsh plugins (requires installing zplug first)
# Install zplug if you haven't:
# curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

source ~/.zplug/init.zsh

# Essential plugins
zplug "zsh-users/zsh-autosuggestions"        # Fish-like autosuggestions
zplug "zsh-users/zsh-syntax-highlighting"    # Fish-like syntax highlighting
zplug "zsh-users/zsh-history-substring-search"
zplug "agkozak/zsh-z"
zplug "romkatv/powerlevel10k", as:theme     # Amazing prompt

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load plugins
zplug load

# Useful aliases
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias v='fd --type f --hidden --exclude .git --exclude .cache --exclude Library --exclude .local | fzf-tmux -p --reverse | xargs nvim'
alias ls='eza --icons'
alias la='ls -la'
alias vi='nvim'
alias kill_rails='kill -9 $(lsof -t -i:3000)'
alias :q='exit'
alias :cat='bat'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias diff='diff --color=auto'
alias grep='grep --color=auto --exclude-dir={.git,artwork,node_modules,vendor}'
alias rspec='rspec -f d'
alias yarn_interactive_upgrade='yarn upgrade-interactive --latest'

# Git aliases
alias gP='git push'
alias gco='git checkout'
alias gc='git commit'
alias gf='git fetch'
alias gp='git pull'
alias gr='git restore'
alias gb='git branch'
alias gs='git status'
alias gl='git log'
alias ga='git add'
alias gd='git diff'
alias pr='git push origin $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")'
alias gclean='git clean -f -d'

# ctags alias
alias ctags='ctags --tag-relative -R --sort=yes --languages=ruby,scss,javascript --exclude=.git --exclude=doc --exclude=coverage --exclude=log --exclude=public --exclude=tmp --exclude=node_modules . $(bundle list --paths)'

# Functions

function e() {
    open -na "RubyMine.app" --args "$@"
}
compdef _files e

# Better directory navigation
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Initialize powerlevel10k prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Environment variables
export EDITOR='nvim'
export PATH="$HOME/.local/bin:$PATH"

# rbenv initialization
eval "$(rbenv init - zsh)"

# GPG TTY
export GPG_TTY=$(tty)