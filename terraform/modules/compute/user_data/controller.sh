#!/bin/bash
set -eux

# ==============================
# REQUIRED VARIABLES (ADDED)
# ==============================
RUNNER_HOME=/opt/github-runner
RUNNER_NAME=ansible-controller
REPO_URL=https://github.com/nilampaksi/devops-bootcamp-project

# ==============================
# wait for cloud-init & apt
# ==============================
while lsof /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
  sleep 5
done

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get upgrade -y

apt install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible

id ubuntu &>/dev/null || useradd -m -s /bin/bash ubuntu

apt install -y ansible
apt install -y curl git python3-pip unzip
ansible --version > /tmp/ansible_version.txt

# ==============================
# Install AWS CLI v2 (OFFICIAL)
# ==============================
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
unzip -q /tmp/awscliv2.zip -d /tmp
/tmp/aws/install

aws --version

# ==============================
# SSH key for Ansible (kept)
# ==============================
cat <<EOF > /home/ubuntu/.ssh/ansible
${ANSIBLE_PRIVATE_KEY}
EOF

chown ubuntu:ubuntu /home/ubuntu/.ssh/ansible
chmod 600 /home/ubuntu/.ssh/ansible

# ==============================
# Clone DevOps Repo
# ==============================
TOKEN=$(aws ssm get-parameter \
  --name "/devops/github/token" \
  --with-decryption \
  --query "Parameter.Value" \
  --output text)

cd /opt/
git clone https://${TOKEN}@github.com/nilampaksi/devops-bootcamp-project.git
cd devops-bootcamp-project/ansible

echo "CONTROLLER USER DATA COMPLETED" > /tmp/user_data_controller.done

# ==============================
# Install Docker (UNCHANGED)
# ==============================
apt-get install -y ca-certificates curl gnupg

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable docker
systemctl start docker
usermod -aG docker ubuntu

# ==============================
# Dependencies for Runner
# ==============================
apt-get update -y
apt-get install -y curl unzip jq ca-certificates

# ❌ DO NOT INSTALL awscli via apt (Ubuntu 24.04 issue)
# apt-get install -y awscli

# ==============================
# Download GitHub Runner
# ==============================
mkdir -p $RUNNER_HOME
cd $RUNNER_HOME

if [ ! -f config.sh ]; then
  curl -L -o actions-runner.tar.gz \
    https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz
  tar xzf actions-runner.tar.gz
fi

chown -R ubuntu:ubuntu $RUNNER_HOME

# ==============================
# Fetch GitHub PAT
# ==============================
GITHUB_PAT=$(aws ssm get-parameter \
  --name "/devops/github/pat" \
  --with-decryption \
  --query Parameter.Value \
  --output text)

# Validate PAT (FAIL FAST)
curl -s -H "Authorization: token $GITHUB_PAT" https://api.github.com/user | jq -e .login

# ==============================
# Remove existing runner safely
# ==============================
RUNNER_ID=$(curl -s \
  -H "Authorization: token $GITHUB_PAT" \
  https://api.github.com/repos/nilampaksi/devops-bootcamp-project/actions/runners \
  | jq -r '.runners[]? | select(.name=="'"$RUNNER_NAME"'") | .id' || true)

if [ -n "$RUNNER_ID" ]; then
  curl -X DELETE \
    -H "Authorization: token $GITHUB_PAT" \
    https://api.github.com/repos/nilampaksi/devops-bootcamp-project/actions/runners/$RUNNER_ID
fi

# ==============================
# Generate fresh runner token
# ==============================
RUNNER_TOKEN=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_PAT" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/repos/nilampaksi/devops-bootcamp-project/actions/runners/registration-token \
  | jq -r '.token // empty')

if [ -z "$RUNNER_TOKEN" ]; then
  echo "FAILED to get runner token" > /tmp/github_runner.error
  exit 1
fi

# ==============================
# Configure runner (PERMANENT)
# ==============================
sudo -u ubuntu ./config.sh \
  --url "$REPO_URL" \
  --token "$RUNNER_TOKEN" \
  --name "$RUNNER_NAME" \
  --labels "controller,docker,ecr" \
  --unattended \

# ❌ Ephemeral runners CANNOT use svc.sh
# ./svc.sh install
# ./svc.sh start

# ✅ Start runner correctly
sudo -u ubuntu ./run.sh &

echo "GitHub runner installed successfully" > /tmp/github_runner.done

# ==============================
# Web App Repo & .env customization
# ==============================
cd /opt/
rm -rf lab-final-project
git clone https://github.com/Infratify/lab-final-project.git
cd lab-final-project
cp .env.example .env

ENV_FILE="/opt/lab-final-project/.env"

if [ -f "$ENV_FILE" ]; then
  sed -i "s/^USER_NAME=.*/USER_NAME=Muhammad Muhaimin Aiman/" "$ENV_FILE"
else
  echo "USER_NAME=YourName" > "$ENV_FILE"
fi
