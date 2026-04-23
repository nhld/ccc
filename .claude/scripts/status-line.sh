#!/bin/bash

# Simple status line - shows model and context usage only

data=$(cat)

# Get model name
model=$(echo "$data" | jq -r '.model.display_name // .model.id // "unknown"')

# Get cwd (short: last folder name)
cwd=$(echo "$data" | jq -r '.cwd // empty')
folder="${cwd##*/}"

# Get git branch
branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
fi

# Get context info
max_ctx=$(echo "$data" | jq -r '.context_window.context_window_size // 200000')
used_pct=$(echo "$data" | jq -r '.context_window.used_percentage // empty')

# Color codes
PINK='\033[35m'
YELLOW='\033[33m'
BOLD_YELLOW='\033[1;33m'
ORANGE='\033[38;5;208m'
BLUE='\033[34m'
RED='\033[38;5;196m'
GREEN='\033[32m'
RESET='\033[0m'

# Format context display
if [ -z "$used_pct" ] || [ "$used_pct" = "null" ]; then
    # Loading state - empty circles
    context_info="○○○○○○○○○○ loading..."
else
    pct=$(printf "%.0f" "$used_pct" 2>/dev/null || echo "$used_pct")
    [ "$pct" -gt 100 ] 2>/dev/null && pct=100

    # Calculate tokens in k
    used_k=$(( max_ctx * pct / 100 / 1000 ))
    max_k=$(( max_ctx / 1000 ))

    # Build circle bar (10 segments)
    bar=""
    filled=$(( pct / 10 ))

    # Green <50%, orange <80%, red >=80%
    if [ "$pct" -ge 80 ]; then
        COLOR="$RED"
    elif [ "$pct" -ge 50 ]; then
        COLOR="$ORANGE"
    else
        COLOR="$GREEN"
    fi

    for i in 0 1 2 3 4 5 6 7 8 9; do
        if [ "$i" -lt "$filled" ]; then
            bar="${bar}${COLOR}●${RESET}"
        else
            bar="${bar}○"
        fi
    done

    context_info="${bar} ${BOLD_YELLOW}${used_k}k${RESET}/${max_k}k (${pct}% used)"
fi

# Output: Folder (branch) | Model | Context
line1="${PINK}${folder}${RESET}"
[ -n "$branch" ] && line1="${line1} (${BLUE}${branch}${RESET})"
printf '%b\n' "${line1}"
printf '%b\n' "${ORANGE}${model}${RESET} | ${context_info}"
