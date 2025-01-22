#!/bin/bash
set -e

##### EnvVars #####
### Configs ###
export LD_LIBRARY_PATH=`pwd`/target/release/deps
# export NPU_GLOBAL_CONFIG_PATH=renegade-4pe
# export NPU_DEVNAME=npu1pe4-7
# export NPU_ARCH=renegade #nvp
### Logs and Profiles ###
# export DISABLE_PROFILER=1
# export NPU_PROFILER_PATH="profile.json"
# export TUC_PROFILE_LEVEL="debug"
# export ENABLE_PERT_PROFILE=1
# export PERT_LOG=debug
# export NVP_LOG=debug
# export NVP_LOG_STDOUT=1
# export NVP_LOG_PATH=./nvp.log
# export NVP_CHROME_TRACING=1
export RUST_LOG=info #tactic_populator=trace,npu_compiler::compile=trace
# export RUST_BACKTRACE=1
### E2E ###
# export E2E_TEST_CACHE_STAGE=postlower #[strum(serialize_all = "lowercase")] pub enum FuriosaIrKind 이라서 prelower, postlower, ldfg 처럼 소문자를 써야함
# export DUMP_GRAPHS=true
# export FIR_TEST_DUMP_DFG_SPEC=1
# export E2E_TEST_RUN_OPERATORWISE_TEST=1 
# export NO_PARALLEL_ESTIMATE=1
# export DIFF_DEBUGGER="1"
# export DUMP_TENSOR=1 #TensorIndex
# export DUMP_DIFF=1
# export GENERATE_TEST_VECTORS=1
# export FIR_TEST_BRIEF_DIFF=false
# export SKIP_FIR_TEST=true
### C code ###
# export WRITE_C_CODE_PATH=code.c
# export READ_C_CODE_PATH=code.c
### Tactic Test ###
# export LOG_PATH=$PWD/test_compile_llama3_1_mlperf_latest_w8fa8f_decode_mid_block_b32_s2048/O63
# export TACTIC_ID=0
# export TESTVECTOR=$PWD/crates/npu-integration-test/create_dma_command_testvector_stos.yaml
### Etc ###
# export MAX_TACTIC_COUNT=5
# export RAYON_NUM_THREADS=32
# export PROPTEST_SEED=1234567890


##### Update dependancies #####
# git submodule deinit --all -f
# git submodule update --recursive --init --force
# cargo use_renegade -r


##### Debug Script #####
PACKAGE="-p npu-ir-common"
PACKAGE="-p command-gen"
PACKAGE="-p npu-executor-common"
PACKAGE=
PACKAGE="-p tactic-populator"
PACKAGE="-p npu-compiler-dma"
PACKAGE="-p npu-compiler"
PACKAGE="-p npu-test-ir"
PACKAGE="-p npu-test"
PACKAGE="-p npu-integration-test"
PROFILE=dev
export NPU_GLOBAL_CONFIG_PATH=renegade
# export RUST_LOG=debug
# export WRITE_C_CODE_PATH=code.c
# export READ_C_CODE_PATH=code.c
export RUST_BACKTRACE=1
export NO_PARALLEL_ESTIMATE=1
# export FIR_TEST_BRIEF_DIFF=false
export LOG_PATH=$PWD/crates/npu-integration-test/log/tactic_test_gather_0
export TACTIC_ID=0
export TESTVECTOR=$PWD/crates/npu-integration-test/generate_dma_command_testvector_from_llunlower.yaml
cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E '
test(test_bridge_selects_dram_tactic)|
test(###end###)
' -- --include-ignored


# #### Release Script #####
# PACKAGE="-p npu-ir-common"
# PACKAGE="-p tactic-populator"
# PACKAGE="-p npu-compiler-kernelize"
# PACKAGE="-p npu-integration-test"
# PACKAGE="-p npu-compiler"
# PROFILE=release
# export NPU_GLOBAL_CONFIG_PATH=renegade-4pe
# # export E2E_TEST_RUN_OPERATORWISE_TEST=1
# export SKIP_FIR_TEST=true
# cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E '
# test(test_compile_debug)|
# test(###end###)
# ' -- --include-ignored --exact









# ##### RNGD plot #####
# cargo run --bin dump_lir_plot lir.json --output rngd_plot --type profile --profile profile.json

##### Operatorwise log 검사 템플릿 #####
# git checkout debug
# for i in $(seq 61 99); do
#   export LOG_PATH="/root/worktree/crates/npu-compiler/tmp/snapshot/test_profile_gptj_paged_attention_optimized_packed_rope_2l_w8a8_pp2_prefill_first_block_b1_s512/O$i"
#   echo "Testing $LOG_PATH"
#   PACKAGE="-p npu-test-ir"
#   RUST_BACKTRACE=1 RUST_LOG=warn cargo nextest run --nocapture --cargo-profile=dev $PACKAGE -E 'test(test_tactic_debug)' -- --include-ignored &> "test_O${i}_debug.log"
# done
# git checkout cddb8e1
# for i in $(seq 72 99); do
#   export LOG_PATH="/root/worktree/crates/npu-compiler/tmp/snapshot/test_profile_gptj_paged_attention_optimized_packed_rope_2l_w8a8_pp2_prefill_first_block_b1_s512/O$i"
#   echo "Testing $LOG_PATH"
#   PACKAGE="-p npu-test-ir"
#   RUST_BACKTRACE=1 RUST_LOG=warn cargo nextest run --nocapture --cargo-profile=dev $PACKAGE -E 'test(test_tactic_debug)' -- --include-ignored &> "test_O${i}_cddb8e1.log"
# done

##### Tools #####
# To see stack trace, std::backtrace::Backtrace::force_capture()
# To see graph, npu_utils::graphviz::GraphLogger::new("wolfrevo.dot").add_with_label(graph, "wolfrevo");
# To see ir-viewer, graph.dump_json_for_ir_viewer("wolfrevo.json").unwrap();
# To force serialized, rayon::ThreadPoolBuilder::new().num_threads(1).build_global().unwrap(); // run it at program start

##### Edf 디버그 #####
# command_graph.expose_activations_in_topological_order();
# firtest.with_lir_edf_debugger_info + lir edf 디버거
# C코드나 nvp코드에서 로그 찍기
