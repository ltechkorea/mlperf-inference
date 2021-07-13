#!/bin/bash

SUMMITER="LTechKorea"
BENCHMARK_NAME="resnet50"
MLPERF_LOG=/home/tanssg/mlperf-inference-submodule/vision/classification_and_detection/output/tf-gpu/resnet50
8i
OPT=

DATA_DIR=/opt/data/Dataset/imn/val
MODEL_DIR=/opt/data/Model/imageclassification/model

mkdir -p ~/${SUMMITER}/
mkdir -p ~/LTechKorea_result/results/L4210S-10G/$BENCHMARK_NAME/Server/{performance,accuracy}

docker run -e --gpus all  tf resnet50 gpu --count 100 --scenario Server --qps 200 --max-latency 0.1 --time=60
cp $mlperf_log_accuracy/* ~/LTechKorea_result/results/L4210S-10G/$BENCHMARK_NAME/Server/performance

./run_local.sh tf resnet50 gpu --count 100 --scenario Server --qps 200 --max-latency 0.1 --time=60 --accuracy
cp $mlperf_log_accuracy/* ~/LTechKorea_result/results/L4210S-10G/$BENCHMARK_NAME/Server/accuracy

python3 ./tools/accuracy-imagenet.py --mlperf-accuracy-file $mlperf_log_accuracy/mlperf_log_accuracy.json --imagenet-val-file /data/imagenet2012/val_map.txt > ~/LTechKorea_result/results/L4210S-10G/$BENCHMARK_NAME/Server/accuracy/accuracy.txt

