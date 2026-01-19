#!/bin/bash -e

# Check if the VaultDynamicSecret resource exists
kubectl get vaultdynamicsecret demo-db-creds -n default > /dev/null 2>&1
