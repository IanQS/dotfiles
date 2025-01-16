# ~/.zprofile
# Sourced for login shells. Handles system-level setup and env vars.

# macOS path helper (if exists)
if [ -x /usr/libexec/path_helper ]; then
    PATH=""
    eval `/usr/libexec/path_helper -s`
fi

# Homebrew setup (macOS)
if command -v brew &>/dev/null; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Cargo/Rust setup
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi

# OS-Specific Settings
case "$(uname -sr)" in
    Darwin*)
        # Development tools
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
        
        # Compiler flags
        export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
        export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
        
        # Tool paths
        export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
        export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
        ;;
    Linux*)
        export TERMINAL=terminator
        export BROWSER=/usr/bin/firefox
        ;;
esac

# Conda initialization
if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/anaconda3/etc/profile.d/conda.sh"
elif [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
    . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
fi
