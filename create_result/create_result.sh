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

## make code, complinace, measurements, results, systems dir
mkdir $SUBMISSION_DIR
mkdir $SUBMISSION_DIR/$DEVISION
mkdir $SUBMISSION_DIR/$DEVISION/code
mkdir $SUBMISSION_DIR/$DEVISION/compliance
mkdir $SUBMISSION_DIR/$DEVISION/measurements
mkdir $SUBMISSION_DIR/$DEVISION/results
mkdir $SUBMISSION_DIR/$DEVISION/systems

# compliance subdir
test_sut='TEST01 TEST04-A TEST04-B TEST05'
mkdir $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/
for bmt_dir in $BENCHMARK_LIST
do
    mkdir $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir
    for scenario in $SCENARIO_LIST
    do
        for n in $test_sut
        do
            mkdir -p $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/$n
        done
        mkdir $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/TEST01/performance
        mkdir $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/TEST01/accuracy
        mkdir $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/TEST04-A/performance
        mkdir $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/TEST04-B/performance
        mkdir $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/TEST05/performance

    done
done

#measurements subdir
mkdir $SUBMISSION_DIR/$DEVISION/measurements/$SUBMIT_ORGANIZATION-$SYSTEM/
for bmt_dir in $BENCHMARK_LIST
do
    for scenario in $SCENARIO_LIST
    do
        mkdir -p $SUBMISSION_DIR/$DEVISION/measurements/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario
    done
done

#results subdir
mkdir -p $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/
for bmt_dir in $BENCHMARK_LIST
do
    for scenario in $SCENARIO_LIST
    do
        mkdir -p $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario
        mkdir -p $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/accuracy
        mkdir -p $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$bmt_dir/$scenario/performance
    done
done



PERF_RUN_COUNT='1'              #performance BMT run count
SET=$(seq 1 $PERF_RUN_COUNT)

for scenario in $SCENARIO_LIST
do
    cd $WORK_DIR
    echo '============= Performance Benchmark ================='
    for n in $SET
    do
        echo "Performance Benchamkr run_$n"
        ./run_and_time.sh $FRAMEWORK $BENCHMARK $DEVICE --scenario $scenario $OPT
        mkdir $SUBMISSION_DIR/$DEVISION/$SUBMIT_ORGANIZATION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/performance/run_$n

        mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/* $SUBMISSION_DIR/$DEVISION/$SUBMIT_ORGANIZATION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/performance/run_$n
    done

    echo '==================== Accuracy ======================='
    ./run_and_time.sh $FRAMEWORK $BENCHMARK $DEVICE --scenario $scenario $OPT --accuracy
     
    python3 $WORK_DIR/tools/accuracy-imagenet.py --mlperf-accuracy-file $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/mlperf_log_accuracy.json --imagenet-val-file $DATA_DIR/val_map.txt > $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/accuracy.txt
     
    mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/* $SUBMISSION_DIR/$DEVISION/$SUBMIT_ORGANIZATION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/accuracy/
done


