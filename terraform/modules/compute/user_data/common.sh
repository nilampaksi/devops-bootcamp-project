#!/bin/bash
set -eux

# Wait for cloud-init / apt locks
while lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  sleep 5
done

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

# Basic tools
apt-get install -y curl wget unzip ca-certificates

# Ubuntu user already exists on Ubuntu AMI
SSH_DIR="/home/ubuntu/.ssh"
USER=ubuntu

mkdir -p "$SSH_DIR"
chown "$USER:$USER" "$SSH_DIR"
chmod 700 "$SSH_DIR"

# Append the key, do NOT overwrite if you might add others
echo "${ANSIBLE_PUBLIC_KEY}" >> "${SSH_DIR}/authorized_keys"
chown "$USER:$USER" "${SSH_DIR}/authorized_keys"
chmod 600 "${SSH_DIR}/authorized_keys"

echo "COMMON USER DATA COMPLETED" > /tmp/user_data_common.done
