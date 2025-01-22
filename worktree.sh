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

rm -rf /target/$NAME
mkdir -p /target/$NAME
ln -s /target/$NAME target
ln -s $HOME/wolfrevo wolfrevo
ln -s /tmp tmp


cd $HOME/$NAME
echo "#!/bin/sh
set -e
cargo fmt --all -- --check
cargo clippy --all-targets -- -D warnings
$HOME/wolfrevo/pre-push.sh" > .git/hooks/pre-push
chmod +x .git/hooks/pre-push
git submodule update --recursive --init --force
cargo use_renegade --release
cargo build