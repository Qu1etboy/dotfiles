#!/usr/bin/env bash
cat >/dev/null  # drain stdin (event JSON not needed)
DATE=$(date +"%Y-%m-%d %H:%M %Z (%A)")
printf '{"hookSpecificOutput": {"hookEventName": "UserPromptSubmit", "additionalContext": "Current date and time: %s"}}\n' "$DATE"
exit 0
