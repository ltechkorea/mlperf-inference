#!/bin/bash

# ** 회사정보, 하드웨어 정보 (수정x) **
SUBMIT_ORGANIZATION="LTechKorea"
SYSTEM="L4210S-10G"
SUBMISSION_DIR=/opt/data/dong/$SUBMIT_ORGANIZATION
DIVISION="closed"
DEVICE="gpu"

# ** 작업 디렉토리, 메인 디렉토리, dataset 디렉토리 **
WORK_DIR=/home/dong/mlperf-inference/recommendation/dlrm/pytorch
MLPERF_DIR=/home/dong/mlperf-inference
DATA_DIR=/opt/data/Dataset/fake_dlrm



# ** 디렉토리 생성관련 변수 **
# 생성할 디렉토리 리스트 ex) BENCHMARK_LIST="resnet50 dlrm 3u-unet ..." , SCENARIO_LIST="Offline Server ..."
BENCHMARK_LIST="dlrm"
# 생성및 실행할 시나리오 리스트 ex) SCENARIO_LIST="Offline Server .." 
SCENARIO_LIST="Offline"


# ** 벤치마크 실행 관련 옵션 **
BENCHMARK="dlrm"
FRAMEWORK="pytorch"
MODEL="terabyte"
OPT="--max-ind-range=10000000 --data-sub-sample-rate=0.875 --samples-to-aggregate-quantile-file=./tools/dist_quantile.txt --max-batchsize=2048"
