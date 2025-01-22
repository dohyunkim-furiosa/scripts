#!/bin/bash
export SPEC_TYPE="gather_tensor"
export SPEC_FILE_PATH=crates/npu-models/data/spec/renegade/others/gather.spec
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade.yml
export NVP_CONFIG_PATH=`pwd`/configs/renegade.yml
export NVP_USE_PREBUILT_BINARY=OFF

cargo use_renegade --release
cargo run --release --bin \
    spec_gen synthesize \
    -t $SPEC_TYPE \
    -n 500 \
    -o /$SPEC_TYPE.spec
mv /$SPEC_TYPE.spec $SPEC_FILE_PATH

mkdir -p ./log
make artifacts -f makefiles/Makefile.artifacts
LD_LIBRARY_PATH=.artifacts/lib/renegade:.artifacts/lib \
NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade.yml \
    scripts/filter_spec_by_nvp.py \
    --timeout 1000 --jobs 30 \
    --success-output log/success.spec \
    --fail-output log/failed.spec \
    --stat-output log/stat.spec \
    $SPEC_FILE_PATH

dvc add $SPEC_FILE_PATH
# dvc rm $SPEC_FILE_PATH2