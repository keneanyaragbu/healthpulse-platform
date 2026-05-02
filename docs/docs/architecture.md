# Architecture Decisions

This page documents key technical decisions made for the HealthPulse DevOps Platform.

## ADR-001: CI/CD Platform Selection

### Decision

Jenkins was selected as the CI/CD automation platform.

### Context

HealthPulse requires an automated delivery process that can build, test, scan, package, and deploy the React application across multiple environments.

### Why Jenkins

- Supports pipeline-as-code using Jenkinsfile
- Integrates well with Docker, Kubernetes, SonarQube, Snyk, and GitHub
- Allows manual approval gates for controlled production releases
- Provides flexibility for complex enterprise deployment workflows

### Alternatives Considered

| Tool | Reason Not Selected |
|------|---------------------|
| GitHub Actions | Strong option, but Jenkins provides more control for enterprise-style pipelines |
| GitLab CI | Powerful, but requires GitLab-centered workflow |
| Azure DevOps | Good enterprise option, but less aligned with this project stack |

### Impact

Jenkins provides a centralized automation engine for build, test, scan, and deployment stages.

---

## ADR-002: Container Orchestration Selection

### Decision

Kubernetes using k3s on AWS EC2 was selected for container orchestration.

### Context

HealthPulse needs a production-like container orchestration platform that supports scaling, rolling updates, service discovery, and workload management.

### Why k3s

- Lightweight Kubernetes distribution suitable for EC2-based lab and production-style environments
- Provides real Kubernetes experience without the full overhead of EKS
- Supports deployments, services, ingress, HPA, namespaces, and rolling updates
- Easier to provision and destroy using Terraform

### Alternatives Considered

| Tool | Reason Not Selected |
|------|---------------------|
| ECS Fargate | Good AWS-native option, but less Kubernetes-focused |
| EKS | Production-grade managed Kubernetes, but higher cost and complexity |
| Docker Compose | Useful locally, but not suitable for production orchestration |

### Impact

k3s gives the platform Kubernetes-native deployment capability while keeping cost and operational overhead manageable.

---

## ADR-003: Monitoring and Observability Selection

### Decision

Prometheus and Grafana were selected as the primary monitoring and observability stack.

### Context

HealthPulse requires visibility into infrastructure health, application workloads, container metrics, and operational trends.

### Why Prometheus and Grafana

- Kubernetes-native monitoring approach
- Strong support for metrics collection, alerting, and dashboards
- Reduces dependency on SaaS-only monitoring platforms
- Provides practical visibility into nodes, pods, deployments, CPU, memory, and availability
- Commonly used across DevOps and platform engineering teams

### Alternatives Considered

| Tool | Reason Not Selected |
|------|---------------------|
| Datadog | Strong enterprise SaaS option, but introduces external subscription dependency |
| CloudWatch | Useful for AWS metrics, but less flexible for Kubernetes dashboards |
| New Relic | Good observability platform, but SaaS-dependent |

### Impact

Prometheus and Grafana provide portable, Kubernetes-aligned observability across Dev, QA, UAT, and Production environments.
