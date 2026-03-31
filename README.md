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

## Changing Lock and Login screen

### Login Screen

1) Check if you have `/etc/lightdm/slick-greeter.conf`. If you do not, you gotta google... if you do...

2) move the wallpaper of interest to `/usr/share/endeavouros/backgrounds/`

3) Edit the `conf` from step 1 to point the background to the new file

## Helix

(Only relevant if you built from source)

If you do not have any color showing up, make sure you link the runtimes. Wherever you installed helix, you want to softlink the location!

```sh
ln -Tsf $PWD/runtime ~/.cargo/bin/runtime

# Probably not necessary
# ln -Tsf $PWD/runtime ~/.config/helix/runtime
```
