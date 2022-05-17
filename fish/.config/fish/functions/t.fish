function t --wraps='tmux -u' --description 'alias t=tmux -u'
  tmux -u $argv; 
end
