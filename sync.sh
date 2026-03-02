#!/usr/bin/env bash
set -eou pipefail

src="${1:?provide source repo path}"

# normalize path
src="$(realpath "$src")/"

if [[ ! -d "$src/.git" ]]; then
    echo "source directory is not a git repo" >&2
    exit 1
fi

rsync -av \
    --exclude='.git/' \
    --exclude='README.md' \
    --exclude='symlink_list.txt' \
    --exclude='.config/git/config' \
    "$src" ./

git config user.name "akmbo"
git config user.email "67482112+akmbo@users.noreply.github.com"

echo "done."
