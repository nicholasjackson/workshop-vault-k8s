#!/bin/bash -e

# Check if the demo-app role exists in Vault
vault read auth/kubernetes/role/demo-app > /dev/null 2>&1
