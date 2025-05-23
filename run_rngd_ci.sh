SHA=${1:-$(git rev-parse HEAD)}

export NPU_GLOBAL_CONFIG_PATH=`pwd`/configs/renegade-8pe-4chip.yml
export CLOUD=aks
export PATH=`pwd`/bin:$PATH
python3 -m scripts.ci.rngd_ci.run run-e2e-test $SHA --device npu-001