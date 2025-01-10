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
git-graph

## Cargo

bat
bottom
du-dust
eza
fd-find
markdown-oxide
procs
ripgrep
simple-completion-language-server
yazi-cli
yazi-fm
git-delta

## LSP Stuff

See helix [README.md](.config/helix/README.md)
