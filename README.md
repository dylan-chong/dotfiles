# Various Unix Settings

All my settings, plugins, and colour schemes that I have found on the Internet
can be found here. Take what you want! Hopefully you can find something useful
in there somewhere.

## Installation

```bash
cd ~
git clone https://github.com/dylan-chong/dotfiles
git config core.worktree ~
git config status.showUntrackedFiles no
```

Then move the contents of `dotfiles` into `~` (except `.git`)

Then run:

```bash
ln -s ~/.vim ~/.config/nvim # Create shortcut for nvim directory
```
