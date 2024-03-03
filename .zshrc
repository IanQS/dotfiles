# manual crop: pdfcrop --margins '-75 -40 -56 -40' --clip odd.pdf odd_cropped.pdf  # Left, Top, Right, bottom
# Auto crop: pdf-crop-margins -s -u -mo $FILENAME
#   - for f in *.pdf ; do pdf-crop-margins -mo -s -u $f; done
# Drop pages
#   - qpdf book.pdf --pages .  2-1313 -- --replace-input

case "$(uname -sr)" in
  
  Darwin*)
    echo 'Zshrc Mac OS X'
    source ~/antigen.zsh
    ;;

  Linux*)
    echo 'Zshrc Linux'
    source /usr/share/zsh/share/antigen.zsh
    ;;

  # Add here more strings to compare
  # See correspondence table at the bottom of this answer

  *)
    echo 'Other OS' 
    ;;
esac


# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Plugins that exist in oh-my-zsh
antigen bundle wd
antigen bundle sudo
antigen bundle git
antigen bundle colored-man-pages

# Load the theme.
antigen theme tweekmonster/nanofish nanofish

# Plugins that exist outside oh-my-zsh so we have to specify the repo
antigen bundle peterhurford/up.zsh
antigen bundle esc/conda-zsh-completion
antigen bundle jeffreytse/zsh-vi-mode

# Tell antigen that you're done.
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

export EDITOR="nvim"
export TERM=xterm-256color

alias sl='exa'
alias ls='exa'
alias vim='nvim'
alias top='bottom'
alias cat='bat'
alias screenAbove="xrandr --output HDMI1 --mode 1920x1080 --above eDP1"
alias screenReset="xrandr -s 0"
alias build="mkdir build; cd build; cmake ..; make -j 4; cd ../"
alias rebuild="cd build; cmake ..; make -j 6; cd ../"

# Zplug configuration stuff below
#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=~/.zhistory
#append into history file
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

export PATH=$PATH:/home/iq/.local/bin
export RUSTC_WRAPPER=sccache
eval "$(register-python-argcomplete pipx)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


eval "$(zoxide init zsh)"
. "$HOME/.cargo/env"

case "$(uname -sr)" in
  
  Darwin*)
    echo 'Mac OS X'
    export PATH=/opt/homebrew/anaconda3/bin:$PATH
    export PATH="$PATH:/Users/ianquah/Library/Application Support/JetBrains/Toolbox/scripts"
    eval "$(/opt/homebrew/bin/brew shellenv)"

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup

    ;;

  Linux*)
    echo 'Linux'

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/iq/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/home/iq/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/home/iq/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/home/iq/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

    autoload -Uz compinit
    ;;

  # Add here more strings to compare
  # See correspondence table at the bottom of this answer

  *)
    echo 'Other OS' 
    ;;
esac

