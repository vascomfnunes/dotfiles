if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -g fish_greeting

# Vim mode
fish_vi_key_bindings

# Add homebrew to the path
set -U fish_user_paths /opt/homebrew/bin/ $fish_user_paths

# Exports
export EDITOR='nvim'
export VISUAL='nvim'
export PLAYER='mpv'
export BROWSER_CLI='w3m'
export PATH="/usr/local/sbin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/bin:$PATH"

set -x GPG_TTY (tty)

alias vi='nvim'
alias v='fd --type f --hidden --exclude .git --exclude .cache --exclude Library --exclude .local | fzf-tmux -p --reverse | xargs nvim'
# https://github.com/darkhz/invidtui/wiki/Command-Line-Options
# install: go install github.com/darkhz/invidtui@latest
alias youtube='~/go/bin/invidtui --close-instances'
#alias ls='eza --icons'
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

# Foreman
alias foreman='foreman start -f $HOME/Profile.dev'

# source environment variables that we do not want in source control
source ~/.env_variables

# Gruvbox material
set -l foreground d4be98
set -l selection 504945
set -l comment 5b534d
set -l red ea6962
# set -l orange fe8019
set -l yellow d8a657
set -l green a9b665
# set -l purple d3869b
set -l cyan 89b482
set -l blue 7daea3

# Syntax Highlighting Colors
set -g fish_color_normal $foreground
set -g fish_color_command $cyan
set -g fish_color_keyword $blue
set -g fish_color_quote $yellow
set -g fish_color_redirection $foreground
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_param $purple
set -g fish_color_comment $comment
set -g fish_color_selection --background=$selection
set -g fish_color_search_match --background=$selection
set -g fish_color_operator $green
set -g fish_color_escape $blue
set -g fish_color_autosuggestion $comment

# Completion Pager Colors
set -g fish_pager_color_progress $comment
set -g fish_pager_color_prefix $cyan
set -g fish_pager_color_completion $foreground
set -g fish_pager_color_description $comment
