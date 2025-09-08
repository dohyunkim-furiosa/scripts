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
# export RUST_MIN_STACK=1073741824 # 1G
# export RUST_BACKTRACE=1
# export RUST_LIB_BACKTRACE=0 #skip lib crate backtrace for performance
### E2E ###
# export E2E_TEST_CACHE_STAGE=lir
# export DUMP_GRAPHS=true
# export FIR_TEST_DUMP_DFG_SPEC=1
# export E2E_TEST_RUN_OPERATORWISE_TEST=1
# export ENABLE_POPULATOR_DEBUG=1
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
# export SELECTED_SERIALIZED_TACTIC_PATH=`pwd`/selected_tacticsasdf
### C code ###
# export DUMP_PE_PROGRAM=code
# export LOAD_PE_PROGRAM=code
### Tactic Test ###
# export TACTIC_PATH=`pwd`/serialized/PreLower_4764.yaml
# export LOG_PATH=$PWD/test_compile_llama3_1_mlperf_latest_w8fa8f_decode_mid_block_b32_s2048/O63
# export TACTIC_ID=0
# export TESTVECTOR=$PWD/crates/npu-integration-test/create_dma_command_testvector_stos.yaml
### Etc ###
# export MAX_TACTIC_COUNT=5
# export RAYON_NUM_THREADS=32
# export PROPTEST_SEED=1234567890

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

##### graph dump #####
# // dump and load graph
# npu_utils::workflow::save_to_cache(&ir)?;
# let aaa = npu_utils::workflow::load_cached_file::<Graph>()?.unwrap();
# let bbb = npu_compiler::compile::compile_dfg_to_lir(aaa.clone())?;
# let ccc = GraphLogger::new("log/aaabbb.dot");
# ccc.add(&aaa);
# ccc.add(&bbb);
# ccc.dump()?;




#######################
##### Test Script #####
#######################

### cargo args ###
PACKAGE="-p command-gen"
PACKAGE=
PACKAGE="-p npu-test"
PACKAGE="-p npu-executor-common"
PACKAGE="-p npu-ir-common"
PACKAGE="-p npu-test-ir"
PACKAGE="-p npu-compiler-dma"
PACKAGE="-p tactic-populator"
PACKAGE="-p npu-compiler"
PACKAGE="-p npu-integration-test"
PROFILE=fast-debug
PROFILE=release
PROFILE=dev

### log configs ###
# export RUST_LOG=debug
# export RUST_LOG=trace
# export RUST_LOG=info,[populate_failure]=debug,[tactic_populator]=debug,[npu_compiler_dma]=debug,[npu_compiler]=debug
# export RUST_LOG=info,[dma_tactic]=debug,[dma_commandgen]=debug
# export RUST_LOG=info\
# ,npu_compiler_dma=debug\
# ,npu_compiler_base=debug
# export NVP_LOG=debug
# export NVP_LOG_STDOUT=1
# export FIR_TEST_BRIEF_DIFF=false

### dump configs ###
# export LOG_PATH=`pwd`/crates/npu-integration-test/log/tactic_test_scatter_2
# export TACTIC_ID=2
# export TACTIC_PATH=`pwd`/PreLower_4005.yaml
# export SELECTED_SERIALIZED_TACTIC_PATH=`pwd`/tactics
# export DUMP_PE_PROGRAM=code
# export LOAD_PE_PROGRAM=code
# export NUM_DUMP_TACTICS=200
# export E2E_TEST_CACHE_STAGE=ldfg
export DUMP_SCHEDULE_GRAPH=s.dot

### run configs ###
# export E2E_TEST_RUN_OPERATORWISE_TEST=1
# export NO_PARALLEL_ESTIMATE=1
export SKIP_FIR_TEST=true
export SKIP_LIR_VERIFIER=true
export SKIP_SYNC_CHECK=true
# export RUST_LIB_BACKTRACE=0 #skip lib crate backtrace for performance
export NPU_ARCH=nvp
# export NPU_DEVNAME=npu1pe0-3,npu1pe4-7
# export RUST_MIN_STACK=1073741824 # 1G
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-4chip.yml
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-2chip.yml
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe.yml
# export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-4pe.yml
export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade.yml
export RUST_BACKTRACE=1
PACKAGE="-p npu-compiler"
# PROFILE=release

cargo nextest run --nocapture --cargo-profile=$PROFILE $PACKAGE -E '
test(test_tactic_from_inferred_graph)
|test(unittest_bulk_weight_load_)
' -- --include-ignored


### gather ###
# |test(codegen_test_tensor_dma_gather_)
# |test(tactic_test_gather_small)
# |test(tactic_test_gather_oss_bias)
# |test(tactic_test_gather_oss_blocks)
# |test(tactic_test_gather_oss_scales)
# |test(proptest_compile_gather)
# |test(proptest_compile_tensor_gather)
# |test(proptest_compile_tensor_dma_identity_using_sram_and_scratchpad)

### scatter ###
# |test(codegen_test_tensor_dma_scatter_)
# |test(proptest_compile_scatter)

### load/store ###
# |test(test_compile_low_level_lower_)
# |test(test_compile_low_level_unlower_)
# |test(proptest_compile_tensor_load)
# |test(proptest_compile_tensor_store)
# |test(proptest_compile_load)
# |test(proptest_compile_store)

