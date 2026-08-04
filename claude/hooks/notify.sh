#!/usr/bin/env bash
# Eli notifications — silent macOS banner + spoken voice.
# Usage:  notify.sh <needs|done|permission>
# Mute:   touch ~/.claude/.eli-quiet   (or use the eli-toggle alias / Apple Shortcut)

[ -f "$HOME/.claude/.eli-quiet" ] && exit 0

INPUT=$(cat)   # always read stdin — hooks send JSON; permission case uses it
EVENT="${1:-done}"
VOICE="Zoe (Premium)"

case "$EVENT" in
  permission)
    TITLE="Eli needs you"
    CMD=""
    TOOL=""
    if command -v jq >/dev/null 2>&1; then
      CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // .tool_input.file_path // ""')
      TOOL=$(printf '%s' "$INPUT" | jq -r '.tool_name // ""')
    fi
    if [ -n "$CMD" ]; then
      CMD_SHORT=$(printf '%s' "$CMD" | head -c 50)
      LINE="Need your OK: $CMD_SHORT"
    elif [ -n "$TOOL" ]; then
      LINE="Need your OK to use $TOOL"
    else
      LINE="Need your call on something."
    fi
    ;;
  needs)
    TITLE="Eli needs you"
    LINES=(
      "Hey, I need your call on something."
      "Your move — I need you."
      "Quick decision for you when you're ready."
    )
    LINE="${LINES[$RANDOM % ${#LINES[@]}]}"
    ;;
  *)
    TITLE="Eli"
    LINES=(
      "Done — your turn."
      "All finished."
      "That's done, take a look."
    )
    LINE="${LINES[$RANDOM % ${#LINES[@]}]}"
    ;;
esac

/usr/bin/osascript -e "display notification \"$LINE\" with title \"$TITLE\"" >/dev/null 2>&1 &
/usr/bin/say -v "$VOICE" "$LINE" >/dev/null 2>&1 &

exit 0
