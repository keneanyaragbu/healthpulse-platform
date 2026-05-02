# Environment Matrix

This document defines the environments used in the HealthPulse DevOps platform.

## Overview

The platform uses multiple environments to ensure proper testing, validation, and controlled release of the application.

## Environment Details

| Environment | Purpose | URL | Infrastructure | Notes |
|------------|--------|-----|----------------|------|
| Dev | Development and initial testing | dev.healthpulse.local | Single node (k3s) | Used by developers for feature testing |
| QA | Functional and integration testing | qa.healthpulse.local | 2-node cluster | Used for test validation |
| UAT | Business validation and user acceptance | uat.healthpulse.local | 2-node cluster | Used by stakeholders before release |
| Production | Live system serving real users | healthpulse.com | 3-node cluster | High availability, monitored and secured |

## Environment Flow

Dev → QA → UAT → Production

## Deployment Strategy

- Code is developed and tested in Dev
- Promoted to QA for validation
- Promoted to UAT for business approval
- Deployed to Production after approval

## Access Control

- Dev: Open to development team
- QA: Restricted to QA engineers and DevOps
- UAT: Accessible to business stakeholders
- Production: Restricted, controlled via CI/CD approvals

## Monitoring

- All environments are monitored using Prometheus and Grafana
- Alerts configured for Production environment
- Metrics include CPU, memory, pod health, and response time

