# Various Unix Settings

All my settings, plugins, and colour schemes that I have found on the Internet
can be found here. Take what you want! Hopefully you can find something useful
in there somewhere.

## Installation

### If using Homebrew

1. Install [homebrew](https://brew.sh)
1. Run the printed out command to load brew in the current shell (`eval ...` or
   something)
1. Install packages
    ```bash
    # Main packages
    brew install git antigen asdf neovim ranger fzf tmux diff-so-fancy bat ripgrep entr
    # UI
    brew install google-chrome alfred slack rectangle maccy spotify discord
    # Mac-specific
    brew install reattach-to-user-namespace trash fd
    ```
1. Close terminal and open app `Kitty`
1. Generate your SSH key for git and set on your Git hosting service

### If using WSL

1. Install [WSL](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview>)
1. Install [Git inside WSL](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git)
    - Also make sure you're running the [https://git-scm.com/download/linux](latest version of git inside WSL) 
1. Generate your SSH key for git (on the host) and set on your Git hosting service
1. Copy the SSH keys to WSL and change permissions
    ```bash
    cp -r /mnt/c/Users/DylanChong/.ssh .ssh/
    chown -R .ssh
    chmod 700 .ssh
    chmod 600 .ssh/*
    ```
1. Install neovim
    ```bash
    # Install the latest version of neovim
    cd ~
    mkdir .nvim
    cd .nvim

    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    gunzip nvim-linux64.tar.gz
    tar -x -f nvim-linux64.tar

    cd ~
    mkdir -p ~/bin
    ln -s ~/.nvim/nvim-linux64/bin/nvim ~/bin/nvim
    ```
1. Install packages - roughly the same ones from list of Main package from the mac section above
    ```bash
    sudo apt-get install zsh zsh-antigen 

    # Download asdf from https://asdf-vm.com/guide/getting-started.html#_2-download-asdf

    sudo add-apt-repository ppa:aos1/diff-so-fancy

    sudo apt-get install bat
    mkdir -p ~/bin
    ln -s "`which batcat`" ~/bin/bat

    sudo apt-get install ranger fzf tmux diff-so-fancy ripgrep fd-find
    ```
1. Set default shell to zsh `chsh --shell $(which zsh)`

### Cloning this repo

1. Clone and configure git
    ```bash
    cd ~
    git clone https://github.com/dylan-chong/dotfiles
    cd dotfiles
    git config core.worktree ~
    git config status.showUntrackedFiles no
    ```
1. Move the contents of `dotfiles` into `~` (except `.git`)
    ```bash
    ls -A dotfiles | grep -v '^.git$' | while read -r content; do mv dotfiles/"$content" -t ~; done
    ```
1. Merge the `~/.gitconfig.example` into your `~/.gitconfig`
    - Also update any `AAAAAA` spots
1. Run `touch ~/.zshrc_private`

### ASDF

1. Install asdf plugins
    ```bash
    cd ~
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install
    ```

### Neovim

1. Install [vim-plug](https://github.com/junegunn/vim-plug#neovim)
1. Create shortcut for nvim directory
    ```bash
    ln -s ~/.vim ~/.config/nvim
    ```
1. Open `vi`, run `:PlugInstall`
1. Run `:checkhealth`
1. Close vim

### tmux

1. Install [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm#installation)
1. Open `tmux` and press `CTRL-s I` to install plugins

### Terminal theme

1. Set terminal theme by running `base16_material-palenight`
1. Install [fira code](https://github.com/tonsky/FiraCode/wiki/Installing)
    - This will be applied automatically if using Kitty, otherwise set this as your terminal font manually
1. Restart your terminal
