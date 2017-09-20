# Dotfiles


Following https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/, this repo was created with (fish syntax)

```
git init --bare $HOME/dotfiles
alias config '/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
```

and can be deployed by 

```
echo "dotfiles" >> $HOME/.gitignore
git clone --bare https://github.com/nnmm/dotfiles.git $HOME/dotfiles
alias config '/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout
```

## Credits
Dircolors by [ivoarch](https://github.com/ivoarch/dircolors-zenburn).