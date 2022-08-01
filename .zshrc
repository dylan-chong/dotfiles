# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"



# Antigen

# {{{

ANTIGEN_LOG=~/.antigen/debug.log
source "$(brew --prefix antigen)/share/antigen/antigen.zsh"

antigen use oh-my-zsh

antigen bundle https://github.com/robbyrussell/oh-my-zsh.git plugins/vi-mode

# Themes
# base16-shell doesn't follow the zsh plug format so can't be used with `theme` (I think)
antigen bundle chriskempson/base16-shell
antigen bundle spaceship-prompt/spaceship-prompt
antigen bundle zsh-users/zsh-syntax-highlighting

# History/autocomplete
antigen bundle zsh-users/zsh-history-substring-search
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle marlonrichert/zsh-autocomplete@main

# Random utils
antigen bundle MichaelAquilina/zsh-you-should-use
antigen bundle "/Users/Dylan/Dropbox/Programming/GitHub/gprq/" --no-local-clone

antigen apply

# }}}



# Zplug config

# {{{

# chriskempson/base16-shell
# Run this in the shell manually and that will set the global theme in ~/.base16_theme
# base16_material-palenight

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

# zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS= # Remove "i" to history case sensitive

# }}}



# Useful Paths

# {{{

alias godesk="c ~/Desktop"
alias gocrap="c ~/Desktop/crap"
alias godown="c ~/Downloads"
alias godrop="c ~/Dropbox"

alias gogit="c ~/Dropbox/Programming/GitHub"
alias godev="c ~/Development/"

alias goscripts="c ~/Dropbox/Programming/GitHub/itunes-applescripts"
alias gonodev="c ~/Dropbox/Programming/GitHub/itunes-applescripts-no-dev"
alias gotower="c ~/Dropbox/Programming/GitHub/towers-of-hanoi"
alias goaen="c ~/Dropbox/Programming/GitHub/aenea-setup"

# }}}



# Useful commands

# {{{

function l() {
    ls -lah "$@"
}

alias ..="c .."

function c {
    cd "$@" && echo "" && l
}

function cr() {
    ranger --choosedir=$HOME/.rangerdir $@
    local LASTDIR=`cat $HOME/.rangerdir`
    c "$LASTDIR"
}

mkc() {
    mkdir "$@" && c "$@"
}

wcme() {
    if [ -z "$2" ]; then
        NAME=`git config user.name`
    else
        NAME=$2
    fi

    git blame "$1" \
        | egrep "\($NAME" \
        | egrep -v '<!--' \
        | perl -pe 's/.*\d+\)(.*)/\1/' \
        | wc -w
}

# Tmux Count Panes
alias tmuxcount="ps aux | grep '\-zsh' | wc -l"

alias brewupgrade="echo 'Calling: brew upgrade' && \
    brew upgrade && \
    echo 'Calling: brew cleanup' && \
    brew cleanup"

# alias iex='rlwrap -a foo iex'
alias iex='iex --erl "-kernel shell_history enabled"'
alias kotlinc='rlwrap -a foo kotlinc'
alias swipl='rlwrap -a foo swipl'

alias so="source ~/.zshrc"

alias aenser="python2 ~/Dropbox/Programming/GitHub/aenea-setup/aenea/server/osx/server_osx.py"

alias tmutil-clear="tmutil thinlocalsnapshots / 898989898989898989 3"

source ~/bin/phone-sync-source.bash

function fp() {
    local full_path="`pwd`/$1";
    echo -n "$full_path" | pbcopy
    echo "Copied to clipboard: $full_path"
}

function dowatch() {
    # Runs the given command when files change in the current directory
    local command=$@
    # Run in a subprocess because entr changes the cwd and opening a new terminal would end up in ~
    bash -c "rg --files | entr -s 'printf \"\\n\\n\\n.......... File change detected ..........\\n\\n\\n\\n\" && ($command)'"
}

function loop() {
    while true; do
        $@
    done
}

function notifydone() {
    local message='Your script has completed!'
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
    youtube-dl --extract-audio --add-metadata --no-playlist --ignore-errors $@
}

function dl-upgrade() {
    pip3 install --upgrade pip spotdl youtube-dl pytube
}

function elixir_recompile() {
    mix deps.clean $1 && mix deps.get && mix deps.compile $1
}

