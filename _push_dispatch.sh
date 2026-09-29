#!/usr/bin/env bash
set -uo pipefail
cd /vol1/@appdata/trim.hermes/workspace/open-box-fnos
TOK=$(cat .git-credentials-local | sed -E 's#https://x-access-token:([^@]+)@github.com#\1#')

git remote set-url origin "https://x-access-token:${TOK}@github.com/sxpizhanglei-pixel/open-box-fnos.git"
PUSHOUT=$(git push origin main 2>&1)
echo "$PUSHOUT" | sed -E 's/x-access-token:[^@]+@/***@/'
git remote set-url origin "https://github.com/sxpizhanglei-pixel/open-box-fnos.git"

echo "=== dispatch ==="
curl -sS -X POST -H "Authorization: Bearer ${TOK}" -H 'Accept: application/vnd.github+json' -H 'Content-Type: application/json' -d '{"ref":"main"}' \
  "https://api.github.com/repos/sxpizhanglei-pixel/open-box-fnos/actions/workflows/build-fpk.yml/dispatches" \
  -o /tmp/d8.json -w "dispatch HTTP %{http_code}\n"
cat /tmp/d8.json; echo
