#!/bin/bash
[[ ${SHELL_TRACE} ]] && set -x
set -euo pipefail

export APP_ROOT=$HOME
: ${HEKA_SHARE_DIR:=${APP_ROOT}/heka/share/heka}
: ${HEKA_BASE_DIR:=/tmp}
: ${HEKA_MAX_PROCS:=2}

export HEKA_SHARE_DIR
export HEKA_BASE_DIR
export HEKA_MAX_PROCS

exec ${APP_ROOT}/heka/bin/hekad -config="${APP_ROOT}/heka/conf/"
