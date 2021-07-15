#!/bin/sh

set -e

EXECUTE_DIR=$(pwd)
LOG_FILE="${EXECUTE_DIR}/test.log"

#TOP_DIR=$(pwd)
TOP_DIR="/home/sangwoo/mlperf-inference"

#topology : 3d-unet, bert, dlrm, resnet50, rnnt, ssd-mobilenet, ssd-resnet34
TOPOLOGY="3d-unet"

WORK_DIR="${TOP_DIR}/vision/medical_imaging/3d-unet-brats19"
COMPL_DIR="${TOP_DIR}/compliance/nvidia"

BMT_MODE="performance"

if [ "accuracy" = "$1" ] ; then
  BMT_MODE="accuracy"
fi

echo "EXECUTE_DIR: ${EXECUTE_DIR}" 2>&1 | tee ${LOG_FILE}
echo "BMT_MODE: ${BMT_MODE}" 2>&1 | tee -a ${LOG_FILE}

TEST_MODE="$1"
AUDIT_CONF="${EXECUTE_DIR}/audit.config"

if [ ! -e ${AUDIT_CONF} ] ; then
  AUDIT_CONF=""
  TEST_MODE=""
  if [ -e "${WORK_DIR}/audit.config" ] ; then
    rm -vf "${WORK_DIR}/audit.config"
  fi
else
  # Copy audit.config to working directory
  echo "Test: ${TEST_MODE}" 2>&1 | tee -a ${LOG_FILE}
  cp -v ${AUDIT_CONF} ${WORK_DIR} 2>&1 | tee -a ${LOG_FILE}
fi

BMT_TARGET="${BMT_MODE}-run"

# Change directory for Topology
cd ${WORK_DIR}

# Run Benchmark
echo "make ${BMT_TARGET}" 2>&1 | tee -a ${LOG_FILE}
if [ "accuracy" = "${BMT_MODE}" ] ; then
  make ${BMT_TARGET} 2>&1 | tee -a ${LOG_FILE}
fi

# Copy result into submission directory
RESULT_DIR="${WORK_DIR}/build/logs"

cd ${EXECUTE_DIR}
cp -avf ${RESULT_DIR}/* ${EXECUTE_DIR} 2>&1 | tee -a ${LOG_FILE}

exit 0

if [ "TEST01" = "${TEST_MODE}" ] ; then
  BMT_TARGET="accuracy"
  # Change directory for Topology
  cd ${WORK_DIR}

  # Run Benchmark
  if [ "accuracy" = "${BMT_TARGET}" ] ; then
    make ${BMT_TARGET}
  fi

  # Copy result into submission directory
  RESULT_DIR="${WORK_DIR}/build/logs"

  if [ "" != "${TEST_MODE}" ] ; then
    echo "Test: ${TEST_MODE}"
    cp -v ${AUDIT_CONF} ${WORK_DIR}
  fi

  cd ${EXECUTE_DIR}
  cp -avf ${RESULT_DIR}/* ${EXECUTE_DIR}
fi
