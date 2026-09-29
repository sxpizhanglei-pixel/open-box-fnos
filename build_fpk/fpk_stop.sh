#!/bin/bash
set -e
COMPOSE_FILE="/vol1/1000/docker/open-box/compose.yaml"
if [ -f "${COMPOSE_FILE}" ]; then
  if docker compose version >/dev/null 2>&1; then
    docker compose -f "${COMPOSE_FILE}" down
  else
    docker-compose -f "${COMPOSE_FILE}" down
  fi
fi
echo "Open-Box stopped."
