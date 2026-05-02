# HealthPulse DevOps Platform

## Project Overview

HealthPulse Portal is a healthcare technology platform built as a React and TypeScript single-page application.

The original deployment process was manual, slow, and error-prone. Developers built the application locally, copied the `dist/` folder to an Nginx server, and restarted the service manually.

This DevOps platform modernizes the delivery process by introducing automation, infrastructure as code, containerization, Kubernetes orchestration, security checks, and observability.

## Business Problem

The previous deployment process created several operational risks:

- Manual deployments took approximately 45 minutes per release
- Misconfigurations caused production outages
- No automated testing or quality checks existed before deployment
- No security scanning was integrated into the release process
- Monitoring and alerting were not available for proactive incident response

## DevOps Solution

This platform introduces:

- Docs-as-Code using MkDocs
- CI/CD automation
- Terraform-based infrastructure provisioning
- Docker-based application packaging
- Kubernetes deployment using k3s
- Prometheus and Grafana monitoring
- GitFlow branching with repository security controls

## Team Roles

| Role | Responsibility |
|------|----------------|
| DevOps Engineer | Infrastructure, CI/CD, Kubernetes, monitoring, documentation |
| Application Team | React application development and testing |
| Security Reviewer | Repository security, dependency scanning, quality gates |
| Operations Reviewer | Runbooks, incident response, SLA validation |

## Quick Links

- Architecture Decisions
- Environment Matrix
- CI/CD Pipeline
- Runbooks
