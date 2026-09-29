#!/bin/bash
set -e
# fnOS 安装钩子:把 compose 部署到数据卷,创建目录,写默认配置,启动容器
DATA_DIR="/vol1/1000/docker/open-box"
CONFIG_DIR="${DATA_DIR}/config"
UI_DIR="${DATA_DIR}/ui"
APP_DIR="/vol1/1000/app/open-box"   # fnOS 安装后 .fpk 内容所在目录

mkdir -p "${DATA_DIR}" "${CONFIG_DIR}" "${UI_DIR}"

# 部署 compose 到数据卷(每次安装/更新都覆盖,以镜像 tag 为准)
if [ -f "${APP_DIR}/compose.yaml" ]; then
  cp "${APP_DIR}/compose.yaml" "${DATA_DIR}/compose.yaml"
elif [ -f "./compose.yaml" ]; then
  cp "./compose.yaml" "${DATA_DIR}/compose.yaml"
fi

# 首次安装写默认 sing-box 配置
if [ ! -f "${CONFIG_DIR}/config.json" ]; then
  cat > "${CONFIG_DIR}/config.json" <<'EOF'
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

# 部署 UI 默认文件
if [ ! -f "${UI_DIR}/index.html" ]; then
  echo '<h1>Open-Box UI (Yacd-meta)</h1>' > "${UI_DIR}/index.html"
fi

# 启动
if docker compose version >/dev/null 2>&1; then
  docker compose -f "${DATA_DIR}/compose.yaml" up -d
else
  docker-compose -f "${DATA_DIR}/compose.yaml" up -d
fi
echo "Open-Box installed & started. UI: http://<nas-ip>:9090"
