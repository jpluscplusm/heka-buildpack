set -x
export APP_ROOT=$HOME
: ${HEKA_SHARE_DIR:=${APP_ROOT}/heka/share/heka}
: ${HEKA_BASE_DIR:=/tmp}
export HEKA_SHARE_DIR
export HEKA_BASE_DIR

exec ${APP_ROOT}/heka/bin/hekad -config="${APP_ROOT}/heka/conf/"
