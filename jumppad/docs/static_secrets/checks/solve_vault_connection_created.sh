#!/bin/bash -e

kubectl apply -f - <<EOF
apiVersion: secrets.hashicorp.com/v1beta1
kind: VaultConnection
metadata:
  name: vault
  namespace: default
spec:
  address: http://10.100.0.200:8200
EOF
