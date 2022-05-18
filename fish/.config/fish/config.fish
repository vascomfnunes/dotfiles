if status is-interactive
  set -gx PATH $PATH ~/homebrew/bin
  export GPG_TTY=$(tty)
  source ~/.env_variables_fish
end

