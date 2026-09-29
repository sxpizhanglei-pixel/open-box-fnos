#!/bin/sh
set -e
# Open-Box container entrypoint
# 挂载: /etc/sing-box (config)  /app/ui (Yacd UI)
# 宿主网络模式, sing-box 直接监听 2080(mixed) 与 9090(clash_api)
CONFIG_DIR="/etc/sing-box"
CONFIG_FILE="${CONFIG_DIR}/config.json"
mkdir -p "${CONFIG_DIR}"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "ERROR: ${CONFIG_FILE} not found. Seed config not mounted." >&2
  exit 1
fi

echo "Open-Box starting sing-box with ${CONFIG_FILE} ..."
exec sing-box run -c "${CONFIG_FILE}"
