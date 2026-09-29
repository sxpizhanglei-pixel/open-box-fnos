#!/usr/bin/env bash
set -uo pipefail
cd /vol1/@appdata/trim.hermes/workspace/open-box-fnos
TOK=$(cat .git-credentials-local | sed -E 's#https://x-access-token:([^@]+)@github.com#\1#')
START_TS=$(date +%s)
for i in $(seq 1 40); do
  sleep 30
  curl -sS -H "Authorization: Bearer ${TOK}" "https://api.github.com/repos/sxpizhanglei-pixel/open-box-fnos/actions/runs?per_page=3&created=>=$(date -u -d '@$START_TS' +%Y-%m-%dT%H:%M:%SZ)" -o /tmp/poll.json
  LINE=$(python3 -c "import json
d=json.load(open('/tmp/poll.json'))
ws=[r for r in d.get('workflow_runs',[]) if r.get('event')=='workflow_dispatch']
r=ws[0] if ws else (d.get('workflow_runs')[0] if d.get('workflow_runs') else None)
if r: print(r['id'],r.get('status'),r.get('conclusion',''))
else: print('none')" 2>/dev/null || echo "parse-err")
  echo "  [$i] ${LINE}"
  ST=$(echo "$LINE" | awk '{print $2}')
  CONC=$(echo "$LINE" | awk '{print $3}')
  if [ "$ST" = "completed" ]; then echo "FINAL: $ST $CONC"; break; fi
done
echo "=== latest release ==="
curl -sS -H "Authorization: Bearer ${TOK}" "https://api.github.com/repos/sxpizhanglei-pixel/open-box-fnos/releases?per_page=1" -o /tmp/pollrel.json
python3 -c "import json
d=json.load(open('/tmp/pollrel.json'))
for r in (d or []):
  print('tag',r['tag_name'])
  for a in r.get('assets',[]): print('  asset:',a['name'],'size',a['size'],a['browser_download_url'])"
