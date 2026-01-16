#!/bin/bash -e

# Check if the demo-app service account exists
kubectl get serviceaccount demo-app -n default > /dev/null 2>&1
