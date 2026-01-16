#!/bin/bash -e

# Check if the Kubernetes secret was created by VSO
kubectl get secret demo-app-secret -n default > /dev/null 2>&1
