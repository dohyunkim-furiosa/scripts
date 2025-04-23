#!/bin/bash
set -e
if [ -n "$1" ]; then
    NAME="$1"
else
    echo "Input directory name:"
    read NAME
fi
if [ ! -d "$HOME/$NAME" ]; then
    git clone "https://github.com/dohyunkim-furiosa/npu-tools" $NAME
else
    echo "$HOME/$NAME already exists. Skipping cloning."
fi
cd $HOME/$NAME
git remote add furiosa https://github.com/furiosa-ai/npu-tools
git fetch furiosa
git checkout furiosa/master
git submodule update --init --recursive --force
echo "#!/bin/sh
set -e
cargo fmt --all -- --check
cargo clippy --all-targets -- -D warnings
cargo sort --grouped --check --workspace
ruff check scripts
ruff format --check --diff scripts
" > .git/hooks/pre-push
chmod u+x .git/hooks/pre-push

mkdir -p /target/$NAME
mkdir -p /cache/furiosa-libtorch
mkdir -p /cache/llm_dfg_cache
ln -s /target/$NAME target
ln -s $HOME/scripts wolfrevo
ln -s /tmp tmp
ln -s /cache/furiosa-libtorch/ artifacts/furiosa-libtorch/.dvc/cache
ln -s /cache/llm_dfg_cache/ crates/npu-torch-models/llm_dfg_cache/.dvc/cache


cargo install cargo-sort --locked
cargo install cargo-nextest --locked

mkdir -p $HOME/.aws

echo "
TODO:
  1. Follow the instructions in https://github.com/furiosa-ai/npu-tools/blob/master/README.md
    * update aws credential at https://aws-cli.furiosa.dev
    * dvc --cd artifacts/furiosa-libtorch/jammy pull -r origin -j 10
  2. cargo use_renegade -r && cargo build
"