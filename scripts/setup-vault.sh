#!/bin/bash
set -euo pipefail

# Wait for Vault to be ready
until vault status > /dev/null 2>&1; do
  echo "Waiting for Vault to be ready..."
  sleep 2
done

echo "Vault is ready!"

# Enable KV secrets engine v2 (already enabled in dev mode at 'secret/')
# Create a demo secret
echo "Creating demo secret..."
vault kv put secret/demo/config \
  username="demo-user" \
  password="super-secret-password" \
  api_key="abc123xyz"

echo "Demo secret created at secret/demo/config"

# Enable Kubernetes auth method
echo "Enabling Kubernetes auth..."
vault auth enable kubernetes || true

# Create the token reviewer service account and RBAC
echo "Creating token reviewer service account..."
kubectl apply -f - <<EOF
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: vault-token-reviewer
  namespace: default
---
apiVersion: v1
kind: Secret
metadata:
  name: vault-token-reviewer-token
  namespace: default
  annotations:
    kubernetes.io/service-account.name: vault-token-reviewer
type: kubernetes.io/service-account-token
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: vault-token-reviewer-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
  - kind: ServiceAccount
    name: vault-token-reviewer
    namespace: default
EOF

# Wait for the token to be populated
echo "Waiting for token reviewer secret..."
until kubectl get secret vault-token-reviewer-token -o jsonpath='{.data.token}' 2>/dev/null | grep -q .; do
  sleep 1
done

# Get the Kubernetes API server address from kubeconfig
K8S_HOST=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

# Get the CA certificate from the cluster
K8S_CA_CERT=$(kubectl config view --raw --minify -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 -d)

# Get the token reviewer JWT
TOKEN_REVIEWER_JWT=$(kubectl get secret vault-token-reviewer-token -o jsonpath='{.data.token}' | base64 -d)

# Configure Kubernetes auth with the CA cert and token reviewer JWT
echo "Configuring Kubernetes auth..."
vault write auth/kubernetes/config \
  kubernetes_host="${K8S_HOST}" \
  kubernetes_ca_cert="${K8S_CA_CERT}" \
  token_reviewer_jwt="${TOKEN_REVIEWER_JWT}"

# Create a policy for the demo app
echo "Creating demo-app policy..."
vault policy write demo-app - <<EOF
path "secret/data/demo/*" {
  capabilities = ["read", "list"]
}
EOF

# Create a role for the demo app
echo "Creating demo-app role..."
vault write auth/kubernetes/role/demo-app \
  bound_service_account_names=demo-app \
  bound_service_account_namespaces=default \
  policies=demo-app \
  ttl=1h

echo "Vault setup complete!"
echo ""
echo "To test, apply the Kubernetes manifests:"
echo "  kubectl apply -f k8s/"
echo ""
echo "Then check the synced secret:"
echo "  kubectl get secret demo-app-secret -o jsonpath='{.data}' | jq"
