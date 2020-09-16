# Defined in - @ line 1
function gp --wraps='git push --set-upstream dev (git symbolic-ref --short HEAD)' --description 'alias gp git push --set-upstream dev (git symbolic-ref --short HEAD)'
  git push --set-upstream dev (git symbolic-ref --short HEAD) $argv;
end
