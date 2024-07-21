# Various Unix Settings

All my settings, plugins, and colour schemes that I have found on the Internet
can be found here. Take what you want! Hopefully you can find something useful
in there somewhere.

## Installation

Follow relevant instructions from top to bottom

### If using Homebrew

1. Install [homebrew](https://brew.sh)
1. Run the printed out command to load brew in the current shell (`eval ...` or
   something)
1. Install packages
    ```bash
    # Main packages
    brew install git antigen asdf neovim fzf tmux diff-so-fancy bat ripgrep entr bottom lf
    # UI
    brew install google-chrome alfred slack rectangle maccy spotify discord
    # Mac-specific
    brew install reattach-to-user-namespace trash fd
    ```
1. Close terminal and open app `Kitty`
1. Generate your SSH key for git and set on your Git hosting service
1. Follow relevant steps from the `If using Ubuntu or WSL+Ubuntu` section for setting up the rest of stuff

### If using Ubuntu or WSL+Ubuntu

1. WSL Setup
   1. Install [WSL](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview>)
   1. Set the default shell to be Ubuntu, not PowerShell
   1. Install [Git inside WSL](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git)
       - Also make sure you're running the [https://git-scm.com/download/linux](latest version of git inside WSL) 
1. Generate your SSH key for git (on the host) and set on your Git hosting service
1. (WSL only) Copy the SSH keys to WSL and change permissions
    ```bash
    cp -r /mnt/c/Users/DylanChong/.ssh .ssh/
    chown -R $USER .ssh
    chmod 700 .ssh
    chmod 600 .ssh/*
    ```
1. Install [snap](https://snapcraft.io/docs/installing-snapd) TODO remove?
1. Install packages that need manual installing, e.g., neovim
    ```bash
    brex_install_upgrade
    ```

1. Install packages - roughly the same ones from list of Main package from the mac section above
    ```bash
    sudo apt-get install zsh zsh-antigen python3 python3-pip build-essential bat lf tmux ripgrep fd-find
    sudo snap install bottom diff-so-fancy # TODO
    ```
1. (Ubuntu Wayland only) `sudo apt install wl-clipboard`
1. (WSL only) Install [wslu](https://wslutiliti.es/wslu/install.html)
1. Set default shell to zsh `chsh --shell $(which zsh)`
    1. Restart your computer to apply

### Cloning this repo

1. Clone and configure git
    ```bash
    cd ~
    git clone git@github.com:dylan-chong/dotfiles.git
    cd dotfiles
    git config core.worktree ~
    git config status.showUntrackedFiles no
    ```
1. Move the contents of `dotfiles` into `~` (except `.git`)
    ```bash
    cd ~

    # Note `mv -t` errors for directories, so do the git checkout steps below to move those
    rm -r ~/dotfiles/.config/
    git checkout ../config # This doesn't delete existing files in ~/.config

    ls -A dotfiles | grep -v '^.git$' | while read -r content; do mv dotfiles/"$content" -t ~; done

    cd ~/dotfiles
    ```
1. Merge the `~/.gitconfig.example` into your `~/.gitconfig`
    - Also update any `AAAAAA` spots
1. Clone [`gprq`](git@github.com:dylan-chong/gprq.git)
1. Run `cp ~/.zshrc_private.example ~/.zshrc_private`
    - Also update any `AAAAAA` spots


### ASDF

1. Download asdf from https://asdf-vm.com/guide/getting-started.html#_2-download-asdf
1. Install asdf plugins
    ```bash
    cd ~
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs
    ```
    - Ignore warnings about plugins not being installed if you don't want to use those

### LunarVim

1. Install [rustup](https://www.rust-lang.org/tools/install) using the default options
1. Run [installation steps](https://www.lunarvim.org/docs/installation)
    - Let it install dependencies except `neovim` and `tree-sitter-cli` are not needed

#### TODOs

- fix telescope <space>f to open file, appears to delete current wintabs buffer (rather than adding a new one)
- move keybinds into which-key declaration

### Neovim (optional - legacy - non LunarVim)

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
1. Install the [Fira Code font](https://www.nerdfonts.com/font-downloads) (not Fira Mono)
    - This will be applied automatically if using Kitty, otherwise set this as your terminal font manually
1. Restart your terminal to check it applies
