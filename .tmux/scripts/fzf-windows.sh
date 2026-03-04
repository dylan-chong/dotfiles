#!/bin/bash

# Based on https://github.com/rulopimentel/tmux-fzf-windows, sorted by last visited.
# Requires hook in .tmux.conf: set-hook -g after-select-window 'set -w @last_visited "#{t:window_activity}"'

TARGET_SPEC="#{@last_visited}:#{session_id}:#{window_id}: Session #{session_name} -> #{window_name}"

LINE=$(tmux list-windows -a -F "$TARGET_SPEC" | sort -rn | cut -d: -f2- | fzf-tmux) || exit 0
args=(${LINE//:/ })

tmux switch-client -t ${args[0]}
tmux select-window -t ${args[1]}
