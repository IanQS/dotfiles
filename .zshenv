# ~/.zshenv
# Minimal environment variables for all shells (interactive, login, scripts, etc.)
export TERM=xterm-256color
export EDITOR="hx"

# Basic PATH that's needed everywhere
export PATH="$HOME/.local/bin:$PATH"
export FLYWIRE_DATA_PATH="$HOME/flywire_data"
. "$HOME/.cargo/env"
