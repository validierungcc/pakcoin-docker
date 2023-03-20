#!/bin/bash

set -meuo pipefail

EMARK_DIR=/emark/.eMark-volume-2/
EMARK_CONF=/emark/.eMark-volume-2/eMark.conf

if [ -z "${EMARK_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  EMARK_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${EMARK_CONF}" ]; then
  tee -a >${EMARK_CONF} <<EOF

server=1

rpcuser=${EMARK_RPCUSER:-emark}
rpcpassword=${EMARK_RPCPASSWORD}

rpcclienttimeout=${EMARK_RPCCLIENTTIMEOUT:-30}

addnode=199.247.2.54
addnode=65.109.141.173
EOF
echo "Created new configuration at ${EMARK_CONF}"
fi

if [ $# -eq 0 ]; then
  /emark/eMark/src/eMarkd -rpcbind=:4444 -rpcallowip=*
else
  exec "$@"
fi
