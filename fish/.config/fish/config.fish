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

# Aliases
alias v='fd --type f --hidden --exclude .git --exclude .cache --exclude Library --exclude .local | fzf-tmux -p --reverse | xargs nvim'

# Abbreviations
abbr -a -- vi 'nvim'
abbr -a -- kill_rails 'kill -9 $(lsof -t -i:3000)'
abbr -a -- la 'ls -la'
abbr -a -- :q 'exit'
abbr -a -- :cat 'bat'
abbr -a -- cp 'cp -i'
abbr -a -- mv 'mv -i'
abbr -a -- rm 'rm -i'
abbr -a -- diff 'diff --color=auto'
abbr -a -- grep 'grep --color=auto --exclude-dir={.git,artwork,node_modules,vendor}'
abbr -a -- rspec 'rspec -f d'
abbr -a -- music 'ncmpcpp'
abbr -a -- yarn_interactive_upgrade 'yarn upgrade-interactive --latest'

# Git
abbr -a -- gP 'git push'
abbr -a -- gc 'git commit'
abbr -a -- gf 'git fetch'
abbr -a -- gp 'git pull'
abbr -a -- gr 'git restore'
abbr -a -- gc 'git checkout'
abbr -a -- gb 'git branch'
abbr -a -- gs 'git status'
abbr -a -- gl 'git log'
abbr -a -- ga 'git add'
abbr -a -- gd 'git diff'
abbr -a -- lg 'lazygit'
abbr -a -- gclean 'git clean -f -d'

# Tmux
abbr -a -- t 'tmux -u'
abbr -a -- ta 'tmux -u a'
abbr -a -- tls 'tmux ls'
abbr -a -- tks 'tmux kill-session -t'

# Weechat (workaround for downloading script list under macOS)
abbr -a -- weechat 'OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES weechat'

# ctags
# For now, I just care about Rails projects
# where LSP is not so great for Gems&Co and tags deliver a much better job...
abbr -a -- ctags 'ctags --tag-relative -R --sort=yes --languages=ruby,scss,javascript --exclude=.git --exclude=doc --exclude=coverage --exclude=log --exclude=public --exclude=tmp --exclude=node_modules . $(bundle list --paths)'

# Yazi
abbr -a -- y 'yazi'

# Lazygit
abbr -a -- l 'lazygit'

# source environment variables that we do not want in source control
source ~/.env_variables
source ~/.config/fish/themes/kanagawa.theme
