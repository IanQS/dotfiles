# ~/.zshrc
# Configuration for interactive shells

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load plugin manager
case "$(uname -sr)" in
    Darwin*)
        source ~/antigen.zsh
        ;;
    Linux*)
        source ~/antigen.zsh || source /usr/share/zsh/share/antigen.zsh
        ;;
esac

# Plugin Configuration
antigen use oh-my-zsh

# Core plugins
antigen bundle wd
antigen bundle sudo
antigen bundle git
antigen bundle colored-man-pages

# External plugins
antigen bundle peterhurford/up.zsh
antigen bundle "MichaelAquilina/zsh-you-should-use"
antigen bundle jeffreytse/zsh-vi-mode
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle vincentto13/uvenv.plugin.zsh

# Theme
antigen theme romkatv/powerlevel10k
antigen apply

# History Configuration
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zhistory
setopt INC_APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS EXTENDED_HISTORY

# Modern Command Replacements
alias ls='eza'
alias la='eza -lah'
alias diff='delta'
alias vim='hx'
alias top='bottom'
alias cat='bat'
alias nvim='hx'

# Development Aliases
alias cleanDeadSymlinks='for f in `find -L $DIR -maxdepth 1 -type l`; do unlink $f; done'
alias ggraph='git-graph'
alias gpuWatcher='gpustat -cp --watch'

# Display Management
alias screenAbove="xrandr --output HDMI1 --mode 1920x1080 --above eDP1"
alias screenReset="xrandr -s 0"

# Build System
alias build="mkdir build; cd build; cmake ..; make -j 4; cd ../"
alias rebuild="cd build; cmake ..; make -j 6; cd ../"

# Tool Initialization
zvm_after_init_commands+=('source <(fzf --zsh)')
eval "$(zoxide init zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# Theme Configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/iq/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/iq/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/iq/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/home/iq/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

alias claude="/Users/ianquah/.claude/local/claude"
