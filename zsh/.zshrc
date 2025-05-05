source ~/dotfiles/.aliases

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias s='source ~/.zshrc'

source <(fzf --zsh)
eval "$(starship init zsh)"

function java-use {
  export JAVA_HOME=`/usr/libexec/java_home -v $1`
}

function take {
  mkdir -p $1
  cd $1
}

export PATH="/Users/qu1etboy/Library/Python/3.9/bin:$PATH"
export PATH=$PATH:$(go env GOPATH)/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export BUN_INSTALL="$HOME/.bun"

[[ -s "/Users/qu1etboy/.gvm/scripts/gvm" ]] && source "/Users/qu1etboy/.gvm/scripts/gvm"

