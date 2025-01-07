. "$HOME/.cargo/env"

case "$(uname -sr)" in
  
  Darwin*)
    echo 'Mac OS X .profile'
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

    export LDFLAGS="-L/opt/homebrew/opt/libomp/lib"
    export CPPFLAGS="-I/opt/homebrew/opt/libomp/include"
    ;;

  Linux*)
    echo 'Linux .profile'
    export TERMINAL=terminator
    export EDITOR=/usr/bin/vim
    export BROWSER=/usr/bin/firefox
    # source /usr/share/nvm/init-nvm.sh >> ~/.zshrc
    ;;

  # Add here more strings to compare
  # See correspondence table at the bottom of this answer

  *)
    echo 'Other OS' 
    ;;
esac

