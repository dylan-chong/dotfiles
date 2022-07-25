# ZPlug (brew install zplug)

# {{{

# From Homebrew output
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

alias zp='zplug'
alias zpi='zplug install'
alias zpu='zplug update'

alias zpr='soz; zpr__impl'
# Is a function to allow for soz to refresh the latest version
function zpr__impl() {
    zplug install
    zplug update
    zplug clean
    zplug load
}

zplug chriskempson/base16-shell, from:github
zplug spaceship-prompt/spaceship-prompt, from:github

zplug load

# }}}



# Zplug plugin config

# {{{

# chriskempson/base16-shell
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_materia

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
  exec_time     # Execution time
  line_sep      # Line break
  # battery       # Battery level and status
  # vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT='%D{%H:%M:%S.%.}'
SPACESHIP_GIT_STATUS_SHOW=false
# SPACESHIP_DIR_TRUNC doesn't work if SPACESHIP_DIR_TRUNC_REPO is true
SPACESHIP_DIR_TRUNC=3
SPACESHIP_DIR_TRUNC_REPO=false

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

alias l="ls -lah"
alias ..="c .."

function c {
    cd "$@" && echo "" && l
    #cd "$@" && echo -e $(pwd) && echo "" && ls -G
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

alias soz="source ~/.zshrc"

alias aenser="python2 ~/Dropbox/Programming/GitHub/aenea-setup/aenea/server/osx/server_osx.py"

alias tmutil-clear="tmutil thinlocalsnapshots / 898989898989898989 3"

source ~/bin/phone-sync-source.bash

function fp() {
    local path=`pwd`/$1;
    echo "Copied to clipboard: $path"
    echo $path | tr -d '\n' | pbcopy
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
alias gcob='git checkout -b'
alias gcop='git checkout -p'

git_prune_branches() {
    git branch -v | grep gone | perl -pwe 's/^  ([^\s]+).*/$1/g' | xargs git branch -d
}

alias gcm="git commit -v"
alias ga="git add"
alias gap="git add -p"
alias gaa="git add -A"
alias gan="git add -N ."
alias gai="git add -i"
alias gae="git add -e"

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

alias gbr="git branch"

function gpr() {
    # Goes to the URL for creating a new pull request in the browser. For
    # GitHub, the branch is selected automatically, and if the pull request
    # already exists for that branch, GitHub will redirect to the existing pull
    # request. For Bitbucket, the new pull request page is opened.
    local base=`git remote get-url origin | perl -pe 's/\.git$//' | perl -pe 's/git\@([^:]+):/https:\/\/\1\//'`
    if [[ $base == 'https://bitbucket.org'* ]]; then
        local url="$base/pull-requests/new"
    else
        local url="$base/pull/`current_branch`"
    fi
    case $1 in
        --safari|-s)
            open -a 'Safari' $url
            ;;
        --chrome|-g|-c)
            open -a 'Google Chrome' $url
            ;;
        *)
            open $url
    esac
}

function commit_message_to_branch() {
    perl -pe 's/(:|\/)//g' | perl -pe 's/^(SOLV-\d+(?=:)?|[^:]+(?=:)):?\s*(.*\S)\s*$/\1\/\l\2/' | perl -pe 's/[^\w\/]+/-/g' | tr '[:upper:]' '[:lower:]' | perl -pe 's/^solv/SOLV/'
}

# Quick commit, new branch, and push
function gcmq() {
    echo '> git status'
    git status
    echo

    read -p "Are you checked on the right branch *and* does this show the right staged files [y/n]? " CONT
    echo
    if [ "$CONT" = "y" ]; then
        if [ -z "$1" ]; then
            # Take commit message from clipboard so you can copy the jira ticket number and description straight after it
            local message=`pbpaste | tr '\n' ' ' | perl -pe 's/\s+/ /g'`
            local branch=`echo "$message" | commit_message_to_branch`
        else
            # Check if argument is branch name or commit message by if it has
            # no spaces and a / or _ or - in it
            if [[ "$@" =~ ^[A-Za-z0-9_-]+[/_-][A-Za-z0-9/_-]+$ ]]; then
                # Argument was branch name
                local branch="$1"

                # If contains a slash
                if [[ "$1" =~ / ]]; then
                    local prefix=`echo $branch | perl -pe 's/\/.*//'`
                    # Uppercase first letter of prefix
                    local prefix_formatted=`echo "$prefix" | perl -pe 's/^(\w)/\U$1/'`
                    local separator=': '
                    local suffix=${branch#"$prefix"/}
                    echo "prefix: $prefix"
                    echo "suffix: $suffix"
                else
                    local prefix_formatted=''
                    local separator=''
                    local suffix="$branch"
                fi

                # Pass branch suffix as argument and convert to commit messagee
                # 1. Replace all - and _ with spaces
                # 2. Replace 2+ spaces with ' - ' so you can use '--' in the branch name represent an actual dash
                # 3. Uppercase the first letter
                local suffix_formatted=`echo "$suffix" | perl -pe 's/_|-/ /g' | perl -pe 's/\s\s+/ - /g' | perl -pe 's/^(\w)/\U$1/'`

                local message="$prefix_formatted$separator$suffix_formatted"
            else
                # Argument was commit message
                local message=`echo "$@" | perl -pe 's/^\s*//' | perl -pe 's/\s*$//'`
                local branch=`echo "$message" | commit_message_to_branch`
            fi
        fi

        echo "New Branch: $branch"
        echo "Commit message: $message"
        echo

        read -p "Are these correct [y/n]? " CONT
        echo
        if [ "$CONT" = "y" ]; then
            git checkout -b "$branch" \
                && git commit -m "$message" \
                && gphu \
                && gpr -g
        else
            echo "Cancelling";
        fi
    else
        echo "Cancelling";
    fi
}

# }}}



# Homes/Paths

# {{{
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.0.0/bin:$PATH"

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

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

# TODO fix
# Prevent accidental logging out
export IGNOREEOF=1

# TODO FIX this
# Share bash history between all shells
# https://unix.stackexchange.com/a/1292
# Avoid duplicates
# export HISTCONTROL=ignoreboth:erasedups
# When the shell exits, append to the history file instead of overwriting it
# shopt -s histappend
# After each command, append to the history file and reread it
# export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'} history -a; history -c; history -r;" # Doesnt work for some reason.
# export PROMPT_COMMAND="history -a; history -c; history -r;"

# Unlimited bash history
HISTSIZE=9999999
HISTFILESIZE=99999999

# Load private stuff
source ~/.zshrc_private

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}
