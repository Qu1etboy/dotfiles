#!/usr/bin/env bash
# Claude Code status line for Eli.
# Claude passes session info as JSON on stdin; we print one line to display.
# Shows: current folder · model · Eli's notification state (🔊 on / 🔇 muted).

input=$(cat)

# --- pull fields (jq if present, else a light sed fallback) ------------------
if command -v jq >/dev/null 2>&1; then
  dir=$(printf '%s' "$input"   | jq -r '.workspace.current_dir // .cwd // ""')
  model=$(printf '%s' "$input" | jq -r '.model.display_name // ""')
else
  dir=$(printf '%s' "$input"   | sed -n 's/.*"current_dir"[ :]*"\([^"]*\)".*/\1/p')
  model=$(printf '%s' "$input" | sed -n 's/.*"display_name"[ :]*"\([^"]*\)".*/\1/p')
fi
dir_base=$(basename "$dir" 2>/dev/null)

# --- colors ------------------------------------------------------------------
DIM=$'\033[2m'; RED=$'\033[31m'; GRN=$'\033[32m'; RST=$'\033[0m'

# --- build the line ----------------------------------------------------------
line="${DIM}📁 ${dir_base}${RST}"
[ -n "$model" ] && line="${line} ${DIM}·${RST} ${DIM}${model}${RST}"

if [ -f "$HOME/.claude/.eli-quiet" ]; then
  line="${line} ${RED}· 🔇 Eli muted${RST}"
else
  line="${line} ${GRN}· 🔊 Eli${RST}"
fi

printf '%s' "$line"
