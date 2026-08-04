#!/usr/bin/env bash
# Eli mute toggle — flip notifications on/off in ONE command.
# Wire into Apple Shortcuts: a "Run Shell Script" action that runs this file.
# Prints the new state ("muted" / "unmuted") to stdout so Shortcuts can use it.

FLAG="$HOME/.claude/.eli-quiet"
VOICE="Zoe (Premium)"

if [ -f "$FLAG" ]; then
  # currently muted → turn notifications back ON
  rm -f "$FLAG"
  /usr/bin/osascript -e 'display notification "Notifications on" with title "🔊 Eli unmuted"' >/dev/null 2>&1 &
  /usr/bin/say -v "$VOICE" "I'm back." >/dev/null 2>&1 &
  echo "unmuted"
else
  # currently on → MUTE (silent confirmation — you just asked for quiet)
  mkdir -p "$HOME/.claude"
  touch "$FLAG"
  /usr/bin/osascript -e 'display notification "Notifications off" with title "🔇 Eli muted"' >/dev/null 2>&1 &
  echo "muted"
fi
