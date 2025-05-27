#!/bin/bash
set -e
# Check RNGD governor
command_output=$(cat /sys/class/rngd_mgmt/rngd\!npu0mgmt/npu_governor)
echo "$command_output" | grep -q "performance" || {
    echo "Error: governor is not performance mode"
    exit 1
}
# variables
SHA=783fedbe8be424b761baba74dd413958f379def4
TESTNAME=test_compile_llama3_1_8b_mlperf_8pe_w16a16_chunked_prefill_first_block_b1_s8192x4_8192
TARGET=test-snapshot-8pe
DEVNAME="npu4pe0-3,npu4pe4-7"
export TRACING_WITHOUT_TIME=1
export RUST_LOG=info
export LD_LIBRARY_PATH=`pwd`/target/release/deps
export NPU_ARCH=renegade #nvp
export NPU_PROFILER_PATH="profile.json"
export TUC_PROFILE_LEVEL="debug"
export ENABLE_PERT_PROFILE=1
export DIFF_DEBUGGER="1"
export NPU_DEVNAME=$DEVNAME
export NPU_GLOBAL_CONFIG_PATH=renegade-8pe
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-4chip.yml
# export PERT_LOG=debug
export E2E_TEST_CACHE_STAGE=lir
PACKAGE="-p npu-compiler"
PROFILE=release
# EDF=crates/npu-compiler/log/$TESTNAME.edf #use compiled edf
EDF=temp_test/$TESTNAME.edf #use downloaded edf
NUM_REPEAT=20
export SKIP_FIR_TEST=true
export SKIP_LIR_VERIFIER=true

# wolfrevo/run_rngd_ci.sh $SHA
# wolfrevo/download_test_vec.sh $SHA $TESTNAME $TARGET
# cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E "test($TESTNAME)"
temp_test/npu_runtime_test $EDF -m temp_test/$TESTNAME.yaml -v temp_test -n $NUM_REPEAT -r 1 --concurrency 1


# export GENERATE_TEST_VECTORS=true
# export NUM_SAMPLE=10