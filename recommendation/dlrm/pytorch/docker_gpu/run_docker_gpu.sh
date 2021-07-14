#!/bin/bash

HOST_MLCOMMONS_ROOT_DIR=/home/dong/mlperf-inference  # path to mlcommons/inference
DLRM_DIR=/home/dong/mlperf-inference/recommendation/dlrm/dlrm-master				# path to DLRM	
MODEL_DIR=/opt/data/Model/Recommendation		# path to model folder
DATA_DIR=/opt/data/Dataset/Recommendation			# path to data folder

docker run --gpus all -it \
-v $DLRM_DIR:/root/dlrm \
-v $MODEL_DIR:/root/model \
-v $DATA_DIR:/root/data \
-v $HOST_MLCOMMONS_ROOT_DIR:/root/mlcommons \
-e DATA_DIR=/root/data \
-e MODEL_DIR=/root/model \
-e DLRM_DIR=/root/dlrm \
-e CUDA_VISIBLE_DEVICES=0,1,2,3,4,5,6,7 \
dlrm-gpu 