function whatismyip() {
    ip=`curl ipinfo.io/ip --silent`
    echo "IP is $ip. Copying to clipboard"
    echo "$ip" | pbcopy
}

# From https://www.stefaanlippens.net/pretty-csv.html
# Note: Probably won't work if "," or newline inside a cell
function pretty_csv {
    perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' "$@" | column -t -s,
}

function calculator {
    vi ~/Desktop/calculator.js +Codi
}

# }}}



# Useful git commands

# {{{
alias gs="git status"
alias gst="git status"

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
alias gplh="git pull origin HEAD"

alias gfa="git fetch --all --prune --tags"
alias grmt="git remote"
alias grmtv="git remote -v"

alias gco='git checkout'
alias gcof='git checkout `fbr`'
alias gcoh="gfa && git checkout origin/HEAD"
alias gcuh="gfa && git checkout upstream/HEAD"
alias gcob='git checkout -b'
alias gcop='git checkout -p'

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
alias grbh="git rebase origin/HEAD -i"
alias grba="git rebase --abort"
alias grbs="git rebase --skip"
alias grbc="git rebase --continue"

alias gbr="git branch"

function gpr() {
    # Goes to the URL for creating a new pull request in the browser. For
    # GitHub, the branch is selected automatically, and if the pull request
    # already exists for that branch, GitHub will redirect to the existing pull
    # request. For Bitbucket, the new pull request page is opened.
    local base=`git_remote_website`

    if [[ "$base" == 'https://bitbucket.org'* ]]; then
        local url="$base/pull-requests/new"
    elif [[ "$base" == 'https://github.com/'* ]]; then
        # Github
        local url="$base/pull/`current_branch`"
    else
        echo "Unknown domain for url: $base"
        return
    fi

    open_url_in_browser "$url" $1
    python3 -m 'webbrowser' -t "$url"
}

function git_remote_website() {
    git remote get-url origin \
        | perl -pe 's/\.git$//' \
        | perl -pe 's/git\@([^:]+):/https:\/\/\1\//'
}

# }}}



# Homes/Paths

# {{{

# ASDF
. $(brew --prefix asdf)/asdf.sh

# PHP
export PATH="$PATH:/Users/Dylan/.composer/vendor/bin/"

# Python
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH="/Users/Dylan/Library/Python/3.9/bin:${PATH}"

# }}}



# Other stuff

# {{{

# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Vim
alias vi="nvim"

# ZSHZLE
# Can backspace past where insert mode started
bindkey "^?" backward-delete-char

# Prevent stupidity
# https://hasseg.org/trash/ (brew install trash)
alias rm="trash"

# Max line length when searching
alias ag="ag -W 200"
alias rag="rg -M 200 --smart-case"

# Tmux Count Panes
alias tmuxcount="tmux list-windows -a \
    | egrep -v DUP \
    | perl -pe 's/.*(\\d) panes.*/\\1/' \
    | perl -lne '\$x += \$_; END { print \$x; }'"

# Configure Less
function less() {
    `which -a less | grep '^/'` -NSI $@
}

# v to open nvim in less
export VISUAL=nvim

# TODO fix - broken by the autocomplete plugin
# Prevent accidental logging out https://superuser.com/a/1509672
# setopt ignore_eof
# IGNOREEOF=1
# # Emulate Bash $IGNOREEOF behavior
# function bash-ctrl-d() {
    # echo "CURSOR: $CURSOR"
    # echo "BUFFER: $BUFFER"
    # echo "IGNOREEOF: $IGNOREEOF"
    # echo "__BASH_IGNORE_EOF: $__BASH_IGNORE_EOF"
    # if [[ $CURSOR == 0 && -z $BUFFER ]]
    # then
        # [[ -z $IGNOREEOF || $IGNOREEOF == 0 ]] && exit
        # if [[ "$LASTWIDGET" == "bash-ctrl-d" ]]
        # then
            # (( --__BASH_IGNORE_EOF <= 0 )) && exit
        # else
            # (( __BASH_IGNORE_EOF = IGNOREEOF ))
        # fi
    # fi
# }
# zle -N bash-ctrl-d
# bindkey '^D' bash-ctrl-d

# Share bash history between all shells
setopt share_history

# Load private stuff
source ~/.zshrc_private

# FZF bindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# ZSH
# WTF Zsh, can't type comments
setopt INTERACTIVE_COMMENTS

# Vi mode
bindkey -v
export KEYTIMEOUT=1


# }}}
