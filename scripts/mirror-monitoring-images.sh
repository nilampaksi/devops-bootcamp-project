#!/bin/bash
set -e

REGION=ap-southeast-1
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

aws ecr get-login-password --region $REGION | docker login \
  --username AWS \
  --password-stdin $ECR

docker pull prom/node-exporter:v1.8.1
docker tag prom/node-exporter:v1.8.1 $ECR/monitoring/node-exporter:latest
docker push $ECR/monitoring/node-exporter:latest

docker pull prom/prometheus:v2.49.1
docker tag prom/prometheus:v2.49.1 $ECR/monitoring/prometheus:latest
docker push $ECR/monitoring/prometheus:latest

docker pull grafana/grafana:10.4.2
docker tag grafana/grafana:10.4.2 $ECR/monitoring/grafana:latest
docker push $ECR/monitoring/grafana:latest
