# Setup fzf
# ---------

# FZF (unixorn/fzf-zsh-plugin)
if [ -d "$HOME/.fzf/bin" ]; then
  export PATH="$PATH:$HOME/.fzf/bin"
  source "$HOME/.fzf/shell/key-bindings.zsh"
  source "$HOME/.fzf/shell/completion.zsh"
fi

fbr() {
  # TODO later make unique list and sort branches by last commit date like `git
  # show --format="%ci %cr" master` or something similar

  local trim_leading_star_and_spaces remove_head_arrow remove_duplicates
  local locals combined_list remotes remotes_no_remote_name_prefix

  trim_leading_star_and_spaces() {
    cat - | perl -pe 's/^\s*\*?\+?\s*//'
  }

  remove_head_arrow() {
    # changes `origin/HEAD -> origin/master` to `origin/HEAD`
    cat - | perl -pe 's/ -> .*//'
  }

  remove_duplicates() {
    # https://stackoverflow.com/a/11532197/1726450
    cat - | awk '!x[$0]++'
  }

  locals=`git branch --sort=-committerdate | trim_leading_star_and_spaces`;
  remotes=`git branch -r --sort=-committerdate | trim_leading_star_and_spaces | remove_head_arrow`;
  remotes_no_remote_name_prefix=`echo "$remotes" | perl -pe 's/[^\/]+\///'`;

  combined_list="$locals\n$remotes\n$remotes_no_remote_name_prefix"

  printf "$combined_list" | remove_duplicates | fzf
}

# Various Settings
# ---------------
# Respect gitignore
export FZF_DEFAULT_COMMAND="rg --files --hidden '.' --glob '!.git'"
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf.history"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
