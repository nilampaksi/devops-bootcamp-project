#!/bin/bash
set -eux

# wait for cloud-init & apt
while lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  sleep 5
done

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

apt install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible

apt install -y ansible
apt install -y curl git python3-pip unzip

ansible --version > /tmp/ansible_version.txt

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

aws --version

TOKEN=$(aws ssm get-parameter \
  --name "/devops/github/token" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text)

cd /opt/
git clone https://${TOKEN}@github.com/nilampaksi/devops-bootcamp-project.git
cd devops-bootcamp-project/ansible


echo "CONTROLLER USER DATA COMPLETED" > /tmp/user_data_controller.done

