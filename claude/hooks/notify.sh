#!/usr/bin/env bash
# Eli notifications — silent macOS banner + spoken voice.
# Usage:  notify.sh <needs|done>
# Mute:   touch ~/.claude/.eli-quiet   (or use the eli-mute / eli-unmute aliases)

# --- respect the mute toggle -------------------------------------------------
[ -f "$HOME/.claude/.eli-quiet" ] && exit 0

# --- consume the JSON the hook sends on stdin so we don't break the pipe -----
cat >/dev/null 2>&1 || true

EVENT="${1:-done}"
VOICE="Zoe (Premium)"   # change with: say -v '?'  to list installed voices

case "$EVENT" in
  needs)
    TITLE="Eli needs you"
    LINES=(
      "Hey, I need your call on something."
      "Your move — I need you."
      "Quick decision for you when you're ready."
    )
    ;;
  *)
    TITLE="Eli"
    LINES=(
      "Done — your turn."
      "All finished."
      "That's done, take a look."
    )
    ;;
esac

# --- pick a line at random ---------------------------------------------------
LINE="${LINES[$RANDOM % ${#LINES[@]}]}"

# --- silent banner + spoken voice (backgrounded so the hook returns fast) ----
/usr/bin/osascript -e "display notification \"$LINE\" with title \"$TITLE\"" >/dev/null 2>&1 &
/usr/bin/say -v "$VOICE" "$LINE" >/dev/null 2>&1 &

exit 0
