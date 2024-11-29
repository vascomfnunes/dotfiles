source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

	autoload -Uz compinit
	compinit
fi

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh

autoload -U promptinit; promptinit
prompt pure

GPG_TTY=$(tty)
export GPG_TTY

eval "$(rbenv init - zsh)"
