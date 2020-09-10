# Dotfiles


Following https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/, this repo was created with (fish syntax)

```
git init --bare $HOME/dotfiles
alias dotfiles '/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
```

and can be deployed by 

```
echo "dotfiles" >> $HOME/.gitignore
git clone --bare git@github.com:nnmm/dotfiles.git $HOME/dotfiles
alias dotfiles '/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```

## i3 deps
```
sudo chown root:root (which light)
sudo chmod 4711 (which light)
```


## Trying to remember how to compile mc?
```
sudo apt install autoconf automake autopoint libtool
sudo apt install libslang2-dev libglib2.0-dev libx11-dev libgpm-dev libext2fs-dev
./autogen.sh

```

## Credits
Dircolors by [ivoarch](https://github.com/ivoarch/dircolors-zenburn).
gdbinit by [cyrus-and](https://github.com/cyrus-and/gdb-dashboard).