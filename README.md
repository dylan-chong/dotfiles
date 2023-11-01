# Various Unix Settings

All my settings, plugins, and colour schemes that I have found on the Internet
can be found here. Take what you want! Hopefully you can find something useful
in there somewhere.

## Installation

1. Clone and configure git
    ```bash
    cd ~
    git clone https://github.com/dylan-chong/dotfiles
    git config core.worktree ~
    git config status.showUntrackedFiles no
    ```
2. Move the contents of `dotfiles` into `~` (except `.git`)
3. Then run:
    ```bash
    ln -s ~/.vim ~/.config/nvim # Create shortcut for nvim directory
    ```
4. Install [homebrew](https://brew.sh)
5. Install packages
    ```bash
    brew install google-chrome alfred slack rectangle maccy spotify discord
    brew install git antigen asdf neovim ranger fzf trash tmux diff-so-fancy reattach-to-user-namespace
    ```
toolversions
