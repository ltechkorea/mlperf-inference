#!/bin/bash

DATA_DIR=/srv/data/Dataset/imn/val/
MODEL_DIR=/srv/data/Model/imageclassification/model/

docker run --gpus all -it --rm \
	-v /opt/data/Dataset/imn/:/opt/data/Dataset/imn \
	-v /opt/data/Model/imageclassification/model/:/opt/data/Model/imageclassification/model \
	-v /home/tanssg/mlperf-inference-submodule/:/home/tanssg/mlperf-inference-submodule \
	-t mlperf-infer-imgclassify-gpu
	#-f ./Dockerfile.gpu
