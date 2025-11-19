#!/usr/bin/env bash
set -euo pipefail

# Read Options JSON using bashio (preinstalled in HA add-ons)
if command -v bashio >/dev/null 2>&1; then
  PLUS_API_KEY="$(bashio::config 'plus_api_key' || true)"
  OPENAI_API_KEY="$(bashio::config 'openai_api_key' || true)"

  export PLUS_API_KEY="${PLUS_API_KEY:-}"
  export OPENAI_API_KEY="${OPENAI_API_KEY:-}"

  # Optional: pass any extra key/vals to env
  if jq -e . >/dev/null 2>&1 < /data/options.json; then
    for k in $(jq -r '.extra_env | keys[]?' /data/options.json); do
      v=$(jq -r --arg k "$k" '.extra_env[$k]' /data/options.json)
      export "$k"="$v"
    done
  fi
fi

# Ensure a persistent log dir; tee stdout there as well
mkdir -p /data/logs
# Start Frigate exactly as the base image would, but capture logs to file too
# Frigate image runs the 'frigate' launcher on PATH
frigate 2>&1 | tee -a /data/logs/frigate.log
