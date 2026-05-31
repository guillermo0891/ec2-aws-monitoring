#!/usr/bin/env bash
set -euo pipefail

TF_JSON=${1:-tf_outputs.json}
KEY_PATH=${2:-}   # optional: path to public key to include in inventory entries

command -v jq >/dev/null || { echo "jq is required"; exit 1; }
[ -f "$TF_JSON" ] || { echo "Terraform output JSON not found: $TF_JSON"; exit 1; }

#Get promgraf public IP (handles both scalar and array)
PROM_PUBLIC=$(jq -r '
  if has("promgraf_public_ip") and .promgraf_public_ip.value != null then
    ( .promgraf_public_ip.value | if type=="array" then .[0] else . end )
  else empty end
' "$TF_JSON")

#Get list of target private IPs (handles scalar or array)
TARGETS=$(jq -r '
  if has("targets_private_ips") and .targets_private_ips.value != null then
    ( .targets_private_ips.value
      | if type=="array" then .[] else . end
    )
  else empty end
' "$TF_JSON")

KEY_ATTR=""
if [ -n "$KEY_PATH" ]; then
  KEY_ATTR=" ansible_private_key_file=${KEY_PATH}"
fi

cat <<EOF
[promgraf]
promgraf ansible_host=${PROM_PUBLIC} ansible_user=ec2-user${KEY_ATTR}

[targets]
EOF

i=1
for ip in $TARGETS; do
  echo "target${i} ansible_host=${ip} ansible_user=ec2-user${KEY_ATTR}"
  i=$((i+1))
done