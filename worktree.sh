#!/bin/bash
set -e
if [ ! -d ".git" ]; then
    echo "This is not a git repository. Please navigate to a git repository."
    exit 1
fi
if [ -n "$1" ]; then
    NAME="$1"
else
    echo "Input directory name:"
    read NAME
fi
git worktree add "../$NAME"


# links
mkdir -p /target/$NAME
mkdir -p /cache/furiosa-libtorch
mkdir -p /cache/llm_dfg_cache
ln -s /target/$NAME target
ln -s $HOME/scripts z
ln -s /tmp tmp
ln -s /cache/furiosa-libtorch/ artifacts/furiosa-libtorch/.dvc/cache
ln -s /cache/llm_dfg_cache/ crates/npu-torch-models/llm_dfg_cache/.dvc/cache


