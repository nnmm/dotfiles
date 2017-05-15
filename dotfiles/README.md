# Dotfiles

Following https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/, this repo was created with (fish syntax)

```
git init --bare $HOME/dotfiles
alias config '/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
```

and can be deployed by 

```
echo "dotfiles" >> $HOME/.gitignore
git clone --bare https://github.com/nnmm/dotfiles.git $HOME/dotfiles
alias config '/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
config checkout
```