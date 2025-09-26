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
ln -s $HOME/scripts $HOME/$NAME/wolfrevo
ln -s /tmp $HOME/$NAME/tmp
ln -s $HOME/npu-tools/crates/npu-torch-models/llm_dfg_cache/.dvc/cache $HOME/$NAME/crates/npu-torch-models/llm_dfg_cache/.dvc/cache
ln -s $HOME/npu-tools/artifacts/furiosa-libtorch/.dvc/cache $HOME/$NAME/artifacts/furiosa-libtorch/.dvc/cache

cd $HOME/$NAME
