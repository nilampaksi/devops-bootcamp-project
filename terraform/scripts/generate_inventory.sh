#!/usr/bin/env bash
set -e

# Absolute path to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Project root (terraform/../)
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Ansible inventory paths
ANSIBLE_DIR="$PROJECT_ROOT/../ansible"
INVENTORY_DIR="$ANSIBLE_DIR/inventory"
HOSTS_FILE="$INVENTORY_DIR/hosts.ini"
HOST_VARS_DIR="$INVENTORY_DIR/host_vars"

# Temp file
TMP_JSON="/tmp/instance_ids.json"

echo "Project root: $PROJECT_ROOT"
echo "Ansible dir : $ANSIBLE_DIR"

mkdir -p "$HOST_VARS_DIR"

# Must be run from terraform directory
cd "$PROJECT_ROOT"

terraform output -json instance_ids > "$TMP_JSON"

# Create hosts.ini
cat <<EOF > "$HOSTS_FILE"
[controller]
controller ansible_connection=aws_ssm ansible_aws_ssm_region=ap-southeast-1

[web]
web ansible_connection=aws_ssm ansible_aws_ssm_region=ap-southeast-1

[monitoring]
monitoring ansible_connection=aws_ssm ansible_aws_ssm_region=ap-southeast-1
EOF

# Create host_vars files
jq -r 'to_entries[] | "\(.key) \(.value)"' "$TMP_JSON" | while read -r name id; do
  cat <<EOF > "$HOST_VARS_DIR/$name.yml"
ansible_host: $id
EOF
done

echo "✅ Ansible inventory generated successfully"

