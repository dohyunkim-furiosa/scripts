set -e

if [ ! -d ".git" ]; then
    echo "This is not a git repository. Please navigate to a git repository."
    exit 1
fi

if [ -n "$1" ]; then
    NAME="$1"
else
    echo "Input worktree name:"
    read NAME
fi

git worktree add "../$NAME"


# links
mkdir -p /target/$NAME
mkdir -p /cache/furiosa-libtorch
mkdir -p /cache/llm_dfg_cache
ln -s /target/$NAME $HOME/$NAME/target
ln -s $HOME/scripts $HOME/$NAME/z
ln -s /tmp $HOME/$NAME/tmp


cd $HOME/$NAME
git submodule update --recursive --init --force

echo "
TODO:
  1. Follow the instructions in https://github.com/furiosa-ai/npu-tools/blob/master/README.md
    * update aws credential at https://aws-cli.furiosa.dev
    * `dvc --cd artifacts/furiosa-libtorch/jammy pull -r origin -j 10`
  2. cargo use_renegade -r && cargo build
"