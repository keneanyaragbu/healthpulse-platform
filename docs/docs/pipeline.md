# CI/CD Pipeline

This document describes the CI/CD pipeline used to build, test, secure, and deploy the HealthPulse application.

## Pipeline Overview

The pipeline automates the complete software delivery lifecycle from code commit to production deployment.

## Pipeline Stages

### 1. Source Code

- Developers push code to GitHub using GitFlow strategy
- Feature branches are merged into develop via pull requests
- Code is promoted to main for production releases

---

### 2. Build Stage

- Application is built using Node.js
- Command: npm install && npm run build
- Output: dist/ folder

---

### 3. Testing Stage

- Unit tests executed using Vitest
- End-to-end tests executed using Playwright
- Build fails if tests do not pass

---

### 4. Code Quality

- SonarQube scans code for bugs, vulnerabilities, and code smells
- Quality gate must pass before proceeding

---

### 5. Security Scanning

- Snyk scans dependencies for vulnerabilities
- Build fails if critical vulnerabilities are found

---

### 6. Containerization

- Application is packaged using Docker
- Multi-stage Docker build (Node build → Nginx serve)
- Image is pushed to artifact repository (JFrog Artifactory)

---

### 7. Deployment

- Deployment managed using Ansible and Kubernetes
- Application deployed to k3s cluster
- Rolling updates ensure zero downtime

---

### 8. Monitoring

- Prometheus collects metrics from nodes and containers
- Grafana visualizes system performance
- Alerts configured for failures and performance issues

---

## Deployment Flow

Dev → QA → UAT → Production

---

## Approval Gates

- Manual approval required before production deployment
- Ensures controlled and secure release process

---

## Rollback Strategy

- Previous stable version retained in the system
- Rollback triggered via Ansible or Kubernetes
- Health checks verify system stability after rollback

