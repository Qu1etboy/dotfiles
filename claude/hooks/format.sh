#!/usr/bin/env bash
# Auto-format a file after Claude edits it.
# PostToolUse hook: receives event JSON on stdin, routes by file extension.

INPUT=$(cat)

if command -v jq >/dev/null 2>&1; then
  FILE=$(printf '%s' "$INPUT" | jq -r '.tool_input.file_path // ""')
else
  FILE=$(printf '%s' "$INPUT" | python3 -c \
    "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)
fi

[ -z "$FILE" ] || [ ! -f "$FILE" ] && exit 0

EXT="${FILE##*.}"
case "$EXT" in
  go)
    command -v gofmt >/dev/null 2>&1 && gofmt -w "$FILE"
    ;;
  ex|exs)
    command -v mix >/dev/null 2>&1 && mix format "$FILE" 2>/dev/null
    ;;
  js|jsx|ts|tsx|json|css|scss|html|md|yaml|yml)
    if command -v prettier >/dev/null 2>&1; then
      prettier --write "$FILE" 2>/dev/null
    elif command -v npx >/dev/null 2>&1; then
      npx --no-install prettier --write "$FILE" 2>/dev/null
    fi
    ;;
esac

exit 0
