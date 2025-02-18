#export CARGO_PROFILE_DEBUG_OPT_LEVEL=1
#export CARGO_PROFILE_TEST_OPT_LEVEL=1
export PATH="$PATH:$HOME/.cargo/bin"
eval "$(starship init bash)"

. "$HOME/.cargo/env"
