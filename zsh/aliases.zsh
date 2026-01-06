alias killport='f() { kill $(lsof -ti:$1) 2>/dev/null || echo "no process on port $1"; }; f'

alias s='source ~/.zshrc'
