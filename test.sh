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
# export NUM_DUMP_TACTICS=30
# export RUST_MIN_STACK=todo
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
# export SELECTED_SERIALIZED_TACTIC_PATH=`pwd`
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
PACKAGE="-p command-gen"
PACKAGE=
PACKAGE="-p npu-test"
PACKAGE="-p npu-executor-common"
PACKAGE="-p npu-compiler-dma"
PACKAGE="-p npu-ir-common"
PACKAGE="-p tactic-populator"
PACKAGE="-p npu-compiler"
PACKAGE="-p npu-test-ir"
PACKAGE="-p npu-integration-test"
PROFILE=dev
PROFILE=release
PROFILE=fast-debug
# export NPU_DEVNAME=npu0pe0-3,npu0pe4-7
export NPU_ARCH=nvp
# export NVP_LOG=info
# export NVP_LOG_STDOUT=1
# export RUST_LOG=info,[dma_commandgen]=debug,[dma_tactic]=debug
# export RUST_LOG=info,tactic_populator::operator::non_tactic_kernel::gather_scatter=debug
# export RUST_LOG=trace
# export RUST_LOG=info\
# ,npu_compiler_dma=debug\
# ,npu_compiler_base=debug
# export RUST_BACKTRACE=1
# export RUST_LIB_BACKTRACE=0 #skip lib crate backtrace for performance
# export NO_PARALLEL_ESTIMATE=1
# export FIR_TEST_BRIEF_DIFF=false
export SKIP_FIR_TEST=true
export SKIP_LIR_VERIFIER=true
export SKIP_SYNC_CHECK=true
# export LOG_PATH=`pwd`/crates/npu-integration-test/log/tactic_test_scatter_2
# export TACTIC_ID=2
export TACTIC_PATH=`pwd`/crates/npu-integration-test/log/tactic_test_gather_edge_cases_split/tactic/1_cost_84624_hidable_false.yaml
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-4chip.yml
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe.yml
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-4pe.yml
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade.yml
# export NPU_DEVNAME=npu1pe0-3,npu1pe4-7
# export DUMP_PE_PROGRAM=code
# export LOAD_PE_PROGRAM=code
cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E '
test(test_tactic_from_inferred_graph)
|test(tactic_test_gather_edge_cases_split)
|test(###end###)
' -- --include-ignored



# #### Release Script #####
# PACKAGE="-p npu-ir-common"
# PACKAGE="-p npu-compiler-kernelize"
# PACKAGE="-p tactic-populator"
# PACKAGE="-p npu-integration-test"
# PACKAGE="-p npu-compiler"
# # PROFILE=dev
# # PROFILE=fast-debug
# PROFILE=release
# export SELECTED_SERIALIZED_TACTIC_PATH=`pwd`/selected_tactics/serializedd
# # export E2E_TEST_RUN_OPERATORWISE_TEST=1
# # export E2E_TEST_CACHE_STAGE=ldfg
# export SKIP_FIR_TEST=true
# export SKIP_LIR_VERIFIER=true
# export SKIP_SYNC_CHECK=true
# # export DUMP_PE_PROGRAM=code
# # export NUM_DUMP_TACTICS=200
# # export RUST_LOG=info\
# # ,npu_compiler_dma=debug\
# # ,npu_compiler_base=debug
# # export RUST_LOG=[populate_failure]=trace,[estimate_failure]=trace
# # export RUST_LOG=
# export RUST_LOG=info,[dma_tactic]=debug
# # export NO_PARALLEL_ESTIMATE=1
# export NPU_GLOBAL_CONFIG_PATH=renegade-8pe-4chip
# export NPU_GLOBAL_CONFIG_PATH=renegade-8pe
# # export NPU_GLOBAL_CONFIG_PATH=renegade-4pe
# # export NPU_GLOBAL_CONFIG_PATH=renegade
# # export RUST_MIN_STACK=1073741824 # 1G
# # export RUST_BACKTRACE=1
# # export RUST_LIB_BACKTRACE=0 #skip lib crate backtrace for performance
# cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E '
# test(test_compile_llama3_1_8b_mlperf_latest_8pe_w16a16_decode_first_block_b16_s11264)
# |test(###end###)
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
# let _ = std::fs::remove_dir_all(format!("log/{}_snapshot", test_name().unwrap()).as_str());
# let dump_path = <std::path::PathBuf as std::str::FromStr>::from_str(
#     format!("log/{}_snapshot", test_name().unwrap()).as_str(),
# )?;
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