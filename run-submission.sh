#!/bin/sh

set -e

TOP_DIR=$(pwd)
TOOLS_DIR="${TOP_DIR}/tools/submission_runner"

usage()
{
	echo "## Usage: $0 [ -t topology | -d | -h ]"
	echo "          -t: Topology.[ unet | dlrm | ]"
	echo "          -d: Debug run using short data"
	echo "          -h: show this message"
	exit 1;
}

submission()
{
  TOPOLOGY=$1
  echo "TOPOLOGY: ${TOPOLOGY}"
  case $TOPOLOGY in
    unet )
      DIR="${TOP_DIR}/vision/medical_imaging/3d-unet-brats19"
      JSON="${TOOLS_DIR}/3d-unet-config.json"
      sed -i 's/"scenario": "Server"/"scenario": "Offline"/g' "$JSON"
      submission_runner "$DIR" "$JSON"
      sed -i 's/"scenario": "Offline"/"scenario": "Server"/g' "$JSON"
      submission_runner "$DIR" "$JSON"
      ;;
  esac
}

submission_runner()
{
  TOPOLOGY_DIR=$1
  CONFIG_JSON=$2

  echo "TOPOLOGY_DIR: ${TOPOLOGY_DIR} config: ${CONFIG_JSON}"

  cd "${TOPOLOGY_DIR}" || true

  echo ">>>>> Clear Build Directory"
  rm -rf "${TOPOLOGY_DIR}/build"

  echo ">>>>> SETUP"
  time make TEST_RUN="${TEST_RUN}" setup

  echo ">>>>> PREPROCESS"
  time make TEST_RUN="${TEST_RUN}" preprocess-run

  cd "${TOP_DIR}" || true

  echo ">>>>> RUN"
  python "${TOOLS_DIR}"/run_mlperf.py --config "${CONFIG_JSON}"

  return 0
}

OPTSPEC="hdt:"

while getopts $OPTSPEC  opt ; do
  case $opt in
    t )
      TOPOLOGY="${OPTARG}"
      ;;
    d )
      echo "TEST_RUN ON"
      TEST_RUN=1
      ;;
    h )
      usage
      exit 0
      ;;
    \? )
      echo "Invalid Argument"
      usage
      exit 0
      ;;
  esac
done

submission "${TOPOLOGY}"
