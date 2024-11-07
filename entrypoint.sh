#!/bin/bash
set -meuo pipefail

PAKCOIN_DIR=/pakcoin/.pakcoin/
PAKCOIN_CONF=/pakcoin/.pakcoin/pakcoin.conf

if [ -z "${PAKCOIN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  PAKCOIN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${PAKCOIN_CONF}" ]; then
  tee -a >${PAKCOIN_CONF} <<EOF
server=1
rpcuser=${PAKCOIN_RPCUSER:-pakcoinrpc}
rpcpassword=${PAKCOIN_RPCPASSWORD}
addnode=159.242.234.196
addnode=161.97.124.118
addnode=161.97.137.67
addnode=185.68.67.39
addnode=217.254.36.8
addnode=27.138.155.95
addnode=38.242.235.208
addnode=42.147.99.239
addnode=93.195.92.5
addnode=93.207.238.109
EOF
echo "Created new configuration at ${PAKCOIN_CONF}"
fi

if [ $# -eq 0 ]; then
  /usr/local/bin/pakcoind -rpcbind=0.0.0.0 -rpcport=7866 -rpcallowip=0.0.0.0/0 -printtoconsole=1
else
  exec "$@"
fi
