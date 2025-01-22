#!/bin/bash
set -e

apt update
apt upgrade -y
apt install -y git curl graphviz gh python3-pip unzip neovim

git config --global merge.conflictstyle diff3
git config --global user.name "Dohyun Kim"
git config --global user.email dohyun.kim@furiosa.ai

# create softlinks
rm -rf $HOME/.cache
mkdir -p /cache
ln -s /cache $HOME/.cache

# install
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh #rust
curl -sS https://starship.rs/install.sh | sh #starship
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc