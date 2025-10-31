#!/bin/bash
set -e

export TRACING_WITHOUT_TIME=1
export RUST_LOG=info
export LD_LIBRARY_PATH=`pwd`/target/release/deps
export NPU_ARCH=renegade #nvp
export NPU_PROFILER_PATH="profile.json"
export TUC_PROFILE_LEVEL="debug"
export ENABLE_PERT_PROFILE=1
export DIFF_DEBUGGER="1"
# export NPU_GLOBAL_CONFIG_PATH=renegade-8pe
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-4chip.yml
# export PERT_LOG=debug
export E2E_TEST_CACHE_STAGE=lir
export SKIP_FIR_TEST=true
export SKIP_LIR_VERIFIER=true
PACKAGE="-p npu-compiler"
PROFILE=release

# variables
SHA=3d14545189d019eb6690d27090ea7e2329dc643f
TESTNAME=test_compile_exaone4_32b_8pe_4chip_w8fa16kv16_prefill_mid_nope_block_b1_s3072
METADATA_NAME=test_compile_exaone4_32b_8pe_4chip_w8fa16kv16_prefill_mid_nope_block_b1_s3072
TARGET=test-snapshot-8pe-4chip
DEVNAME="npu0pe0-3,npu0pe4-7,npu1pe0-3,npu1pe4-7,npu2pe0-3,npu2pe4-7,npu3pe0-3,npu3pe4-7"
EDF=crates/npu-compiler/log/$TESTNAME.edf #use compiled edf
# EDF=temp_test/$TESTNAME.edf #use downloaded edf
NUM_REPEAT=100

export NPU_DEVNAME=$DEVNAME
export FORCE_WAIT_BEGIN=0
export FORCE_WAIT_END=1000

# wolfrevo/run_rngd_ci.sh $SHA
# wolfrevo/download_test_vec.sh $SHA $TESTNAME $TARGET
cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E "test($TESTNAME)"
temp_test/npu_runtime_test $EDF -m temp_test/$TESTNAME.yaml -v temp_test -n $NUM_REPEAT -b 10 --absolute-tol 0.2 --relative-tol 0.3


# export GENERATE_TEST_VECTORS=true
# export NUM_SAMPLE=10



# TODO:  /rngd-ci-artifacts/test-vectors 사용하기?

