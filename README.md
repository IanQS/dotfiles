[Bla](www.google.com)

# Workflow to add new folder/file

For some reason, `stow` isn't working with me.... So, do the following:

```
# Break the symlinks
rm -rf dotfiles

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
