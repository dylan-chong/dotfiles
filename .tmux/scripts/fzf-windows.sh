#!/bin/bash

# Based on https://github.com/rulopimentel/tmux-fzf-windows, sorted by recent activity

TARGET_SPEC="#{window_activity}:#{session_id}:#{window_id}: Session #{session_name} -> #{window_name}"

LINE=$(tmux list-windows -a -F "$TARGET_SPEC" | sort -rn | cut -d: -f2- | fzf-tmux) || exit 0
args=(${LINE//:/ })

tmux switch-client -t ${args[0]}
tmux select-window -t ${args[1]}
