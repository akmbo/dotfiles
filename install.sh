#!/usr/bin/env bash

set -ou pipefail

check_cmd() {
    command -v "$1" >/dev/null 2>&1
    return $?
}

need_cmd() {
    if ! check_cmd "$1"; then
        echo "need '$1' (command not found)" >&2
        exit 1
    fi
}

# check dependencies
need_cmd apt-get
need_cmd wget

# install packages
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
    "tzdata" \
    "tmux" \
    "ripgrep" \
    "fd-find"

sudo ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

if [ -f "/usr/bin/fdfind" ] && [ ! -f "/usr/local/bin/fd" ]; then
    sudo ln -s /usr/bin/fdfind /usr/local/bin/fd
fi

# create local directories
mkdir -p "$HOME/.local/bin" "$HOME/.local/share"

# load local bin
PATH="$HOME/.local/bin:$PATH"

# install fzf
if [ ! -f "$HOME/.local/bin/fzf" ]; then
    wget -P "$HOME/.local/bin" "https://github.com/junegunn/fzf/releases/download/v0.67.0/fzf-0.67.0-linux_amd64.tar.gz"
    tar -xzf "$HOME/.local/bin/fzf-0.67.0-linux_amd64.tar.gz" -C "$HOME/.local/bin"
    rm "$HOME/.local/bin/fzf-0.67.0-linux_amd64.tar.gz"
fi

# install git-filter-repo
if [ ! -f "$HOME/.local/bin/git-filter-repo" ]; then
    wget -P "$HOME/.local/bin" "https://raw.githubusercontent.com/newren/git-filter-repo/main/git-filter-repo"
    chmod 755 "$HOME/.local/bin/git-filter-repo"
fi

# install tmux plugin manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# symlink files
./symlink.sh --select-all
