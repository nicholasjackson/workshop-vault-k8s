#!/bin/bash -e

vault policy write demo-policy - <<EOF
path "secret/data/demo/*" {
  capabilities = ["read", "list"]
}

path "database/creds/demo-role" {
  capabilities = ["read"]
}
EOF
