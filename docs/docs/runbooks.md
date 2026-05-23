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


---

## Runbook 5: Backend CrashLoopBackOff After New Image Release

### When to Use

Use when a newly deployed backend image causes pods to crash or rollout becomes stuck.

### Incident Example

During the HealthPulse backend `v2` rollout, Kubernetes created a new ReplicaSet, but the new backend pod entered `CrashLoopBackOff`.

The old backend pods remained running, which protected application availability during the failed rollout.

### Symptoms

```bash
kubectl rollout status deployment/healthpulse-backend -n healthpulse
kubectl get pods -n healthpulse -o wide

Observed:

0/1 CrashLoopBackOff
Investigation

Check application logs:

kubectl logs <backend-pod-name> -n healthpulse

The logs showed a Node.js syntax error in server.js.

Root Cause

The backend appointments array was missing commas between JavaScript objects.

Fix
Correct the syntax error in app/backend/server.js.
Build a new immutable Docker image tag.
Push the image to Docker Hub.
Update the Kubernetes Deployment manifest.
Apply the manifest.
Verify rollout and API health.
Recovery Commands
docker build -t keneanyaragbu/healthpulse-backend:v3 app/backend
docker push keneanyaragbu/healthpulse-backend:v3

kubectl apply -f terraform/k3s/k8s/backend/deployment.yml
kubectl rollout status deployment/healthpulse-backend -n healthpulse
kubectl get pods -n healthpulse -o wide
Validation

Internal Service test:

kubectl run backend-test \
  -n healthpulse \
  --image=curlimages/curl \
  --restart=Never \
  --attach \
  --rm \
  -- curl -s http://healthpulse-backend:3000/api/health

Ingress test:

curl http://healthpulse.local/api/health
curl http://healthpulse.local/api/appointments
Lessons Learned
kubectl logs helps diagnose application-level failures.
kubectl describe pod helps diagnose Kubernetes object issues such as probes, scheduling, image pulls, and events.
Rolling updates protect availability because old healthy pods remain running while new pods are tested.
Immutable image tags like v3 are safer than overwriting a broken v2 tag.
Kubernetes Service ports must be tested with the correct port, such as healthpulse-backend:3000.

