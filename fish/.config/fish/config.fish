if status is-interactive
  set -gx PATH $PATH ~/homebrew/bin

  export GPG_TTY=$(tty)

  if test -z (pgrep ssh-agent | string collect)
    eval (ssh-agent -c)
    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
  end

  source ~/.env_variables_fish
end

