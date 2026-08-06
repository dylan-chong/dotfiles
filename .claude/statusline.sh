#!/bin/bash
input=$(cat)

MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
EFFORT=$(echo "$input" | jq -r '.effort.level // empty')

# Running total cost for the whole session (persists across turns, resets on /clear)
SESSION_COST=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')
COST_FMT=$(printf "%.2f" "$SESSION_COST")

# Cumulative session token usage: context_window fields are a snapshot of the
# latest API call only (not cumulative), so sum usage from the transcript
# instead. Dedupe by message id first — the transcript has repeated lines
# per assistant message (streaming/sidechain writes) that would otherwise
# cause triple-counting.
TRANSCRIPT=$(echo "$input" | jq -r '.transcript_path // empty')
CUM_IN=0
CUM_OUT=0
if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  read -r CUM_IN CUM_OUT <<< "$(jq -rs '
    [.[] | select(.type=="assistant" and .message.usage) | {id: .message.id, u: .message.usage}]
    | unique_by(.id)
    | [ (map(.u.input_tokens + .u.cache_creation_input_tokens + .u.cache_read_input_tokens) | add // 0),
        (map(.u.output_tokens) | add // 0) ]
    | @tsv' "$TRANSCRIPT" 2>/dev/null)"
  CUM_IN=${CUM_IN:-0}
  CUM_OUT=${CUM_OUT:-0}
fi
CUM_IN_FMT=$(printf "%'d" "$CUM_IN")
CUM_OUT_FMT=$(printf "%'d" "$CUM_OUT")

# Build progress bar
BAR_WIDTH=20
FILLED=$((PCT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))
BAR=""
if [ "$FILLED" -gt 0 ]; then
  printf -v FILL "%${FILLED}s"
  BAR="${FILL// /▓}"
fi
if [ "$EMPTY" -gt 0 ]; then
  printf -v PAD "%${EMPTY}s"
  BAR="${BAR}${PAD// /░}"
fi

# Color-code based on usage
if [ "$PCT" -ge 90 ]; then
  COLOR='\033[31m'  # Red
elif [ "$PCT" -ge 70 ]; then
  COLOR='\033[33m'  # Yellow
else
  COLOR='\033[32m'  # Green
fi
RESET='\033[0m'

EFFORT_SEGMENT=""
if [ -n "$EFFORT" ]; then
  EFFORT_SEGMENT=" | Effort: ${EFFORT}"
fi

echo -e "[$MODEL] ${COLOR}$BAR ${PCT}%${RESET} | Session tokens: ${CUM_IN_FMT} in / ${CUM_OUT_FMT} out | Session cost: \$${COST_FMT}${EFFORT_SEGMENT}"
