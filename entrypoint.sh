#!/bin/bash
set -e
CONFIG_DIR="/etc/sing-box"
CONFIG_FILE="${CONFIG_DIR}/config.json"
mkdir -p "${CONFIG_DIR}"
if [ ! -f "${CONFIG_FILE}" ]; then
  cat > "${CONFIG_FILE}" <<'EOF'
{
  "log": { "level": "info", "timestamp": true },
  "experimental": {
    "clash_api": {
      "external_controller": "0.0.0.0:9090",
      "external_ui": "/app/ui",
      "secret": "openbox123"
    }
  },
  "inbounds": [
    { "type": "mixed", "tag": "mixed-in", "listen": "0.0.0.0", "listen_port": 2080 }
  ],
  "outbounds": [
    { "type": "direct", "tag": "direct" }
  ]
}
EOF
fi
exec sing-box run -c "${CONFIG_FILE}"
