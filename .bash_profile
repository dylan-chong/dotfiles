# Uni

# {{{
function gitinspect() {
    gitinspector \
        --grading \
        --format=htmlembedded \
        --file-types=** \
        --exclude="package-lock.json|yarn.lock" $@ > .inspection.html \
        && open .inspection.html \
        && sleep 2 \
        && rm .inspection.html
}
# }}}



# Base 16 256 colours

# {{{
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# }}}



# Useful Paths

# {{{

alias godesk="cl ~/Desktop"
alias gocrap="cl ~/Desktop/crap"
alias godown="cl ~/Downloads"
alias godrop="cl ~/Dropbox"

alias gogit="cl ~/Dropbox/Programming/GitHub"
alias godev="cl ~/Development/"

alias goscripts="cl ~/Dropbox/Programming/GitHub/itunes-applescripts"
alias gonodev="cl ~/Dropbox/Programming/GitHub/itunes-applescripts-no-dev"
alias gotower="cl ~/Dropbox/Programming/GitHub/towers-of-hanoi"
alias goaen="cl ~/Dropbox/Programming/GitHub/aenea-setup"

alias gobash="cl ~/bash-settings"

alias goschool="cl ~/Dropbox/School"
alias gogroup="cl /Users/Dylan/Dropbox/Programming/GitHub/swen222-group-project"

alias gopat="cl /Users/Dylan/Dropbox/Programming/design-patterns"

alias gopart="cl /Users/Dylan/Dropbox/Sibelius\ Scores/Compositions/2016/partimenti"
# }}}



# Useful commands

# {{{
alias prof="nvim ~/.bash_profile"
alias virc="nvim ~/.vimrc"

alias l="ls -lah"
function c {
    cd "$@" && echo "" && l
    #cd "$@" && echo -e $(pwd) && echo "" && ls -G
}
function cl { # For backwards compatibility
    c "$@"
}
alias ..="c .."

