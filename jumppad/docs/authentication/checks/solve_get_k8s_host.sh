#!/bin/bash -e

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