# Defined in - @ line 1
function dotfiles --wraps='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME/ade-home' --description 'alias dotfiles /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME/ade-home'
  /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME/ade-home $argv;
end
