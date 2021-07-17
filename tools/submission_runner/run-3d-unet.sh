#!/bin/sh

set -e

EXECUTE_DIR=$(pwd)

LOG_FILE="${EXECUTE_DIR}/debug.log"
LOG_CMD="tee -a ${LOG_FILE}"

if [ -e "${LOG_FILE}" ] ; then
  rm -f ${LOG_FILE}
fi

#topology : 3d-unet, bert, dlrm, resnet50, rnnt, ssd-mobilenet, ssd-resnet34
TOPOLOGY="3d-unet"

WORK_DIR="${MLPERF_DIR}/vision/medical_imaging/3d-unet-brats19"
COMPL_DIR="${MLPERF_DIR}/compliance/nvidia"

BMT_MODE="performance"

if [ "accuracy" = "$1" ] ; then
  BMT_MODE="accuracy"
fi

echo "==========================================" | eval ${LOG_CMD}
echo "EXECUTE_DIR: ${EXECUTE_DIR}"  | eval ${LOG_CMD}
echo "BMT_MODE: ${BMT_MODE}" | eval ${LOG_CMD}
echo "MLPERF_DIR: ${MLPERF_DIR}" | eval ${LOG_CMD}
echo "==========================================" | eval ${LOG_CMD}

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
  echo "Test: ${TEST_MODE} ${BMT_MODE}" | eval ${LOG_CMD}
  echo "==========================================" | eval ${LOG_CMD}
  cp -v ${AUDIT_CONF} ${WORK_DIR} | eval ${LOG_CMD}
fi

BMT_TARGET="${BMT_MODE}-run"

# Change directory for Topology
cd ${WORK_DIR}

# Run Benchmark
echo "make ${BMT_TARGET}" | eval ${LOG_CMD}
make ${BMT_TARGET} | eval ${LOG_CMD}

# Copy result into submission directory
RESULT_DIR="${WORK_DIR}/build/logs"

cd ${EXECUTE_DIR}
mv -vf ${RESULT_DIR}/* ${EXECUTE_DIR} | eval ${LOG_CMD}
