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

## Claude Code

Everything Claude-related lives in `.claude/`, so `stow .` links each file into `~/.claude`. Claude's own state (sessions, history, caches) stays in `~/.claude` and out of this repo. This only works if `~/.claude` already exists as a real folder. On a new machine, run `mkdir ~/.claude` before `stow .`, or stow links the whole folder and Claude writes its state into this repo.

- `CLAUDE.md`, `claude_statusline.py` and `notify.sh` are the same on every machine and are stowed as symlinks. `notify.sh` calls `osascript` on macOS and `notify-send` on Linux, so the hook command does not change between machines.
- `settings.shared.json` is the part of the settings that every machine shares: permissions, hooks, status line, editor and theme. It gets merged into each machine's real `~/.claude/settings.json`. That file is never a symlink, because Claude Code and `instructions install-hook` both rewrite it and would break the link.
- The sounds play from `~/Desktop/notifications/`, which is not in this repo. Copy them to each machine.
- The global `CLAUDE.md` reads notes from `~/research/instructions/notes/`. Clone INSTRUCTIONS there: `git clone git@github.com:IanQS/instructions.git ~/research/instructions`.

### Adopt on a machine that already has Claude files

1. Make sure this repo has no uncommitted work: `git -C ~/dotfiles status`. Step 7 discards local edits.
2. If `~/.claude/settings.json` is a symlink into this repo, make it a real file before you pull. The pull deletes its old target.
   `cp ~/.claude/settings.json ~/.claude/settings.json.real && mv ~/.claude/settings.json.real ~/.claude/settings.json`
3. Pull: `cd ~/dotfiles && git pull`
4. Install the tools: `brew install stow jq mpg123` on macOS, `sudo pacman -S stow jq mpg123 libnotify` on Linux.
5. List dead links that the old layout left behind: `find -L ~ ~/.claude -maxdepth 1 -type l -exec ls -l {} +`. Unlink each one that points into `dotfiles/`.
6. Stow, and move the machine's existing files into the repo: `stow --adopt .`
7. See how the machine's copies differ from the repo: `git diff`. Commit what you want to keep. Discard the rest: `git checkout -- .`
8. Merge the shared settings into this machine's settings:
   `jq -s '.[0] * .[1]' ~/.claude/settings.json ~/.claude/settings.shared.json > ~/.claude/settings.json.new && mv ~/.claude/settings.json.new ~/.claude/settings.json`
9. Add the INSTRUCTIONS sync hook. It is safe to run again: `~/research/instructions/bin/instructions install-hook`
10. Restart Claude Code. Trigger a permission prompt and check for the notification and the bell.

### Change something later

- `CLAUDE.md`, `claude_statusline.py`, `notify.sh`: edit the file through the symlink, then commit here.
- `settings.shared.json`: edit it, commit, then run the step 8 merge on every machine. In the merge, the shared file wins and lists are replaced whole. Keys the shared file does not mention (model, effort, plugins, `autoMode`) stay local to each machine.

## Changing Lock and Login screen

### Login Screen

1. Check if you have `/etc/lightdm/slick-greeter.conf`. If you do not, you gotta google... if you do...

2. move the wallpaper of interest to `/usr/share/endeavouros/backgrounds/`

3. Edit the `conf` from step 1 to point the background to the new file

## Helix

(Only relevant if you built from source)

If you do not have any color showing up, make sure you link the runtimes. Wherever you installed helix, you want to softlink the location!

```sh
ln -Tsf $PWD/runtime ~/.cargo/bin/runtime

# Probably not necessary
# ln -Tsf $PWD/runtime ~/.config/helix/runtime
```

## Tmux

When you install you might run into some weird path stuff. Make sure your tmux is reading from the right location

## Rust Packages

```
cargo install bat ripgrep gitui git-graph texlab zoxide eza du-dust bottom tealdeer fd-find procs git-delta codebook-lsp tex-fmt


cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide && cargo install --locked --git https://github.com/estin/simple-completion-language-server.git && cargo install --git https://github.com/latex-lsp/texlab --locked --tag v5.26.0
```

We then need to fetch the new snippets:

```
simple-completion-language-server fetch-external-snippets
simple-completion-language-server validate-snippets
```
