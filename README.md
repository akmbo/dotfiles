# dotfiles

My personal dotfiles for my default workspace. Clone to home directory, and run `~/dotfiles/bin/install` to setup. Any replaced files are moved to `~/dotfiles/.old/`. The dotfiles git repo is aliased to "config" and can eb run anywhere in the filesystem (ex: config status, config commit -m wip). Additional commands are provided, such as `config` with no additional arguments will cd into the dotfiles directory, and `config addall` will add all changes in tracked files to be committed. `bconf` will open .bashrc and `bconf so` will source it anywhere in the filesystem.

