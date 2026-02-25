#!/usr/bin/env bash
# Bootstrap script: installs ArgoCD and configures App of Apps
# Run this ONCE after merging the PR that sets up the kubernetes/ structure.
# After this, all future changes go through PRs — ArgoCD handles the deployment.

set -euo pipefail

ARGOCD_VERSION="${ARGOCD_VERSION:-v2.14.2}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing ArgoCD ${ARGOCD_VERSION}..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f "https://raw.githubusercontent.com/argoproj/argo-cd/${ARGOCD_VERSION}/manifests/install.yaml"

echo "⏳ Waiting for ArgoCD to be ready (up to 5 minutes)..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s

echo "🔧 Applying ArgoCD project..."
kubectl apply -f "${SCRIPT_DIR}/project.yaml"

echo "🌳 Applying App of Apps (root)..."
kubectl apply -f "${SCRIPT_DIR}/root-app.yaml"

echo ""
echo "✅ ArgoCD installed and configured."
echo ""
echo "📡 Access the UI:"
echo "   kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "   https://localhost:8080"
echo ""
echo "🔑 Initial admin password:"
echo "   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo"
echo ""
echo "ArgoCD will now sync all apps from: kubernetes/argocd/apps/"
