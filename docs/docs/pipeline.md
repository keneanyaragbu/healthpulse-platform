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


---

## HealthPulse Real CI/CD Implementation Plan

### Current CI/CD Tooling

The HealthPulse platform will integrate with existing EC2-hosted DevOps tools:

- Jenkins for pipeline orchestration
- SonarQube for static code analysis and quality gates
- Snyk for dependency and container vulnerability scanning
- Artifactory for artifact/image storage
- Docker for image builds
- Kubernetes/k3s for application deployment
- Prometheus and Grafana for post-deployment monitoring

### Current Kubernetes Workloads

The application currently runs in the `healthpulse` namespace:

- `healthpulse-web` frontend deployment with 3 replicas
- `healthpulse-backend` backend deployment with 2 replicas

### Backend CI/CD Flow

1. Developer pushes backend changes to GitHub.
2. Jenkins pulls the latest source code.
3. Jenkins installs backend dependencies.
4. SonarQube scans backend source code.
5. Snyk scans backend dependencies.
6. Jenkins builds a Docker image for the backend.
7. Snyk scans the container image.
8. Jenkins pushes the approved image to the artifact registry.
9. Jenkins updates or applies the Kubernetes backend manifest.
10. Kubernetes performs a rolling update.
11. Jenkins verifies rollout status.
12. Jenkins validates `/api/health` through the Ingress route.

### Frontend CI/CD Flow

1. Developer pushes frontend changes to GitHub.
2. Jenkins pulls the latest source code.
3. Jenkins installs frontend dependencies.
4. Frontend tests and build are executed.
5. SonarQube scans frontend source code.
6. Snyk scans frontend dependencies.
7. Jenkins builds the frontend Docker image.
8. Jenkins pushes the approved image to the artifact registry.
9. Jenkins deploys the updated frontend manifest.
10. Kubernetes rolls out the `healthpulse-web` deployment.
11. Jenkins validates frontend availability through Ingress.

### Deployment Strategy

HealthPulse uses Kubernetes rolling updates.

This allows Kubernetes to gradually replace old pods with new pods while keeping healthy pods available during deployment.

If a new release fails readiness checks, Kubernetes prevents the failed pods from receiving traffic.

### Release Safety Controls

The pipeline should fail if any of the following occurs:

- tests fail
- SonarQube quality gate fails
- Snyk detects critical vulnerabilities
- Docker image build fails
- image push fails
- Kubernetes rollout fails
- `/api/health` validation fails

### Planned Pipeline Stages

```text
Checkout
  → Install Dependencies
  → Unit Tests
  → SonarQube Scan
  → SonarQube Quality Gate
  → Snyk Dependency Scan
  → Docker Build
  → Snyk Container Scan
  → Push Image to Registry
  → Deploy to k3s
  → Verify Rollout
  → Validate Application Health

