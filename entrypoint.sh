#!/bin/bash
set -meuo pipefail

BOLIVAR_DIR=/bolivar/.Bolivarcoin/
BOLIVAR_CONF=/bolivar/.Bolivarcoin/eMark.conf

if [ -z "${BOLIVAR_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  BOLIVAR_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${BOLIVAR_CONF}" ]; then
  tee -a >${BOLIVAR_CONF} <<EOF
server=1
rpcuser=${BOLIVAR_RPCUSER:-bolivarrpc}
rpcpassword=${BOLIVAR_RPCPASSWORD}
EOF
echo "Created new configuration at ${BOLIVAR_CONF}"
fi

if [ $# -eq 0 ]; then
  /usr/local/bin/bolivarcoind -rpcbind=0.0.0.0 -rpcport=3563 -rpcallowip=0.0.0.0/0 -printtoconsole=1
else
  exec "$@"
fi
