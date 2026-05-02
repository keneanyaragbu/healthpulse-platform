# HealthPulse DevOps Platform

Production-grade DevOps platform implementing CI/CD automation, infrastructure as code, Kubernetes orchestration, security, and observability for the HealthPulse Portal application.

---

## 📌 Overview

HealthPulse Portal is a healthcare web application originally deployed using a manual and error-prone process. This platform modernizes the delivery lifecycle by introducing automation, scalability, and operational reliability.

---

## 🚨 Problem Statement

The legacy deployment process had several limitations:

- Manual deployments (~45 minutes per release)
- Frequent production outages due to misconfigurations
- No automated testing or quality checks
- No security scanning in the pipeline
- No monitoring or alerting system

---

## ✅ Solution

This DevOps platform introduces:

- CI/CD automation for build, test, and deployment
- Infrastructure as Code using Terraform
- Containerization using Docker
- Kubernetes orchestration using k3s
- Secure pipelines with code quality and vulnerability scanning
- Observability using Prometheus and Grafana
- Docs-as-Code using MkDocs

---

## 🏗 Architecture Components

| Layer | Technology |
|------|------------|
| CI/CD | Jenkins |
| Infrastructure | Terraform (AWS EC2, VPC) |
| Containerization | Docker |
| Orchestration | Kubernetes (k3s) |
| Configuration Management | Ansible |
| Monitoring | Prometheus + Grafana |
| Code Quality | SonarQube |
| Security | Snyk |
| Documentation | MkDocs |

---

## 📂 Repository Structure

```text
healthpulse-platform/
├── docs/                # Documentation platform (MkDocs)
├── terraform/           # Infrastructure as Code
├── ansible/             # Configuration management
├── k8s/                 # Kubernetes manifests
├── pipelines/           # CI/CD pipelines (Jenkinsfile)
├── monitoring/          # Prometheus & Grafana configs
├── scripts/             # Automation scripts
└── README.md
🔄 CI/CD Pipeline

The pipeline follows a structured multi-stage process:

Source Code (GitHub + GitFlow)
Build (Node.js)
Testing (Unit + E2E)
Code Quality (SonarQube)
Security Scanning (Snyk)
Containerization (Docker)
Deployment (Kubernetes via Ansible)
Monitoring (Prometheus + Grafana)
🌍 Environments
Environment	Purpose
Dev	Development and initial testing
QA	Functional and integration testing
UAT	Business validation
Production	Live environment
📊 Monitoring & Observability
Prometheus for metrics collection
Grafana for dashboards and visualization
Kubernetes-native monitoring approach
Alerts configured for production workloads
📘 Documentation

Docs-as-Code implemented using MkDocs:

Architecture Decisions (ADR)
Environment Matrix
CI/CD Pipeline
Runbooks

Run locally:

cd docs
docker compose up docs-dev

Production mode:

docker compose up docs-prod --build
🎯 Key Features
Automated end-to-end delivery pipeline
Scalable Kubernetes deployment
Secure and quality-gated releases
Infrastructure reproducibility
Real-time monitoring and alerting
Operational runbooks for incident handling
💼 Author

Kenechukwu Anyaragbu
DevOps Engineer

🔥 Project Status

In Progress — Building a full DevOps lifecycle platform with automation, security, and observability.

