# Setup fzf
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  export PATH="$PATH:/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.bash" 2> /dev/null

complete -F _fzf_dir_completion -o default -o bashdefault tree l c

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.bash"

fbr() {
  # Copied from https://github.com/junegunn/fzf/wiki/Examples#git
  # but i removed the git checkout to so at the end this function can be used
  # more generally, and remove the maximum count
  local branches branch
  branches=$(git for-each-ref --sort=-committerdate refs/heads/ --format="%(refname:short)") &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##"
}

# Various Settings
# ---------------
# Respect gitignore
export FZF_DEFAULT_COMMAND="rg --files --hidden '.' --glob '!.git'"
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf.history"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
