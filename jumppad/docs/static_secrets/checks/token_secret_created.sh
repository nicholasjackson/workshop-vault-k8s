#!/bin/bash -e

# Check if the demo-app-token secret exists
kubectl get secret demo-app-token -n default > /dev/null 2>&1
