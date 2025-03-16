# Workflow to add new folder/file

For some reason, `stow` isn't working with me.... So, do the following:

```
# Break the symlinks
cd ~; rm -rf dotfiles; DIR="."

# Clean up all the broken symlinks
for f in `find -L $DIR -maxdepth 1 -type l`; do unlink $f; done

# Clone this repo again
git clone git@github.com:IanQS/dotfiles.git

# go into the repo
cd dotfiles

# run stow
stow .

```

TADAAAAAAAAA it's done. Someday I'll learn how `stow` actually works, but I couldn't care less now

# Packages:

Antigen
oh-my-zsh
helix
gpu-stat

## Cargo

bat
bottom
du-dust
exa
fd-find
git-delta
git-graph
gitui
markdown-oxide
mdpls
ripgrp
simple-completion-language-server
tealdeer
texlab
zoxide

## LSP Stuff

See helix [README.md](.config/helix/README.md)
