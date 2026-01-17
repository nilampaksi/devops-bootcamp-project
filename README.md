# DevOps Bootcamp Project – Final Project for Devops Bootcamp 2025/2026

This repository contains Infrastructure as Code (Terraform), configuration management (Ansible) and CI/CD automation (GitHub Actions) to deploy a containerized web application with monitoring (Prometheus, Grafana) on AWS.

- Author Name: Muhammad Muhaimin Aiman Bin Mazlan
- Author Emails: nilampaksi95@gmail.com
- Project's Target: Increase opportunity to jump into Devops scene or scope

Documentation page:
- **Web application URL**
    - [Web Application](https://web.muma-tech.com): https://web.muma-tech.com
- **Monitoring URL**
    - Visualization
        - [Grafana](https://monitoring.muma-tech.com): https://monitoring.muma-tech.com
    - Metrics Collection (monitoring)
        - [Prometheus](https://prometheus.muma-tech.com): https://prometheus.muma-tech.com
- GitHub repository URL
    - [Github Pages](https://github.com/nilampaksi/devops-bootcamp-project): https://github.com/nilampaksi/devops-bootcamp-project


## 📂 Repository Structure (Need to click)

<details>
<summary><strong>Click to expand directory tree</strong></summary>

```text
.
├── ansible
│   ├── inventory
│   ├── playbooks
│   ├── roles
│   ├── files
│   └── templates
├── terraform
│   ├── modules
│   │   ├── compute
│   │   └── network
│   └── scripts
└── README.md

</details>

## 🧰 Ansible

Used for configuration management and application deployment.

| Path | Purpose |
|-----|--------|
| `inventory/` | Host definitions for web & monitoring servers |
| `playbooks/` | Playbooks for Docker, app, Prometheus, Grafana |
| `roles/` | Reusable roles (Docker, GitHub runner) |
| `files/` | Static config files (e.g. prometheus.yml) |
| `templates/` | Jinja2 templates |

### 📜 Ansible Playbooks

| Playbook | Description |
|--------|-------------|
| `install-docker.yml` | Install Docker on all servers |
| `deploy-app.yml` | Deploy web application container |
| `node-exporter-docker.yml` | Run Node Exporter as Docker |
| `prometheus-docker.yml` | Run Prometheus container |
| `grafana-docker.yml` | Run Grafana container |
| `cleanup-monitoring-systemd.yml` | Remove systemd-based monitoring |
| `cloudflare-tunnel.yml` | Cloudflare tunnel integration |

## 🏗 Terraform

Provision AWS infrastructure.

| Path | Purpose |
|----|--------|
| `modules/network` | VPC, subnets, routing |
| `modules/compute` | EC2, IAM, Security Groups |
| `ecr.tf` | ECR repositories |
| `scripts/` | Inventory generation |

## 🖼 Architecture Overview

![Architecture Diagram](docs/images/Project-Architecture-Diagram.png)

## 🔁 CI/CD Pipeline

1. GitHub Actions builds Docker images
2. Push images to Amazon ECR
3. Run Ansible playbooks
4. Deploy containers on EC2
5. Monitoring via Prometheus & Grafana


<details>
<summary>🔍 Monitoring Stack Details</summary>

- Node Exporter → Web Server (port 9100)
- Prometheus → Monitoring Server (9090)
- Grafana → Monitoring Server (3000)
- Images stored in Amazon ECR

</details>

