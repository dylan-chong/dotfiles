#!/bin/bash

# Flat window picker combining running tmux windows and saved lazy-tmux sessions.
# Running windows switch directly; saved windows wake via lazy-tmux first.

LAZY_DIR="${HOME}/.local/share/lazy-tmux"
RUNNING_SESSIONS=$(tmux list-sessions -F "#{session_name}" 2>/dev/null)

# Running windows: session_id<TAB>window_id<TAB>last_visited<TAB>session_name -> window_name
RUNNING=$(tmux list-windows -a -F $'#{session_id}\t#{window_id}\t#{@last_visited}\t#{session_name} -> #{window_name}' 2>/dev/null | sort -t$'\t' -k3,3rn)

# Saved-but-not-running windows from lazy-tmux
SAVED=""
if [[ -f "$LAZY_DIR/index.json" ]]; then
  SAVED=$(python3 -c "
import json, sys, os

with open('$LAZY_DIR/index.json') as f:
    index = json.load(f)

running = set('''$RUNNING_SESSIONS'''.strip().split('\n'))

for name, meta in sorted(index.get('sessions', {}).items()):
    if name in running:
        continue
    sess_file = meta.get('file', '')
    if not os.path.isfile(sess_file):
        continue
    with open(sess_file) as sf:
        sess = json.load(sf)
    for w in sess.get('windows', []):
        wname = w.get('name', '')
        print(f'saved\t{name}\t0\t{name} -> {wname} (saved)')
" 2>/dev/null)
fi

# Combine and pick
SELECTION=$(printf '%s\n%s' "$RUNNING" "$SAVED" | grep -v '^$' | fzf-tmux --with-nth=4.. --delimiter=$'\t') || exit 0

TYPE=$(printf '%s' "$SELECTION" | cut -f1)

if [[ "$TYPE" == "saved" ]]; then
  SESSION_NAME=$(printf '%s' "$SELECTION" | cut -f2)
  lazy-tmux wakeup -session "$SESSION_NAME"
  # Wait briefly for the session to appear
  for i in 1 2 3 4 5; do
    tmux has-session -t "$SESSION_NAME" 2>/dev/null && break
    sleep 0.2
  done
  tmux switch-client -t "$SESSION_NAME"
else
  SESSION_ID=$(printf '%s' "$SELECTION" | cut -f1)
  WINDOW_ID=$(printf '%s' "$SELECTION" | cut -f2)
  tmux switch-client -t "$SESSION_ID"
  tmux select-window -t "$WINDOW_ID"
fi