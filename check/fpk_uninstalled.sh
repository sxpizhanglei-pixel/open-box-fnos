#!/bin/bash
set -e
COMPOSE_FILE="/vol1/1000/docker/open-box/compose.yaml"
if [ -f "${COMPOSE_FILE}" ]; then
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "${COMPOSE_FILE}" down || true
  else
    docker-compose -f "${COMPOSE_FILE}" down || true
  fi
fi
# 卸载只移除容器,保留用户配置 /vol1/1000/docker/open-box
echo "Open-Box uninstalled (config kept at /vol1/1000/docker/open-box)."
