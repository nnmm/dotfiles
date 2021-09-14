alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gs='git status'
alias gp='git push --set-upstream dev $(git symbolic-ref --short HEAD)'

alias ll='ls -lh'
alias la='ls -A'

alias nano='micro'

# And it would be nice to have completions
# https://brbsix.github.io/2015/11/23/perform-tab-completion-for-aliases-in-bash/
_completion_loader git
__git_complete gco _git_checkout
__git_complete gb _git_branch
__git_complete gd _git_diff
__git_complete gs _git_status
