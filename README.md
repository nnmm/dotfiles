# Dotfiles


This was created following https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/ and can be deployed by these commands in bash:

```
echo "dotfiles" >> $HOME/.gitignore
git clone --bare git@github.com:nnmm/dotfiles.git $HOME/dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout
```


## Checklist for a new machine

### Installing software

* `sudo apt update && sudo apt install -y tmux xsel htop vlc tree git redshift-gtk`
* `sudo apt update && sudo apt install -y i3 i3status i3lock feh`
* Sublime Text from the website
* `rg`, `fd`, `bat`, `delta`, `fzf`, `fpp` from GitHub.

Put any bash completion scripts inside `~/.bash_completions.d`.

### i3 deps
```
sudo chown root:root (which light)
sudo chmod 4711 (which light)
```

### Trying to remember how to compile mc?
```
sudo apt install autoconf automake autopoint libtool
sudo apt install libslang2-dev libglib2.0-dev libx11-dev libgpm-dev libext2fs-dev
./autogen.sh

```

### Configuring stuff
* Enable tab cycling in Firefox
* Create ssh key with `ssh-keygen -t ed25519`


## TODO
* Find a setup that allows copy-pasting the same way inside and outside tmux
* Automatic screen locking


## Credits
Dircolors by [ivoarch](https://github.com/ivoarch/dircolors-zenburn).
gdbinit by [cyrus-and](https://github.com/cyrus-and/gdb-dashboard).
