#!/bin/bash
set -eux

# wait for cloud-init & apt
while lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  sleep 5
done

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

# basic tools
apt-get install -y \
  curl \
  wget \
  unzip \
  ca-certificates

echo "COMMON USER DATA COMPLETED" > /tmp/user_data_common.done

