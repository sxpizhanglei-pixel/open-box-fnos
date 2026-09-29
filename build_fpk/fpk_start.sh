#!/bin/bash
set -e
# 数据卷里的 compose 是运行时文件
DATA_COMPOSE="/vol1/1000/docker/open-box/compose.yaml"
[ -f "${DATA_COMPOSE}" ] || DATA_COMPOSE="./compose.yaml"

if [ -f "${DATA_COMPOSE}" ]; then
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "${DATA_COMPOSE}" up -d
  else
    docker-compose -f "${DATA_COMPOSE}" up -d
  fi
else
  echo "ERROR: ${DATA_COMPOSE} not found" >&2
  exit 1
fi
echo "Open-Box started."
