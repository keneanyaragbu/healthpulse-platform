# Runbooks

Runbooks provide standard operating procedures for common production activities and incidents.

---

## Runbook 1: Deploy New Application Version

### When to Use
Use when a new approved version is ready for deployment.

### Steps
1. Confirm pull request is approved and merged.
2. Verify CI pipeline completed successfully.
3. Confirm code quality and security checks passed.
4. Approve deployment to target environment.
5. Monitor deployment rollout.
6. Verify application health.

### Commands
```bash
curl http://<application-url>/health

Expected:

{"status":"healthy"}
Runbook 2: Rollback Deployment
When to Use

Use when deployment causes errors or instability.

Steps
Identify failing version.
Trigger rollback.
Verify previous version is restored.
Confirm system health.
Review monitoring dashboards.
Commands
kubectl rollout undo deployment/healthpulse-portal -n healthpulse-prod
kubectl rollout status deployment/healthpulse-portal -n healthpulse-prod
Runbook 3: Scale Application
When to Use

Use during high traffic or performance degradation.

Steps
Check system metrics.
Scale application.
Verify pods.
Monitor system stability.
Commands
kubectl scale deployment healthpulse-portal --replicas=5 -n healthpulse-prod
kubectl get pods -n healthpulse-prod
Runbook 4: Incident Response
When to Use

Use when application is down or unhealthy.

Steps
Check application health.
Inspect Kubernetes pods.
Review logs.
Check monitoring dashboards.
Identify root cause.
Apply fix or rollback.
Document incident.
Commands
kubectl get pods -n healthpulse-prod
kubectl logs deployment/healthpulse-portal -n healthpulse-prod
kubectl describe deployment healthpulse-portal -n healthpulse-prod

