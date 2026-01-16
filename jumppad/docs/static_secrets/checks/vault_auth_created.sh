#!/bin/bash -e

# Check if the VaultAuth resource exists
kubectl get vaultauth demo-auth -n default > /dev/null 2>&1
