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
$HOME/scripts/pre-push.sh" > .git/hooks/pre-push
chmod u+x .git/hooks/pre-push


rustup default nightly
##### furiosa/npu-tools README.md #####
PROTOC_VERSION=22.0
curl -Lo protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip"  \
&& unzip -q protoc.zip bin/protoc -d /usr/local \
&& chmod a+x /usr/local/bin/protoc
PATH="/usr/local/bin:$PATH"
rustup target add aarch64-unknown-none-softfloat
apt install build-essential clang libncurses-dev libssl-dev pkg-config python3-dev gcc-aarch64-linux-gnu libboost-dev libboost-regex-dev libelf-dev cmake libtbb-dev clang-format-11 clang-tidy libc6-dev-arm64-cross libyaml-cpp-dev libgl1-mesa-glx libcapstone-dev ninja-build clang libc++-dev libc++abi-dev
pip3 install -U pip wheel
pip3 install -r tekton/build/requirements.txt
pip3 install fbgemm-gpu-cpu
############################################
pip3 install dvc[s3]


rm -rf /target/$NAME
mkdir -p /target/$NAME
ln -s /target/$NAME target
ln -s $HOME/scripts z
ln -s /tmp tmp
ln -s /cache/furiosa-libtorch artifacts/furiosa-libtorch/.dvc/cache
ln -s /cache/llm_dfg_cache crates/npu-torch-models/llm_dfg_cache/.dvc/cache


cargo install cargo-sort --locked
cargo install cargo-nextest --locked
cargo use_renegade --release


echo "
TODO:
  1. Visit https://aws-cli.furiosa.dev and update $HOME/.aws/credentials
  2. dvc --cd artifacts/furiosa-libtorch/jammy pull -r origin -j 10
  3. dvc pull -r origin -j 10
"
