#!/bin/bash
# ArgoCD install — idempotent, safe to re-run on rebuild
# Adds the GitOps engine to your k3s cluster

set -e

echo "==> Creating argocd namespace..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
# dry-run + apply = create if missing, no error if exists. Idempotent.

echo "==> Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# Deploys all ArgoCD components: API server, repo server, controller, Redis, Dex.

echo "==> Waiting for ArgoCD pods to be ready..."
kubectl wait --for=condition=Ready pods --all -n argocd --timeout=120s
# Blocks until every pod is Running. Fails after 120s if something's stuck.

echo "==> Exposing ArgoCD UI via NodePort..."
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
# Changes from ClusterIP to NodePort so you can hit the UI from your browser.

echo "==> Getting ArgoCD admin password..."
ARGO_PASS=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
ARGO_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[?(@.name=="https")].nodePort}')
echo ""
echo "  ArgoCD UI: https://<MASTER_IP>:${ARGO_PORT}"
echo "  Username:  admin"
echo "  Password:  ${ARGO_PASS}"
echo ""

echo "==> Applying ArgoCD Application manifests..."
kubectl apply -f argocd/applications/
# Deploys all Application CRDs from your repo — one per environment.

echo "==> ArgoCD ready."
