#!/bin/bash

# ** 회사정보, 하드웨어 정보 (수정x) **
SUBMIT_ORGANIZATION="LTechKorea"
SYSTEM="L4210S-10G"
SUBMISSION_DIR=/opt/data/$SUBMIT_ORGANIZATION
DIVISION="closed"
DEVICE="gpu"

# ** 작업 디렉토리, 메인 디렉토리, dataset 디렉토리 **
WORK_DIR=/home/tanssg/mlperf-inference-submodule/vision/classification_and_detection
MLPERF_DIR=/home/tanssg/mlperf-inference-submodule
DATA_DIR=/opt/data/Dataset/imn/val_50000/

# ** 디렉토리 생성관련 변수 **
# 생성할 디렉토리 리스트 ex) BENCHMARK_LIST="resnet50 dlrm 3u-unet ..." , SCENARIO_LIST="Offline Server ..."
BENCHMARK_LIST="resnet50"
# 생성및 실행할 시나리오 리스트 ex) SCENARIO_LIST="Offline Server .." 
SCENARIO_LIST="Offline"


# ** 벤치마크 실행 관련 옵션 **
BENCHMARK="resnet50"
FRAMEWORK="tf"
OPT="--count 100 --time 30 --qps 200 --max-latency 0.1"
