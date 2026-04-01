#!/bin/bash

# Based on https://github.com/rulopimentel/tmux-fzf-windows, sorted by last visited.
# Requires hook in .tmux.conf: set-hook -g after-select-window 'run-shell "tmux set -w @last_visited $(date +%s)"'

TARGET_SPEC=$'#{session_id}\t#{window_id}\t#{@last_visited}\t#{session_name} -> #{window_name}'

SELECTION=$(tmux list-windows -a -F "$TARGET_SPEC" | sort -t$'\t' -k3,3rn | fzf-tmux --with-nth=4.. --delimiter=$'\t') || exit 0

SESSION_ID=$(printf '%s' "$SELECTION" | cut -f1)
WINDOW_ID=$(printf '%s' "$SELECTION" | cut -f2)

tmux switch-client -t "$SESSION_ID"
tmux select-window -t "$WINDOW_ID"