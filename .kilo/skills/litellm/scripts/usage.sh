#!/usr/bin/env bash
# LiteLLM API key credit usage
# Generated/modified by AI RooCode 3.22.5, used model google/claude-sonnet-4-6
# Usage: ./scripts/usage.sh
# Requires: curl, LITELLM_API_KEY set in environment
# Optional: jq (falls back to raw JSON if not available)
# TODO: Replace --cacert path with the actual CA bundle location once confirmed:
#       --cacert /path/to/CA-GTICA2K8.crt
#       Remove -k once the correct CA cert path is known.

if [ -z "$LITELLM_API_KEY" ]; then
  echo "❌ LITELLM_API_KEY is not set" >&2
  exit 1
fi

response=$(curl -ks --cacert /path/to/CA-GTICA2K8.crt 'https://litellm.gratex.ai/key/info' \
  -H 'accept: application/json' \
  -H "x-litellm-api-key: ${LITELLM_API_KEY}")

if command -v jq &>/dev/null; then
  echo "$response" | jq -r '"💰 Spend:   $\(.info.spend)\n📊 Budget:  $\(.info.max_budget)\n📈 Used:    \((.info.spend / .info.max_budget * 100) | . * 100 | round / 100)%"'
else
  echo "$response"
fi
