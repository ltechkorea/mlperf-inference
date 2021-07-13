#!/bin/bash
DATA_DIR=/opt/data/Dataset/imn/val_50000/
WORK_DIR=/home/tanssg/mlperf-inference-submodule/vision/classification_and_detection
MLPERF_DIR=/home/tanssg/mlperf-inference-submodule
SUBMIT_ORGANIZATION="LTechKorea"
SYSTEM="L4210S-10G"
SUBMISSION_DIR=/opt/data/$SUBMIT_ORGANIZATION
DEVISION="closed"
FRAMEWORK="tf"
DEVICE="gpu"
BENCHMARK="resnet50"
BENCHMARK_LIST="resnet50 dlrm"
SCENARIO_LIST="Offline Server"
OPT="--count 100 --time 30 --qps 200 --max-latency 0.1"