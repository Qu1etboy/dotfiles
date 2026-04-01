########################################################
# 1. MISE CORE (Load this first)
########################################################
# This replaces nvm, gvm, and manual Java/Flutter pathing
eval "$(~/.local/bin/mise activate zsh)"

########################################################
# 2. PATH CONFIGURATION (The Zsh Way)
########################################################
# Using the lowercase 'path' array automatically updates the uppercase $PATH.
# Zsh handles duplicates and ordering much more cleanly this way.
path=(
  "$HOME/.local/bin"
  "$HOME/.bun/bin"
  "$HOME/Library/Android/sdk/platform-tools"
  "$HOME/Library/Android/sdk/tools"
  "$HOME/Library/Android/sdk/tools/bin"
  "$HOME/Library/Android/sdk/emulator"
  "/Applications/Android Studio.app/Contents/MacOS"
  "$HOME/.pub-cache/bin"
  $path # Keep existing paths
)
export PATH

########################################################
# 3. ENVIRONMENT VARIABLES
########################################################
export ANDROID_HOME="$HOME/Library/Android/sdk"
export BUN_INSTALL="$HOME/.bun"

# Terminal default
export EDITOR="vim"

# Note: We removed hardcoded JAVA_HOME. 
# Mise sets JAVA_HOME automatically when you run 'mise use java@17'

########################################################
# 4. EXTERNAL TOOLS & COMPLETIONS
########################################################

# Google Cloud SDK
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
  source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
fi

# Bun Completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Dart CLI Completion
[[ -f "$HOME/.dart-cli-completion/zsh-config.zsh" ]] && . "$HOME/.dart-cli-completion/zsh-config.zsh"
