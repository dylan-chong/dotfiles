# Various Unix Settings

All my settings, plugins, and colour schemes that I have found on the Internet
can be found here. Take what you want! Hopefully you can find something useful
in there somewhere.

## Installation

### Homebrew

1. Install [homebrew](https://brew.sh)
1. Run the printed out command to load brew in the current shell (`eval ...` or
   something)
1. Install packages
    ```bash
    brew install google-chrome alfred slack rectangle maccy spotify discord
    brew install git antigen asdf neovim ranger fzf trash tmux diff-so-fancy reattach-to-user-namespace bat ripgrep
    ```
1. Close terminal and open app `Kitty`

### Cloning this repo

1. Clone and configure git
    ```bash
    cd ~
    git clone https://github.com/dylan-chong/dotfiles
    git config core.worktree ~
    git config status.showUntrackedFiles no
    ```
1. Move the contents of `dotfiles` into `~` (except `.git`)

### ASDF

1. Install asdf
    ```bash
    cd ~
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install
    ```

### Neovim

1. Create shortcut for nvim directory
    ```bash
    ln -s ~/.vim ~/.config/nvim
    ```
1. Open `vi`, run `:PlugInstall` and close vim

### tmux

1. Open `tmux` and press `CTRL-s I` to install plugins

### Terminal theme

1. Set terminal theme `base16_material-palenight`
1. Install [fira code](https://github.com/tonsky/FiraCode/wiki/Installing)
1. Restart your terminal
