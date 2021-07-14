#!/bin/bash
. ./env.sh

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
