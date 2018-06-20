# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.bash"

fbr() {
  # list branches, including remotes
  # - remove star on current branch, and leading spaces
  # - remove remote/ from each line
  # - convert stuff like "origin/master" into "origin/master\nmaster"
  `git branch -a \
    | perl -pe 's/^\s*\*?\s*//' \
    | perl -pe 's/remotes\///' \
    | perl -pe 's/(\w+)\/(.*)/\1\/\2\n\2/' \
    | sort \
    | uniq \
    | fzf`
}

# Various Settings
# ---------------
# Respect gitignore
export FZF_DEFAULT_COMMAND="rg --files-with-matches --hidden '.' --glob '!.git'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
