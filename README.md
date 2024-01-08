# dotfiles

My personal dotfiles for my default workspace. Clone to home directory, and run `~/dotfiles/bin/install` to setup. Any replaced files are moved to `~/dotfiles/.old/`.

The dotfiles git repo is aliased to "dot" and can be run anywhere in the filesystem (ex: dot status, dot commit -m wip). `dot` with no additional arguments will cd into the dotfiles directory, and `dot addall` will add all changes from tracked files to be committed. `bconf` will open .bashrc and `bconf so` will source it anywhere in the filesystem.

