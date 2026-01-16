#!/bin/bash -e

kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: demo-app
  namespace: default
---
apiVersion: v1
kind: Secret
metadata:
  name: demo-app-token
  namespace: default
  annotations:
    kubernetes.io/service-account.name: demo-app
type: kubernetes.io/service-account-token
EOF
