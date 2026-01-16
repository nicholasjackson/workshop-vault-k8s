#!/bin/bash -e

vault policy write demo-policy - <<EOF
path "secret/data/demo/config" {
  capabilities = ["read"]
}
EOF
