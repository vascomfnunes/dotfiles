function tks --wraps='tmux kill-session -t' --description 'alias tks=tmux kill-session -t'
  tmux kill-session -t $argv; 
end
