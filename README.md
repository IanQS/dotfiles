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

```rust
cargo install bat ripgrep exa gitui mdpls git-graph texlab zoxide eza du-dust bottom tealdeer fd-find procs simple-completion-language-server git-delta

cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide
cargo install --git https://github.com/euclio/mdpls
cargo install --locked --git https://github.com/estin/simple-completion-language-server.git

```

## LSP Stuff

See helix [README.md](.config/helix/README.md)
