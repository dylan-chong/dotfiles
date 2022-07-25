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

# zplug 'dracula/zsh', as:theme
# zplug carloscuesta/materialshell, from:github, as:theme
zplug chriskempson/base16-shell, from:github

zplug load

# chriskempson/base16-shell (must be after zplug load)
base16_materia

# }}}



# Oh My Zsh

# {{{

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# TODO material
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

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
