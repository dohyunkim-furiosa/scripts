#!/bin/bash
set -e

##### EnvVars #####
### Configs ###
export LD_LIBRARY_PATH=`pwd`/target/release/deps
# export NPU_GLOBAL_CONFIG_PATH=renegade-8pe
# export NPU_DEVNAME=npu0pe0-3,npu0pe4-7
# export NPU_ARCH=renegade #nvp
### Logs and Profiles ###
# export DISABLE_PROFILER=1
# export NPU_PROFILER_PATH="profile.json"
# export TUC_PROFILE_LEVEL="debug"
# export ENABLE_PERT_PROFILE=1
# export PERT_LOG=debug
# export NVP_LOG=info #debug
# export NVP_LOG_STDOUT=1
# export NVP_LOG_PATH=./nvp.log
# export NVP_CHROME_TRACING=1
export RUST_LOG=info #tactic_populator=trace,npu_compiler::compile=trace,npu_compiler_dma::dma_estimator=debug
export TRACING_WITHOUT_TIME=1
# export RUST_BACKTRACE=1
# export RUST_LIB_BACKTRACE=0
### E2E ###
# export E2E_TEST_CACHE_STAGE=lir
# export DUMP_GRAPHS=true
# export FIR_TEST_DUMP_DFG_SPEC=1
# export E2E_TEST_RUN_OPERATORWISE_TEST=1
# export NO_PARALLEL_ESTIMATE=1
# export DIFF_DEBUGGER="1"
# export DUMP_TENSOR=1 #TensorIndex
# export PRINT_ALL_TENSOR_BUFFERS=1
# export DUMP_DIFF=1
# export GENERATE_TEST_VECTORS=true
# export NUM_SAMPLE=20
# export FIR_TEST_BRIEF_DIFF=false
# export SKIP_FIR_TEST=true
# export SKIP_LIR_VERIFIER=true
# export SKIP_SYNC_CHECK=true
### C code ###
# export DUMP_PE_PROGRAM=code
# export LOAD_PE_PROGRAM=code
### Tactic Test ###
# export LOG_PATH=$PWD/test_compile_llama3_1_mlperf_latest_w8fa8f_decode_mid_block_b32_s2048/O63
# export TACTIC_ID=0
# export TESTVECTOR=$PWD/crates/npu-integration-test/create_dma_command_testvector_stos.yaml
### Etc ###
# export MAX_TACTIC_COUNT=5
# export RAYON_NUM_THREADS=32
# export PROPTEST_SEED=1234567890


##### Debug Script #####
PACKAGE="-p npu-ir-common"
PACKAGE="-p command-gen"
PACKAGE=
PACKAGE="-p npu-test"
PACKAGE="-p npu-compiler-dma"
PACKAGE="-p tactic-populator"
PACKAGE="-p npu-executor-common"
PACKAGE="-p npu-compiler"
PACKAGE="-p npu-test-ir"
PACKAGE="-p npu-integration-test"
PROFILE=fast-debug
PROFILE=release
PROFILE=rel-with-deb-info
PROFILE=dev
# export NPU_DEVNAME=npu0pe0-3,npu0pe4-7
export NPU_ARCH=nvp
# export RUST_LOG=info\
# ,tactic_populator=trace\
# ,npu_compiler::compile=trace\
# ,npu_compiler_dma=trace\
# ,npu_compiler_dma::dma_estimator=trace\
# ,npu_compiler_base::cycle_estimator=debug
# export RUST_LOG=trace
# export NVP_LOG=info #debug
# export NVP_LOG_STDOUT=1
export RUST_BACKTRACE=1
# export RUST_LIB_BACKTRACE=0
# export NO_PARALLEL_ESTIMATE=1
# export FIR_TEST_BRIEF_DIFF=false
export SKIP_FIR_TEST=true
export SKIP_LIR_VERIFIER=true
export SKIP_SYNC_CHECK=true
# export LOG_PATH=$PWD/crates/npu-integration-test/log/tactic_test_gptj_kv_cache_prompt_b1
# export TACTIC_ID=0
# export TACTIC_PATH=`pwd`/PreLower_3219_cost_315910_hidable_false_rank_5.yaml
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-4chip.yml
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe.yml
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-4pe.yml
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade.yml
# export NPU_DEVNAME=npu1pe0-3,npu1pe4-7
# export DUMP_PE_PROGRAM=code
# export LOAD_PE_PROGRAM=code
cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E '
test(test_tactic_debug#)
|test(codegen_test_tensor_dma_gather_1#)
|test(unittest_firtest_between_shape_mismatch)
|test(test_compile_sparse_graph_with_valid_length_1_with_cycle_check)
|test(###end###)
' #-- --include-ignored --exact

# #### Release Script #####
# PACKAGE="-p npu-ir-common"
# PACKAGE="-p npu-compiler-kernelize"
# PACKAGE="-p tactic-populator"
# PACKAGE="-p npu-integration-test"
# PACKAGE="-p npu-compiler"
# PROFILE=release
# # export E2E_TEST_RUN_OPERATORWISE_TEST=1
# export E2E_TEST_CACHE_STAGE=ldfg
# export SKIP_FIR_TEST=true
# export SKIP_LIR_VERIFIER=true
# export SKIP_SYNC_CHECK=true
# export DUMP_PE_PROGRAM=code
# # export RUST_LOG=info\
# # ,tactic_populator=trace\
# # ,npu_compiler::compile=trace\
# # ,npu_compiler_dma::dma_estimator=debug\
# # ,npu_compiler_base::cycle_estimator=debug
# # export NO_PARALLEL_ESTIMATE=1
# export NPU_GLOBAL_CONFIG_PATH=renegade-8pe-4chip
# # export NPU_GLOBAL_CONFIG_PATH=renegade-8pe
# cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E '
# test(test_compile_exaone3_5_32b_8pe_4chip_w16a16_decode_last_block_b1_s16384)
# - test(test_compile_exaone3_5_32b_8pe_4chip_w16a16_decode_last_block_b1_s16384)
# | test(###end###)
# ' -- --include-ignored --exact






# ##### npu-runtime-test #####
# cargo run -r --bin npu_runtime_test x.edf -a x.test_vector

# ##### RNGD plot #####
# cargo run --bin dump_lir_plot lir3.json --output rngd_plot3 --profile profile3.json --type profile

##### Tools #####
# To see stack trace, std::backtrace::Backtrace::force_capture()
# To see graph, npu_utils::graphviz::GraphLogger::new("wolfrevo.dot").add_with_label(graph, "wolfrevo");
# To see ir-viewer, graph.dump_json_for_ir_viewer("wolfrevo.json").unwrap();

#### snapshot dump #####
# let dump_path = <std::path::PathBuf as std::str::FromStr>::from_str("log/debug")?;
# std::fs::create_dir_all(dump_path.as_path())?;
# npu_compiler::utils::summary::dump::write_snapshot(
#     &npu_compiler::utils::summary::collect_compile_summary(|| {
#         // Add compile code here
#         Ok(())
#     })?
#     .1,
#     None,
#     dump_path.as_path(),
#     false,
# )?;