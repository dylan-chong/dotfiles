# Load private stuff
source ~/.zshrc_private

# Homebrew
[ -f /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"



# Paths

# {{{

if [ -z "$NO_MODIFY_PATH" ]; then
  # Ubuntu / WSL (for custom binaries, like neovim)
  command -v brew &> /dev/null || export PATH="$PATH:$HOME/bin"

  # Ubuntu / WSL (Snap, if I ever use it)
  command -v snap &> /dev/null && export PATH="$PATH:/snap/bin"

  # Ubuntu / WSL (Rustup)
  command -v brew &> /dev/null || export PATH="$PATH:$HOME/.cargo/bin"

  # ASDF
  command -v brew &> /dev/null && . $(brew --prefix asdf)/libexec/asdf.sh
  [ -f "$HOME/.asdf/asdf.sh" ] && . "$HOME/.asdf/asdf.sh" # Ubuntu / WSL

  # Python
  command -v brew &> /dev/null && export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
  command -v brew &> /dev/null && export PATH="/Users/Dylan/Library/Python/3.9/bin:${PATH}"

  # Kinda path related...
  [ -f "/proc/sys/fs/binfmt_misc/WSLInterop" ] && export BROWSER=wslview

  command -v go &> /dev/null && export PATH="$(go env GOPATH)/bin:$PATH"
fi

# Lvim
export PATH="${PATH}:$HOME/.local/bin"

# }}}



# Antigen

# {{{

ANTIGEN_LOG=~/.antigen/debug.log

# Mac
command -v brew &> /dev/null && source "$(brew --prefix antigen)/share/antigen/antigen.zsh"
# Ubuntu/WSL
[ -f "/usr/share/zsh-antigen/antigen.zsh" ] && source "/usr/share/zsh-antigen/antigen.zsh"

if command -v antigen &> /dev/null; then
  antigen use oh-my-zsh

  antigen bundle https://github.com/robbyrussell/oh-my-zsh.git plugins/vi-mode

  # Themes
  # base16-shell doesn't follow the zsh plug format so can't be used with `theme` (I think)
  antigen bundle chriskempson/base16-shell
  antigen bundle spaceship-prompt/spaceship-prompt
  antigen bundle zsh-users/zsh-syntax-highlighting

  # History/autocomplete
  antigen bundle zsh-users/zsh-autosuggestions

  # Random utils
  antigen bundle MichaelAquilina/zsh-you-should-use
  antigen bundle "$GPRQ_DIR" --no-local-clone
  antigen bundle grigorii-zander/zsh-npm-scripts-autocomplete@main
  antigen bundle unixorn/fzf-zsh-plugin@main

  antigen apply
fi

# }}}



# Antigen plugin config

# {{{

# spaceship-prompt/spaceship-prompt
# Commenting out prompts for speed (copied from
# https://github.com/spaceship-prompt/spaceship-prompt/blob/master/docs/options.md#order)
SPACESHIP_PROMPT_ORDER=(
  time          # Time stamps section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  # hg            # Mercurial section (hg_branch  + hg_status)
  # package       # Package version
  # gradle        # Gradle section
  # maven         # Maven section
  # node          # Node.js section
  # ruby          # Ruby section
  # elixir        # Elixir section
  # xcode         # Xcode section
  # swift         # Swift section
  # golang        # Go section
  # php           # PHP section
  # rust          # Rust section
  # haskell       # Haskell Stack section
  # julia         # Julia section
  # docker        # Docker section
  # aws           # Amazon Web Services section
  # gcloud        # Google Cloud Platform section
  # venv          # virtualenv section
  # conda         # conda virtualenv section
  # pyenv         # Pyenv section
  # dotnet        # .NET section
  # ember         # Ember.js section
  # kubectl       # Kubectl context section
  # terraform     # Terraform workspace section
  # ibmcloud      # IBM Cloud section
  # exec_time     # Execution time
  # battery       # Battery level and status
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  line_sep      # Line break
  # vi_mode       # Vi-mode indicator - always shows I
  char          # Prompt character
)
# Time
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_COLOR=cyan
SPACESHIP_TIME_FORMAT='%D{%H:%M:%S.%.}'
# SPACESHIP_DIR_TRUNC doesn't work if SPACESHIP_DIR_TRUNC_REPO is true
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_DIR_COLOR=blue
SPACESHIP_DIR_TRUNC_PREFIX=.../
SPACESHIP_DIR_TRUNC=2
# I don't like the little symbols
SPACESHIP_GIT_STATUS_SHOW=false
SPACESHIP_GIT_BRANCH_COLOR=magenta

# }}}



# Useful Paths

# {{{

if command -v brew &> /dev/null; then
  alias godesk="c ~/Desktop"
  alias gocrap="c ~/Desktop/crap"
  alias godown="c ~/Downloads"

  alias gogit="c ~/Dropbox/Programming/GitHub"
  alias godev="c ~/Development/"

  alias goscripts="c ~/Dropbox/Programming/GitHub/itunes-applescripts"
else
  alias gopar="c ~/partly-development/"
  alias godev="c ~/other-development/"
fi

# }}}



# Useful commands

# {{{

# Vim
alias vi="lvim"
alias vs="lvim -S"

# Prevent stupidity
# https://hasseg.org/trash/ (brew install trash)
command -v brew &> /dev/null && alias rm="trash"

command -v bat &> /dev/null && alias cat="bat"

# Max line length when searching
alias rgn="rg --no-ignore"

# Tmux Count Panes
alias tmuxcount="tmux list-windows -a \
    | egrep -v DUP \
    | perl -pe 's/.*(\\d) panes.*/\\1/' \
    | perl -lne '\$x += \$_; END { print \$x; }'"

# Configure Less
function less() {
    `which -a less | grep '^/' | head -1` -NSI $@
}

function l() {
    ls -lah "$@"
}

alias ..="c .."

function c {
    cd "$@" && echo "" && ls -la
}

function cr() {
    # TODO use lf instead of ranger
    ranger --choosedir=$HOME/.rangerdir $@
    local LASTDIR=`cat $HOME/.rangerdir`
    c "$LASTDIR"
}

function mkc() {
    mkdir "$@" && c "$@"
}

# Tmux Count Panes
alias tmuxcount="ps aux | grep '\-zsh' | wc -l"

alias brewupgrade="echo 'Calling: brew upgrade' && \
    brew upgrade && \
    echo 'Calling: brew cleanup' && \
    brew cleanup"

alias iex='iex --erl "-kernel shell_history enabled"'

alias so="source ~/.zshrc"

alias tmutil-clear="tmutil thinlocalsnapshots / 898989898989898989 3"

command -v bottom &> /dev/null && alias btm="bottom"

function fp() {
    local full_path="`pwd`/$1";
    echo -n "$full_path" | pbcopy
    echo "Copied to clipboard: $full_path"
}

function w() {
    # Runs the given command when files change in the current directory
    local command=$@
    # Run in a subprocess because entr changes the cwd and opening a new terminal would end up in ~
    zsh -c "rg --files | entr -s 'clear && printf \"\\n\\n\\n.......... File change detected ..........\\n\\n\\n\\n\" && ($command)'"
}

function wnr() {
    w npm run $*
}

function loop() {
    while true; do
        $@
    done
}

function notifydone() {
    local message="${1:-'Your script has completed!'}"
    osascript -e "display notification \"$message\""
    say "$message"
}

function spotdl-playlist() {
    mkdir spotdl-playlist && \
        cd spotdl-playlist && \
        spotdl $1 #&& \
        #spotdl --output-ext m4a --list downloaded-* --search-format '{artist} - {track-name}'
}

# use `spotdl -s 'artist - title'` instead preferable
function youtube-dl-song() {
    youtube-dl --extract-audio --add-metadata --audio-format m4a --embed-thumbnail --ignore-errors $@
}

function youtube-dl-audio-quick() {
    youtube-dl --extract-audio --add-metadata --no-playlist --ignore-errors --audio-format m4a $@
}

function dl-upgrade() {
    pip3 install --upgrade pip spotdl youtube-dl pytube
}

function elixir-recompile() {
    mix deps.clean $1 && mix deps.get && mix deps.compile $1
}

function whatismyip() {
    local ip=`curl ipinfo.io/ip --silent`
    echo "IP is $ip. Copying to clipboard"
    echo "$ip" | pbcopy
}

function calc {
    /usr/bin/env nvim ~/calculator.js +Codi
}

function ns {
    cat package.json | jq --sort-keys .scripts
}

function diff-matches {
  local pattern="$1" # e.g. 'configModelMock[^;\n]*\n[^;]+;'
  local match_path="${2:-./}"

  local results_dir=`mktemp -d`

  local counter=-1

  rg "$pattern" "$match_path" --multiline --json \
    | jq 'select(.type == "match")' -c \
    > "$results_dir/base.json"

  local command='
  require "json"
  dir = "'"$results_dir"'"
  i = 0

  File.foreach("#{dir}/base.json") do |line|
    map = JSON.parse(line)
    line_number = map["data"]["line_number"]
    text = map["data"]["lines"]["text"]

    File.write("#{dir}/match-#{"%03d" % i}", "[Line #{line_number}]: #{text}")
    i += 1
  end
  '
  ruby -e "$command"

  nvim -d -o `find -s "$results_dir" -name "match-*"`
}

function diff-matches-statement {
  local pattern="$1"'[^;\n]*\n[^;]+;'
  local match_path="${2:-./}"
  diff-matches "$1" "$2"
}

function open-browser {
  python3 -m 'webbrowser' -t "$@"
}

# }}}



# Useful git commands

# {{{
alias gs="git status"

alias gpl="git pull"
alias gph="git push"

current_branch() {
    git branch | awk '/^\* / { print $2 }'
}
copy_current_branch() {
    current_branch | pbcopy
}

gphu() {
    git push -u origin $(current_branch)
}
gphd() {
    git push -d origin $(current_branch)
}

alias gplph="git pull && git push"
alias gplrph="git pull -r && git push"
alias gploh="git pull origin HEAD"
alias gpluh="git pull upstream HEAD"

alias gfa="git fetch --all --prune --tags"
alias gfo="git fetch origin --prune --tags"
alias gfu="git fetch upstream --prune --tags"
alias grmt="git remote"
alias grmtv="git remote -v"

alias gco='git checkout'
alias gcof='git checkout `fbr`'
alias gcoh="git fetch origin && git checkout origin/HEAD"
alias gcuh="git fetch upstream && git checkout upstream/HEAD"
alias gcob='git checkout -b'
alias gcop='git checkout -p'

git_create_upstream_head() {
    if [ ! -f .git/refs/remotes/origin/HEAD ]; then
        echo '.git/refs/remotes/origin/HEAD not found. Run `git_infer_remote_from_origin OriginUser` first'
        return
    fi

    cat .git/refs/remotes/origin/HEAD | sed -e 's/remotes\/origin/remotes\/upstream/' > .git/refs/remotes/upstream/HEAD
}

git_infer_remote_from_origin() {
    local new_remote_repo_owner="$1"
    local new_remote_name="${2=upstream}"

    local origin_url=`git remote get-url origin`
    local new_remote_url=`echo $origin_url | perl -pe 's|\:[\w-]+/|\:'"$new_remote_repo_owner"'/|'`

    if [ -z "$new_remote_repo_owner" ]; then
      echo 'Need to pass first argument `new_remote_repo_owner`'
      return
    fi

    echo ">" git remote add "$new_remote_name" "$new_remote_url"
    git remote add "$new_remote_name" "$new_remote_url"
    echo

    echo ">" git remote -vv
    git remote -vv
    echo

    echo ">" git fetch --all
    git fetch --all
}

git_prune_branches() {
    git branch -v | grep gone | perl -pwe 's/^  ([^\s]+).*/$1/g' | xargs git branch -d
}

git_prune_branches__force__i_understand_that_this_will_delete_all_my_local_branches_without_remotes() {
    git branch -v | grep gone | perl -pwe 's/^  ([^\s]+).*/$1/g' | xargs git branch -D
}

alias gcm="git commit -v"
alias ga="git add"
alias gaa="git add -A"
alias gap="git add -p"

alias grth="git reset --hard"

alias gdf="git diff"
alias gdfc="git diff --cached"

alias glg="git log --graph --decorate --topo-order"
alias glgo="glg --format='%C(auto)%h%d %s %C(white)%C(bold)%cr'"
alias glga="glgo --all"
alias glgad="glga --date-order"

alias gsh="git stash"

# List untracked files
alias glsu="git ls-files --others --exclude-standard"

alias grb="git rebase"
alias grboh="git rebase origin/HEAD"
alias grbuh="git rebase upstream/HEAD"
alias grba="git rebase --abort"
alias grbs="git rebase --skip"
alias grbc="git rebase --continue"

alias gbr="git branch"
alias gbra="git branch -avv"

alias gcpc='git rev-parse HEAD | pbcopy; git show | head; echo; echo Copied `pbpaste` to clipboard'

function gpr() {
    # Goes to the URL for creating a new pull request in the browser. For
    # GitHub, the branch is selected automatically, and if the pull request
    # already exists for that branch, GitHub will redirect to the existing pull
    # request. For Bitbucket, the new pull request page is opened.
    local base=`git_remote_website`

    if [[ "$base" == 'https://bitbucket.org'* ]]; then
        local url="$base/pull-requests/new"
    elif [[ "$base" == 'https://github.com/'* ]]; then
        local url="$base/pull/`current_branch`"
    elif [[ "$base" == 'https://gitlab.com/'* ]]; then
        local url="$base/-/merge_requests/new?merge_request%5Bsource_branch%5D=`current_branch | perl -pe 's/\s*$//' | jq -sRr '@uri'`"
    else
        echo "Unknown domain for url: $base"
        return
    fi

    echo Opening url and copying to clipboard "$url"
    open-browser "$url"

    if command -v pbcopy &> /dev/null &> /dev/null; then
        echo "$url" | pbcopy
    elif command -v clip &> /dev/null.exe &> /dev/null; then
        echo "$url" | clip.exe
    else
        echo "Unknown copy tool"
    fi
}

function git_remote_website() {
    git remote get-url origin \
        | perl -pe 's/\.git$//' \
        | perl -pe 's/git\@([^:]+):/https:\/\/\1\//'
}

# Stdin as input
function simplify_package_lock() {
    jq '(if .dependencies then .dependencies else .packages end) | to_entries[] | [.key, .value.version]' -c \
        | perl -pe 's/node_modules\///' \
        | grep -v 'node_modules' \
        | grep -v '""' \
        | sort
}

function diff_package_lock_with_master() {
    git fetch upstream
    git show upstream/master:./package-lock.json | simplify_package_lock > lock-master.jsonl
    cat package-lock.json | simplify_package_lock > lock-new.jsonl
    git diff --no-index lock-master.jsonl lock-new.jsonl
}

# }}}



# Other stuff

# {{{

# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Preferred editor for local and remote sessions
export EDITOR='lvim'

# Share bash history between all shells
setopt share_history

# Long history size (https://unix.stackexchange.com/questions/273861/unlimited-history-in-zsh)
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# ZSH
# WTF Zsh, can't type comments
setopt INTERACTIVE_COMMENTS

# Vi mode
bindkey -v
export KEYTIMEOUT=1
bindkey -M vicmd "^V" edit-command-line
bindkey -M viins "^V" edit-command-line
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
# Can backspace past where insert mode started
bindkey "^?" backward-delete-char # ZSHZLE

# Up/down arrows to browse shell history
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# }}}
