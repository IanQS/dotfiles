# ~/.zshrc
# Configuration for interactive shells

# keychain may prompt for the key's passphrase, so it has to run before the instant prompt
if [[ $OSTYPE == linux* ]]; then
    eval "$(keychain --eval --quiet id_ed25519)"
fi

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load plugin manager
source ~/antigen.zsh || source /usr/share/zsh/share/antigen.zsh

# tmuxp session files: ~/.tmuxp/desktop on the work desktop (Linux), ~/.tmuxp/laptop on the Mac
case $OSTYPE in
    linux*)
        TMUXP_SESSIONS_DIR=~/.tmuxp/desktop
        ;;
    darwin*)
        TMUXP_SESSIONS_DIR=~/.tmuxp/laptop
        ;;
esac

# Load every saved tmuxp session for this machine
loadTmux() {
    local -a files
    files=($TMUXP_SESSIONS_DIR/*.yaml(N))

    if (( ${#files[@]} == 0 )); then
        echo "loadTmux: no tmuxp session files found in $TMUXP_SESSIONS_DIR"
        return 1
    fi

    tmuxp load "${files[@]}"
}

# Save every running tmux session to $TMUXP_SESSIONS_DIR/<session name, lowercased>.yaml
saveTmux() {
    local -a sessions
    sessions=(${(f)"$(tmux list-sessions -F '#{session_name}' 2>/dev/null)"})

    if (( ${#sessions[@]} == 0 )); then
        echo "saveTmux: no running tmux sessions"
        return 1
    fi

    local session
    for session in "${sessions[@]}"; do
        tmuxp freeze "$session" -y -o "$TMUXP_SESSIONS_DIR/${session:l}.yaml"
    done
}

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
setopt SHARE_HISTORY HIST_IGNORE_DUPS EXTENDED_HISTORY

# API keys and other secrets live outside this (public) repo
[[ -r ~/.zsh_secrets ]] && source ~/.zsh_secrets

# Modern Command Replacements
alias ls='eza'
alias rg='rg -i --hidden'
alias la='eza -lah'
alias ollamaLogs='journalctl -u ollama --no-pager --follow --pager-end'
alias diff='hunk diff --files'
alias vim='hx'
alias top='btm'
alias cat='bat'
alias nvim='hx'

# Development Aliases
alias ggraph='git-graph'
alias gpuWatcher='gpustat -cp --watch'

# Display Management
alias screenAbove="xrandr --output HDMI1 --mode 1920x1080 --above eDP1"
alias screenReset="xrandr -s 0"

# Build System
alias build="mkdir build; cd build; cmake ..; make -j 4; cd ../"
alias rebuild="cd build; cmake ..; make -j 6; cd ../"

# Remove broken symlinks in the given directory (default: current directory)
cleanDeadSymlinks() {
    local -a dead
    dead=(${1:-.}/*(ND-@))
    (( ${#dead[@]} )) && rm -- "${dead[@]}"
}

# Tool Initialization
zvm_after_init_commands+=('source <(fzf --zsh)')
eval "$(zoxide init zsh)"
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# Theme Configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

case $OSTYPE in
    darwin*)
        export PATH="$(brew --prefix)/opt/llvm/bin:$PATH" # Needs to be here, if not brew isn't detected properly
        # bun completions
        [ -s "/Users/ianquah/.bun/_bun" ] && source "/Users/ianquah/.bun/_bun"
        [[ ! -r '/Users/ianquah/.opam/opam-init/init.zsh' ]] || source '/Users/ianquah/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
        alias claude-mem='bun "/Users/ianquah/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'
        [ -f "/Users/ianquah/.ghcup/env" ] && . "/Users/ianquah/.ghcup/env" # ghcup-env
        ;;
    linux*)
        export HELIX_RUNTIME=~/helix/runtime
        . "$HOME/.local/bin/env"
        # Added by the Hunk installer (https://hunk.dev)
        export PATH='/home/iq/.hunk/bin':"$PATH"
        [ -f "/home/iq/.ghcup/env" ] && . "/home/iq/.ghcup/env" # ghcup-env

        ;;
esac

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	command rm -f -- "$tmp"
}

