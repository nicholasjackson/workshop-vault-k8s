#!/bin/bash -e

kubectl apply -f - <<EOF
apiVersion: secrets.hashicorp.com/v1beta1
kind: VaultAuth
metadata:
  name: demo-auth
  namespace: default
spec:
  vaultConnectionRef: vault
  method: kubernetes
  mount: kubernetes
  kubernetes:
    role: demo-app
    serviceAccount: demo-app
EOF
