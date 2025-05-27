# Various Unix Settings

All my settings, plugins, and colour schemes that I have found on the Internet
can be found here. Take what you want! Hopefully you can find something useful
in there somewhere.

## Installation

Follow relevant instructions from top to bottom

### If using Mac

1. Install [homebrew](https://brew.sh)
1. Run the printed out command to load brew in the current shell (`eval ...` or
   something)
1. Install packages
    ```bash
    # Main packages
    brew install git antigen asdf neovim tmux diff-so-fancy bat ripgrep entr bottom lf
    # UI
    brew install google-chrome alfred slack rectangle maccy spotify discord kitty mos
    # Mac-specific
    brew install reattach-to-user-namespace trash fd
    ```
1. Configure Chrome
    1. Sign into chrome
    1. Install Adguard chrome extension
    1. Install Vimium chrome extension
    1. Use DuckDuckGo
1. Mac settings
    1. Adjust dock icons to have only Chrome and Downloads
    1. Set caps lock key to control
    1. Auto hide dock
    1. Increase key repeat to max speed / min delay
1. Open and configure flux
1. Open and configure Alfred
1. Open and configure Maccy
    1. Enable open at login
1. Open and configure Mos
1. Configure Rectangle
    - Use Spectacle key binds
    - Choose disable macOS window tiling
    - Clear bottom/top half and centre keybindings
    - Use Cmd+Alt+Down as fullscreen
    - Use Cmd+Alt+Up as centre
    - Change next/previous display to Ctrl+Page Up/Down
1. Close terminal and open app `Kitty`
1. Follow relevant steps from the `If using Ubuntu or WSL+Ubuntu` section for setting up the rest of stuff (ignore linux stuff)

### If using Ubuntu or WSL+Ubuntu

1. WSL Setup
   1. Install [WSL](https://ubuntu.com/tutorials/install-ubuntu-on-wsl2-on-windows-11-with-gui-support#1-overview>)
   1. Set the default shell to be Ubuntu, not PowerShell
   1. Install [Git inside WSL](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git)
       - Also make sure you're running the [https://git-scm.com/download/linux](latest version of git inside WSL) 
1. Generate your SSH key for git (on the host) and set on your Git hosting service
   1. Create ssh keys
       ```
       ssh-add --apple-use-keychain ~/.ssh/id_github_personal
       ```
   1. https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent 
   1. Add SSH Key to GitHub
   1. Setup `~/.ssh/config`
       ```
       Host github_personal
       HostName github.com
       AddKeysToAgent yes
       IdentityFile ~/.ssh/id_github_personal
       ```
1. (WSL only) Copy the SSH keys to WSL and change permissions
    ```bash
    cp -r /mnt/c/Users/DylanChong/.ssh .ssh/
    chown -R $USER .ssh
    chmod 700 .ssh
    chmod 600 .ssh/*
    ```
1. Install packages that need manual installing, e.g., neovim
    ```bash
    brex_install_upgrade
    ```

1. Install packages - roughly the same ones from list of Main package from the mac section above
    ```bash
    sudo apt-get install zsh zsh-antigen python3 python3-pip build-essential bat lf tmux ripgrep fd-find
    ```
1. (Ubuntu Wayland only) `sudo apt install wl-clipboard`
1. (WSL only) Install [wslu](https://wslutiliti.es/wslu/install.html)
1. Set default shell to zsh `chsh --shell $(which zsh)`
    1. Restart your computer to apply
1. Continue down this README

### Clone this repo

1. Clone and configure git
    ```bash
    cd ~
    git clone --verbose git@github_personal:dylan-chong/dotfiles.git
    cd dotfiles
    git config core.worktree ~
    git config status.showUntrackedFiles no
    ```
1. Move the contents of `dotfiles` into `~` (except `.git`)
    ```bash
    cd ~/dotfiles

    find . -type f | perl -pe 's/^\.\///' | grep -v '^\.git\b' | while read file; do mv "$file" "$HOME/$file"; done
    # TODO does this work on linux?:
    find . -type d | perl -pe 's/^\.\///' | grep -v '^\.git\b' | while read file; do mv "$file" "$HOME/$file"; done
    ```
1. Merge the `~/.gitconfig.example` into your `~/.gitconfig`
    - Also update any `AAAAAA` spots
1. Clone `git@github_personal:dylan-chong/gprq.git`
1. Run `cp ~/.zshrc_private.example ~/.zshrc_private`
    - Also update any `AAAAAA` spots
1. Continue down this README

### ASDF

1. Download [`asdf`](https://asdf-vm.com/guide/getting-started.html#_2-download-asdf)
    unless already installed with a package manager
1. Install asdf plugins
    ```bash
    cd ~
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf install nodejs
    ```
    - Ignore warnings about plugins not being installed if you don't want to use those

### LunarVim (optional - legacy)

1. Install [rustup](https://www.rust-lang.org/tools/install) using the default options
    1. Mac: `brew install rustup`
1. Run [installation steps](https://www.lunarvim.org/docs/installation)
    - Let it install dependencies except `neovim` and `tree-sitter-cli` are not needed
1.  If pynvim didn't install, run:
    - (Ubuntu / WSL Ubuntu):
        ```bash
        sudo apt install python3-pynvim
        sudo apt remove neovim
        ```
    - Mac: Probably the same as the above but with brew.

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

1. Set terminal theme by running `base16_tokyo-night-moon`
1. Install the [Fira Code font](https://www.nerdfonts.com/font-downloads) (not Fira Mono)
    - This will be applied automatically if using Kitty, otherwise set this as your terminal font manually
1. Restart your terminal to check it applies
