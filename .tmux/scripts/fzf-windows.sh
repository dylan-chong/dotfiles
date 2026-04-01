#!/bin/bash

# Based on https://github.com/rulopimentel/tmux-fzf-windows, sorted by last visited.
# Requires hook in .tmux.conf: set-hook -g after-select-window 'set -w @last_visited "#{t:window_activity}"'

TARGET_SPEC="#{@last_visited}:#{session_id}:#{window_id}:#{session_name} -> #{window_name}"

LINE=$(tmux list-windows -a -F "$TARGET_SPEC" | sort -rn | cut -d: -f4- | fzf-tmux) || exit 0

# Re-lookup the selected entry to get session_id and window_id
MATCH=$(tmux list-windows -a -F "$TARGET_SPEC" | grep -F ":$LINE" | head -1)
SESSION_ID=$(echo "$MATCH" | cut -d: -f2)
WINDOW_ID=$(echo "$MATCH" | cut -d: -f3)

tmux switch-client -t "$SESSION_ID"
tmux select-window -t "$WINDOW_ID"