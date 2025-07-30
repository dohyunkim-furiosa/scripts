#!/bin/bash
set -e
if [ -n "$1" ]; then
    NAME="$1"
else
    echo "Input directory name:"
    read NAME
fi
if [ ! -d "$HOME/$NAME" ]; then
    gh repo clone clone "https://github.com/dohyunkim-furiosa/npu-tools" $NAME
else
    echo "$HOME/$NAME already exists. Skipping cloning."
fi
cd $HOME/$NAME

# git settings
if ! git remote | grep -q '^furiosa$'; then
    git remote add furiosa https://github.com/furiosa-ai/npu-tools
    git fetch furiosa
    git checkout furiosa/master
    git submodule update --init --recursive --force
    git config core.hooksPath wolfrevo
fi

# softlink settings
rm -rf target wolfrevo tmp
rm -rf artifacts/furiosa-libtorch/.dvc/cache crates/npu-torch-models/llm_dfg_cache/.dvc/cache
rm -rf crates/npu-torch-models/llm_dfg_cache/.dvc/cache
mkdir -p /target/$NAME
mkdir -p /cache/furiosa-libtorch
mkdir -p /cache/llm_dfg_cache
ln -s /target/$NAME target
ln -s $HOME/scripts wolfrevo
ln -s /tmp tmp
ln -s /cache/furiosa-libtorch/ artifacts/furiosa-libtorch/.dvc/cache
ln -s /cache/llm_dfg_cache/ crates/npu-torch-models/llm_dfg_cache/.dvc/cache

# vscode task settings
cp wolfrevo/tasks.json .vscode/tasks.json

# install dependencies
# source $HOME/venv/bin/activate
pip3 install -r $HOME/npu-tools/tekton/build/requirements.txt
dvc --cd artifacts/furiosa-libtorch/jammy pull -r origin -j 10
cargo install cargo-sort --version=1.0.9 --locked --force
cargo install cargo-nextest --locked --force

echo "TODO:
* Follow the instructions in https://github.com/furiosa-ai/npu-tools/blob/master/README.md
* Login VSCode
"