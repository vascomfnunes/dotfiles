if status is-interactive
  bass export GPG_TTY=$(tty)
  bass source ~/.env_variables
end

