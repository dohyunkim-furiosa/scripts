#!/bin/bash
set -e

# from reproduction script
SHA=920ac9d38f9ad91aa461b3a522d8197511e9954b
TESTNAME=test_compile_exaone3_5_32b_8pe_4chip_w16a16_chunked_prefill_mid_block_b1_s8192x2_i8192
TARGET=test-snapshot-8pe-4chip
DEVNAME="npu0pe0-3,npu0pe4-7,npu1pe0-3,npu1pe4-7,npu2pe0-3,npu2pe4-7,npu3pe0-3,npu3pe4-7"

# variables
export LD_LIBRARY_PATH=`pwd`/target/release/deps
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-4chip.yml
export RUST_LOG=info #tactic_populator=trace,npu_compiler::compile=trace,npu_compiler_dma::dma_estimator=debug
export TRACING_WITHOUT_TIME=1
export SKIP_FIR_TEST=true
export SKIP_LIR_VERIFIER=true
PACKAGE="-p npu-compiler"
PROFILE=release
# export E2E_TEST_CACHE_STAGE=lir #ldfg 이후부터는 edf덤프 안되는 함정 조심
# export E2E_TEST_CACHE_STAGE=ldfg
# EDF=crates/npu-compiler/log/$TESTNAME.edf #use compiled edf
EDF=temp_test/$TESTNAME.edf #use downloaded edf
NUM_REPEAT=20

# wolfrevo/run_rngd_ci.sh $SHA
wolfrevo/download_test_vec.sh $SHA $TESTNAME $TARGET
cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E "test($TESTNAME)" -- --exact
NPU_PROFILER_PATH="profile.json" NPU_ARCH="renegade" NPU_DEVNAME="$DEVNAME" DIFF_DEBUGGER="1" TUC_PROFILE_LEVEL="debug" ENABLE_PERT_PROFILE="1" temp_test/npu_runtime_test $EDF -m temp_test/$TESTNAME.yaml -v temp_test -n $NUM_REPEAT -r 1 --concurrency 1
