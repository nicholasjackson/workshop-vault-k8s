#!/bin/bash -e

# Get the service account JWT
SA_JWT=$(kubectl get secret demo-app-token -o jsonpath='{.data.token}' | base64 -d)

# Test authentication with Vault
vault write auth/kubernetes/login role=demo-app jwt=$SA_JWT
