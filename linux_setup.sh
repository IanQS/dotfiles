#!/bin/bash

# Terminate immediately if any command returns a non-zero exit code
set -e

# 1. Identify the OS
# We source os-release to get the $PRETTY_NAME variable
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Error: Cannot determine OS (missing /etc/os-release)."
    exit 1
fi

# 2. OS-Specific Logic
case "$PRETTY_NAME" in
    "EndeavourOS")
        echo "Detected EndeavourOS. Installing zsh..."
        sudo pacman -Syu --noconfirm zsh
	chsh -s $(which zsh)
        ;;
    # "Ubuntu")
    #    sudo apt update && sudo apt install -y zsh
    #    ;;
    *)
        echo "Error: Unrecognized OS ($PRETTY_NAME). Terminating script."
        exit 1
        ;;
esac

# Antigen
echo "Downloading Antigen..."
curl -L git.io/antigen > ~/antigen.zsh

# Rust
echo "Installing Rust..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | zsh -s -- -y

# zoxide
echo "Installing zoxide..."
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# uv
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

echo "Installing  Ollama"
curl -fsSL https://ollama.com/install.sh | sh

######################################################################3

# Install stuff from main
echo "Installing pacman packages..."
sudo pacman -Su --noconfirm libxi libxrender alsa-utils alsa-card-profiles alsa-firmware libxrandr terminator texlive-fontsextra libxcursor pavucontrol gparted beep texlive-formatsextra texlive-bibtexextra zip sof-firmware py3status texlive-latexextra libxcomposite libxau libxtst alsa-lib libxss alsa-ucm-conf tmux libpqxx redshift mesa-libgl libxdamage texlive-bin libglvnd texlive-core texmaker alsa-tools alsa-plugins unzip obsidian signal-desktop openssh lazygit ttf-fira-code ttf-firacode-nerd ttf-fira-mono ttf-nerd-fonts-symbols-mono spotify-launcher htop vivaldi vivaldi-ffmpeg-codecs

# Rust Stuff

echo "Installing cargo packages..."
cargo install bat ripgrep exa gitui mdpls git-graph texlab zoxide eza du-dust bottom tealdeer fd-find procs simple-completion-language-server git-delta

## Individual Rust packages (markdown-oxide, scls, mdpls
echo "Installing cargo packages from git sources..."
cargo install --locked --git https://github.com/Feel-ix-343/markdown-oxide.git markdown-oxide

cargo install --git https://github.com/euclio/mdpls

cargo install --locked --git https://github.com/estin/simple-completion-language-server.git

# Misc.

echo "Check bottom of file to see things that need to be installed via `yay`"

# yay:
#   - dropbox
#   - zotero
#   - nitrogen

# helix
 
# Setup Tmux
echo "Setting up Tmux... make sure you check the paths and where the local conf gets saved"
curl -fsSL "https://github.com/gpakosz/.tmux/raw/refs/heads/master/install.sh#$(date +%s)" | bash

