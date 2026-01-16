#!/bin/bash -e

# Check if the VaultConnection resource exists
kubectl get vaultconnection vault -n default > /dev/null 2>&1
