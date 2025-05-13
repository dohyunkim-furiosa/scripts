#!/bin/bash
set -e

# exit if pwd is not home
if [ "$PWD" != "$HOME" ]; then
    echo "Current directory is not home. Exiting."
    exit 1
fi

apt update
apt upgrade -y
apt install -y git curl graphviz gh python3-pip unzip neovim software-properties-common xdg-utils

add-apt-repository ppa:git-core/ppa -y
apt update
apt install -y git
gh auth login

cd $HOME
if [ ! -d "$HOME/scripts" ]; then
    git clone https://github.com/dohyunkim-furiosa/scripts
else
    echo "$HOME/scripts already exist - clone skipped."
fi
chmod +x $HOME/scripts/*

# create softlinks
rm -rf $HOME/.cache
mkdir -p /cache
ln -s /cache $HOME/.cache

# install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y #rust
curl -sS https://starship.rs/install.sh | sh -s -- -y #starship

echo "
#export CARGO_PROFILE_DEBUG_OPT_LEVEL=1
#export CARGO_PROFILE_TEST_OPT_LEVEL=1
export PATH="$PATH:$HOME/.cargo/bin"
eval "$(starship init bash)"

. "$HOME/.cargo/env"
" >> $HOME/.bashrc
source $HOME/.bashrc

##### furiosa/npu-tools README.md #####
rustup default nightly
rustup target add aarch64-unknown-none-softfloat

apt install -y build-essential clang libncurses-dev libssl-dev pkg-config python3-dev python-is-python3 gcc-aarch64-linux-gnu libboost-dev libboost-regex-dev libelf-dev cmake libtbb-dev clang-format-11 clang-tidy libc6-dev-arm64-cross libyaml-cpp-dev libgl1-mesa-glx libcapstone-dev ninja-build
pip3 install -U pip wheel setuptools
pip3 install fbgemm-gpu-cpu dvc[azure]

PROTOC_VERSION=22.0
curl -Lo protoc.zip "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip" \
&& unzip -o -q protoc.zip bin/protoc -d /usr/local \
&& chmod a+x /usr/local/bin/protoc
PATH="/usr/local/bin:$PATH"
rm protoc.zip

curl -sL https://aka.ms/InstallAzureCLIDeb | bash
az login
############################################

source $HOME/scripts/clone.sh npu-tools
