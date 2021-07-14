#!/bin/bash
. ./env.sh

#performance benchmark run count
PERF_RUN_COUNT='1'              
SET=$(seq 1 $PERF_RUN_COUNT)

# SCENARIO_LIST 변수에 지정된 시나리오 실행(Performance, Accuracy)
for scenario in $SCENARIO_LIST
do
    cd $WORK_DIR
    echo '============= Performance Benchmark ================='
    # Performance 벤치마크 실행 (PERF_RUN_COUNT 변수에 정의된만큼 반복)
    for n in $SET
    do
        echo "Performance Benchamrk run_$n"
        # performance 벤치마크 실행
        ./run_and_time.sh $FRAMEWORK $BENCHMARK $DEVICE --scenario $scenario $OPT
        # 벤치마크 결과 제출디렉토리 생성
        mkdir -p $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/performance/run_$n
        # mlperf_log_summary.txt, mlperf_log_detail.txt 제줄 디렉토리로 이동
        mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/mlperf_log_summary.txt $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/performance/run_$n/
        mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/mlperf_log_detail.txt $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/performance/run_$n/
    done

    echo '==================== Accuracy ======================='
    # Accuracy 벤치마크 실행
    ./run_and_time.sh $FRAMEWORK $BENCHMARK $DEVICE --scenario $scenario $OPT --accuracy
    
    # accuracy.txt 생성
    python3 $WORK_DIR/tools/accuracy-imagenet.py --mlperf-accuracy-file $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/mlperf_log_accuracy.json --imagenet-val-file $DATA_DIR/val_map.txt > $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/accuracy.txt
    
    # mlperf_log_summary.txt, mlperf_log_detail.txt, mlperf_log_accuracy.json 제출디렉토리로 이동
    mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/mlperf_log_summary.txt $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/accuracy/
    mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/mlperf_log_detail.txt $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/accuracy/
    mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/mlperf_log_accuracy.json $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/accuracy/
    mv $WORK_DIR/output/$FRAMEWORK-$DEVICE/$BENCHMARK/accuracy.txt $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario/accuracy/
done

echo '==================TEST01========================'
# Compliance Testing TEST01
cp $MLPERF_DIR/compliance/audit_v0.5/nvidia/TEST01/audit.config $WORK_DIR
cd $WORK_DIR
for scenario in $SCENARIO_LIST
do
    # audit.config 로 실행
    #./run_and_time.sh $FRAMEWORK $BENCHMARK $DEVICE --scenario $scenario $OPT --user_conf audit.config

    # run_verification.py 로 audit.config로 실행한것과 기존테스트 비교
    python3 $MLPERF_DIR/compliance/nvidia/TEST01/run_verification.py \
        -r $SUBMISSION_DIR/$DEVISION/results/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario \
        -c $WORK_DIR/output/tf-gpu/resnet50 \
        -o $SUBMISSION_DIR/$DEVISION/compliance/$SUBMIT_ORGANIZATION-$SYSTEM/$BENCHMARK/$scenario
done
rm $WORK_DIR/audit.config