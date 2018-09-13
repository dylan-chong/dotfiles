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
alias stree="open -a SourceTree ./"

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

alias iex='rlwrap -a foo iex'
alias kotlinc='rlwrap -a foo kotlinc'

alias soba="source ~/.bash_profile"

alias aenser="python2 ~/Dropbox/Programming/GitHub/aenea-setup/aenea/server/osx/server_osx.py"

alias tmutil-clear="tmutil thinlocalsnapshots / 898989898989898989 3"

function fp() {
    P=`pwd`/$1;
    echo "Copied to clipboard: $P"
    echo $P | tr -d '\n' | pbcopy
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
gphu() {
    git push -u origin $(current_branch)
}
gphd() {
    git push -d origin $(current_branch)
}

alias gplph="git pull --rebase && git push"
alias gfa="git fetch --all --prune --tags"
alias grmt="git remote"
alias grmtv="git remote -v"

alias gbr="git branch"
alias gbrv="git branch -avv"

alias gchd="git checkout -"

git_prune_branches() {
    git branch -v | grep gone | perl -pwe 's/^  ([^\s]+).*/$1/g' | xargs git branch -d
}

alias gcm="git commit -v"
alias gap="git add -p"
alias gaa="git add -A"
# "Git add (without) whitespace"
alias gaw="git diff -w --no-color | git apply --cached --ignore-whitespace"

alias grth="git reset --hard"

alias gdf="git diff"
alias gdfc="git diff --cached"

alias glg="git log --graph --decorate --topo-order"
alias glgo="glg --format='%C(auto)%h%d %s %C(black)%C(bold)%cr'"
alias glga="glgo --all"
alias glgad="glga --date-order"

alias gsh="git stash"

function gpr() {
    local base=`git remote get-url origin | perl -pe 's/\.git$//'`
    local url="$base/pull/`current_branch`"
    case $1 in
        s)
            open -a 'Safari' $url
            ;;
        g)
            open -a 'Google Chrome' $url
            ;;
        *)
            echo $url | pbcopy
            echo "Copied to clipboard: $url"
    esac
}

# }}}



# Homes/Paths

# {{{
export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
export PATH=$JAVA_HOME/bin:$PATH

export ANDROID_HOME=/Users/Dylan/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

export PKG_CONFIG_PATH='/usr/local/Cellar/imagemagick@6/6.9.8-10/lib/pkgconfig/'

export EASYDOC_DIR=~/Dropbox/Programming/GitHub/easydoc

# These were added as part of instructions for `brew install node@8`
export PATH="/usr/local/opt/node@8/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/node@8/lib"
export CPPFLAGS="-I/usr/local/opt/node@8/include"

export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export GOPATH="$HOME/go"
export PATH=$GOPATH/bin:$PATH:/usr/local/opt/go/libexec/bin

export PATH=/usr/local/anaconda3/bin:"$PATH"

# }}}



# Terminal Coloured text from:

# http://apple.stackexchange.com/questions/125637/iterm-colors-for-prompt-command-and-output
# {{{

# Don't know what this thing is
# s[[ -s "/Users/dwightk/.rvm/scripts/rvm" ]] && source "/Users/dwightk/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

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
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
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

# Git Completion
source ~/.git-completion.bash
source ~/.git-flow-completion.bash

# iTerm 2 Shell Integration
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# Vim
alias vi="nvim"

# Prevent stupidity
alias rm="rmtrash"

# Max line length when searching
alias ag="ag -W 100"
alias rg="rg -M 100 --smart-case"

# Tmux Count Panes
alias tmuxcount="tmux list-windows -a \
    | egrep -v DUP \
    | perl -pe 's/.*(\\d) panes.*/\\1/' \
    | perl -lne '\$x += \$_; END { print \$x; }'"

# v to open nvim in less
export VISUAL=nvim

# Prevent accidental logging out
export IGNOREEOF=1

# Load private stuff
source ~/.bash_profile_private

# Load bashrc
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi


# Load z (https://github.com/rupa/z)
. /usr/local/etc/profile.d/z.sh

# }}}

