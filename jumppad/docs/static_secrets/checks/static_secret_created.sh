#!/bin/bash -e

# Check if the VaultStaticSecret resource exists
kubectl get vaultstaticsecret demo-secret -n default > /dev/null 2>&1
