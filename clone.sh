#!/bin/bash
set -e
if [ -n "$1" ]; then
    NAME="$1"
else
    echo "Input directory name:"
    read NAME
fi
if [ ! -d "$HOME/$NAME" ]; then
    gh repo clone --filter blob:none "https://github.com/dohyunkim-furiosa/npu-tools" $NAME
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
rm -rf wolfrevo tmp
ln -s $HOME/scripts wolfrevo
ln -s /tmp tmp

# vscode task settings
cp wolfrevo/tasks.json .vscode/tasks.json

# install dependencies
# source $HOME/venv/bin/activate
pip3 install -r ci/tekton/build/requirements.txt
dvc --cd artifacts/furiosa-libtorch/jammy pull -r origin -j 10
cargo install cargo-sort --version=1.0.9 --locked --force
cargo install cargo-nextest --locked --force
cargo install cargo-machete --version=0.8.0 --locked --force

echo "TODO:
* Follow the instructions in https://github.com/furiosa-ai/npu-tools/blob/master/README.md
* Login VSCode
"