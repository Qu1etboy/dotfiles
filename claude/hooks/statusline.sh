#!/usr/bin/env bash
# Claude Code status line for Eli.
# Claude passes session info as JSON on stdin; we print one line to display.
#   left : 📁 folder · model · session · (5h/7d rate limits, low-signal) · Eli state
#   right: shaded context bar · used/total tokens · percent (aligned to terminal edge)
# Requires jq for the context math; degrades to a minimal line without it.

export LC_ALL="${LC_ALL:-en_US.UTF-8}"  # so wc -m counts codepoints, not bytes
input=$(cat)

# --- colors & bar glyphs -----------------------------------------------------
DIM=$'\033[2m'; RED=$'\033[31m'; GRN=$'\033[32m'; YEL=$'\033[33m'
CYN=$'\033[36m'; RST=$'\033[0m'
FILL="▓"; EMPTY="░"   # shaded blocks; swap FILL to "█" for harder contrast

# --- eli mute state (shared by the notify toggle) ----------------------------
eli_seg() {
  if [ -f "$HOME/.claude/.eli-quiet" ]; then
    printf '%s· 🔇 Eli muted%s' "$RED" "$RST"
  else
    printf '%s· 🔊 Eli%s' "$GRN" "$RST"
  fi
}

# --- fallback when jq is missing --------------------------------------------
if ! command -v jq >/dev/null 2>&1; then
  dir=$(printf '%s' "$input" | sed -n 's/.*"current_dir"[ :]*"\([^"]*\)".*/\1/p')
  model=$(printf '%s' "$input" | sed -n 's/.*"display_name"[ :]*"\([^"]*\)".*/\1/p')
  printf '%s📁 %s%s %s·%s %s%s%s %s\n' \
    "$DIM" "$(basename "$dir")" "$RST" "$DIM" "$RST" "$DIM" "$model" "$RST" "$(eli_seg)"
  exit 0
fi

# --- pull fields (one jq pass, newline-separated) ----------------------------
F=()
while IFS= read -r _l; do F+=("$_l"); done < <(printf '%s' "$input" | jq -r '
  .workspace.current_dir // .cwd // "",
  .model.display_name // "",
  .session_name // "",
  (.context_window.used_percentage // 0),
  (.context_window.context_window_size // 200000),
  (.rate_limits.five_hour.used_percentage // ""),
  (.rate_limits.seven_day.used_percentage // "")
')
dir=${F[0]}; model=${F[1]}; session=${F[2]}
pct=${F[3]}; size=${F[4]}; r5=${F[5]}; r7=${F[6]}
dir_base=$(basename "$dir" 2>/dev/null)

# --- helpers -----------------------------------------------------------------
# humanize a token count: 1000000 -> 1M, 200000 -> 200k, 10000 -> 10k, 1500 -> 1.5k
fmt_k() {
  awk -v n="$1" 'BEGIN{
    if (n >= 1000000) { v = n/1000000; if (v >= 10) printf "%dM", v + 0.5; else printf "%.1fM", v }
    else if (n >= 1000) { v = n/1000; if (v >= 10) printf "%dk", v + 0.5; else printf "%.1fk", v }
    else printf "%d", n
  }'
}
round() { awk -v n="$1" 'BEGIN{ printf "%d", n + 0.5 }'; }
# display width: strip ANSI, drop newlines, count codepoints
vis() { printf '%s' "$1" | sed -E $'s/\x1b\\[[0-9;]*m//g' | tr -d '\n' | wc -m | tr -d ' '; }
# truncate a plain string to n codepoints, appending … when cut
trunc() {
  local s="$1" n="$2"
  if [ "${#s}" -gt "$n" ]; then printf '%s…' "${s:0:n-1}"; else printf '%s' "$s"; fi
}

# --- left: build head (dir · model) and tail (rate limits · Eli) -------------
# session name is inserted between them later, once we know the space budget.
head="${DIM}📁 ${dir_base}${RST}"
[ -n "$model" ] && head="${head} ${DIM}·${RST} ${DIM}${model}${RST}"

rl=""
[ -n "$r5" ] && rl="5h $(round "$r5")%"
[ -n "$r7" ] && rl="${rl:+$rl }7d $(round "$r7")%"
eli=$(eli_seg)
tail_min="$eli"                                    # Eli state alone
tail_full="$eli"
[ -n "$rl" ] && tail_full="${DIM}· ${rl}${RST} ${eli}"  # + low-signal rate limits

# --- right segment: shaded context bar ---------------------------------------
WIDTH=12
used_tokens=$(awk -v p="$pct" -v s="$size" 'BEGIN{ printf "%d", (p/100)*s }')
filled=$(awk -v p="$pct" -v w="$WIDTH" 'BEGIN{ f=int((p/100)*w + 0.5); if (f>w) f=w; print f }')
pct_int=$(round "$pct")

# color by pressure: green < 50, yellow < 80, red >= 80
if   [ "$pct_int" -ge 80 ]; then col=$RED
elif [ "$pct_int" -ge 50 ]; then col=$YEL
else col=$GRN
fi

bar=""
for ((i = 0; i < filled; i++));    do bar+="$FILL";  done
for ((i = filled; i < WIDTH; i++)); do bar+="$EMPTY"; done

right="${col}${bar}${RST} ${DIM}$(fmt_k "$used_tokens")/$(fmt_k "$size")${RST} ${col}${pct_int}%${RST}"

# --- assemble left, fitting the session name to the remaining space ----------
# Claude Code sets $COLUMNS per run; tput/ioctl can't read the tty here because
# our stdout is captured. Wide glyphs (📁, Eli emoji, ⬢) render 2 cells but count
# as 1 codepoint, so add 1 each. We round widths UP and leave a 1-col margin so a
# glyph-width miscount pulls the right segment inward rather than overflowing
# (overflow makes Claude Code ellipsize the line — the "…" you saw).
cols=${COLUMNS:-80}
# Claude Code indents the status line row, so usable width is a few cells less
# than $COLUMNS. Reserve for that padding plus a cushion so the tail never hits
# the edge (overflow makes Claude Code ellipsize the line).
avail=$(( cols - 4 ))
wr=$(vis "$right")             # right segment has no wide glyphs
wh=$(( $(vis "$head") + 1 ))   # +1: 📁

# keep the rate limits only if the fixed parts still leave a 2-cell gap
tail="$tail_full"
if [ $(( wh + $(vis "$tail_full") + 1 + wr + 2 )) -gt "$avail" ]; then
  tail="$tail_min"
fi
wt=$(( $(vis "$tail") + 1 ))   # +1: Eli glyph

line1="$head"
wide_left=2                    # 📁 + Eli glyph, always present
if [ -n "$session" ]; then
  # " · ⬢ " decoration renders 6 cells (⬢ is wide); keep a 2-cell gap to the right
  budget=$(( avail - wh - wt - wr - 6 - 2 ))
  if [ "$budget" -ge 4 ]; then
    line1="${line1} ${DIM}·${RST} ${CYN}⬢ $(trunc "$session" "$budget")${RST}"
    wide_left=3                # + ⬢
  fi
fi
line1="${line1} ${tail}"

# --- align right segment to the terminal edge --------------------------------
gap=$(( avail - ($(vis "$line1") + wide_left) - wr ))
(( gap < 1 )) && gap=1

printf '%s%*s%s' "$line1" "$gap" "" "$right"
