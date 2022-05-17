function tls --wraps='tmux ls' --description 'alias tls=tmux ls'
  tmux ls $argv; 
end