mkc() {
    mkdir "$@" && cl "$@"
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
alias tmuxcount="ps aux | grep '\-bash' | wc -l"

alias brewupgrade="echo 'Calling: brew upgrade' && \
    brew upgrade && \
    echo 'Calling: brew cleanup' && \
    brew cleanup"

# alias iex='rlwrap -a foo iex'
alias iex='iex --erl "-kernel shell_history enabled"'
alias kotlinc='rlwrap -a foo kotlinc'
alias swipl='rlwrap -a foo swipl'

alias soba="source ~/.bash_profile"

alias aenser="python2 ~/Dropbox/Programming/GitHub/aenea-setup/aenea/server/osx/server_osx.py"

alias tmutil-clear="tmutil thinlocalsnapshots / 898989898989898989 3"

source ~/bin/phone-sync-source.bash

function fp() {
    local path=`pwd`/$1;
    echo "Copied to clipboard: $path"
    echo $path | tr -d '\n' | pbcopy
}

function cr() {
    ranger --choosedir=$HOME/.rangerdir $@
    local LASTDIR=`cat $HOME/.rangerdir`
    c "$LASTDIR"
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
    osascript -e 'display notification "Done!"'
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
    curl -s 'https://whatsmyip.com' | grep 'Your public IP' | rg '(?:(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(?:25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)' --only-matching | head -n 1
}

# From https://www.stefaanlippens.net/pretty-csv.html
# Note: Probably won't work if "," or newline inside a cell
function pretty_csv {
    perl -pe 's/((?<=,)|(?<=^)),/ ,/g;' "$@" | column -t -s,
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
    perl -pe 's/(:|\/)//g' | perl -pe 's/^(SOLV-\d+(?=:)?|[^:]+(?=:)):?\s*(.*\S)\s*$/\1\/\l\2/' | perl -pe 's/[\s:\-\."'\'']+/-/g' | tr '[:upper:]' '[:lower:]' | perl -pe 's/^solv/SOLV/'
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
            # Check if argument is branch name or commit message
            if [[ "$1" =~ ^[a-zA-Z]+\/[a-zA-Z]+.* ]]; then
                # Argument was branch name
                # Pass branch as argument and convert to commit messagee
                # 1. Replace branch folder with `:`
                # 2. Replace - or _ with space
                # 3. Uppercase the first letter, and first letter after the `:`
                local branch="$1"
                local message=`echo "$branch" | perl -pe 's/\//: /' | perl -pe 's/_|-/ /g' | perl -pe 's/(\w)(\w*:\s)(\w)(.*)/\U$1\L$2\U$3\L$4/'`
            else
                # Argument was commit message
                local message="$@"
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
export PKG_CONFIG_PATH='/usr/local/Cellar/imagemagick@6/6.9.8-10/lib/pkgconfig/'

export EASYDOC_DIR=~/Dropbox/Programming/GitHub/easydoc


export GOPATH="$HOME/go"
export PATH=$GOPATH/bin:$PATH:/usr/local/opt/go/libexec/bin

export PATH=/usr/local/anaconda3/bin:"$PATH"

export PATH_TO_FX=/Users/Dylan/Downloads/javafx-sdk-11.0.2/

# Homebrew
export PATH="/usr/local/sbin:$PATH"

# ASDF
. $(brew --prefix asdf)/asdf.sh
export KERL_BUILD_DOCS=yes

# PHP

export PATH="$PATH:/Users/Dylan/.composer/vendor/bin/"

# Gcloud
source /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc


# Brew PHP
export PATH="/usr/local/opt/php@7.2/bin:$PATH"
export PATH="/usr/local/opt/php@7.2/sbin:$PATH"

# }}}

# Terminal Coloured text from:

# http://apple.stackexchange.com/questions/125637/iterm-colors-for-prompt-command-and-output
# {{{

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# base16-materia
export PS1="\n\[\033[01;32m\]\u@\h:\[\033[01;31m\]\$(parse_git_branch)\
\[\033[01;34m\]\w \[\033[34m\]\n>\[\e[0m\] "

# gruvbox
# export PS1="\n\[\033[1;32m\]\u@\h:\[\033[31m\]\$(parse_git_branch)\
# \[\033[1;34m\]\w \[\033[01;34m\]\n>\[\e[0m\] "

# vim-apprentice-theme-like
# export PS1="\n\[\033[32m\]\u@\h:\[\033[01;35m\]\$(parse_git_branch)\
# \[\033[01;31m\]\w \[\033[01;34m\]\n>\[\e[0m\] "

# Original from stack overflow,
# export PS1="\n\[\033[01;31m\]\u@\h:\[\033[01;34m\]\$(parse_git_branch) \[\033[01;32m\]\w \[\033[01;34m\]\n>\[\e[0m\] "

# }}}



# Coloured ls commands

# {{{
# Set CLICOLOR if you want Ansi Colors in iTerm2
export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile
# }}}



# Other stuff

# {{{

# Disable Safari DNS Prefetchin
alias enable-prefetch="defaults write com.apple.safari WebKitDNSPrefetchingEnabled -boolean true"
alias disable-prefetch="defaults write com.apple.safari WebKitDNSPrefetchingEnabled -boolean false"
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/latest/bin

# Setting PATH for Python 2.7
# The orginal version is saved in .bash_profile.pysave
export PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH="/Users/Dylan/Library/Python/3.9/bin:${PATH}"

# Vim
alias vi="nvim"

# Prevent stupidity
alias rm="rmtrash"

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
    `which less` -NSI $@
}

# v to open nvim in less
export VISUAL=nvim

# Prevent accidental logging out
export IGNOREEOF=1

# Share bash history between all shells
# https://unix.stackexchange.com/a/1292
# Avoid duplicates
export HISTCONTROL=ignoreboth:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# After each command, append to the history file and reread it
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r;"

# Unlimited bash history
HISTSIZE=9999999
HISTFILESIZE=99999999

# Load private stuff
source ~/.bash_profile_private

# Load bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# brew bash-completion (disabled for now because it slows shell startyp)
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# }}}
