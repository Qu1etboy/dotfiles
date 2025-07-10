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

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/fastwork/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/fastwork/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/fastwork/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/fastwork/Downloads/google-cloud-sdk/completion.zsh.inc'; fi
eval "$(~/.local/bin/mise activate zsh)"

# bun completions
[ -s "/Users/fastwork/.bun/_bun" ] && source "/Users/fastwork/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

[[ -s "/Users/fastwork/.gvm/scripts/gvm" ]] && source "/Users/fastwork/.gvm/scripts/gvm"

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/fastwork/.dart-cli-completion/zsh-config.zsh ]] && . /Users/fastwork/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

export STUDIO_JDK=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home

# set android studio path
# Android Path
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/emulator

export PATH="/Applications/Android Studio.app/Contents/MacOS:$PATH"

#set flutter and dart path
export PATH=$PATH:~/fvm/default/bin
export PATH="$PATH":"$HOME/.pub-cache/bin"
