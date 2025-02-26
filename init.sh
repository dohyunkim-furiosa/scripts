#!/bin/bash
set -e

apt update
apt upgrade -y
apt install -y git curl graphviz gh python3-pip unzip neovim software-properties-common

add-apt-repository ppa:git-core/ppa
apt update
apt install git
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
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh #rust
curl -sS https://starship.rs/install.sh | sh #starship

echo "
#export CARGO_PROFILE_DEBUG_OPT_LEVEL=1
#export CARGO_PROFILE_TEST_OPT_LEVEL=1
export PATH="$PATH:$HOME/.cargo/bin"
eval "$(starship init bash)"

. "$HOME/.cargo/env"
" >> $HOME/.bashrc
source $HOME/.bashrc
