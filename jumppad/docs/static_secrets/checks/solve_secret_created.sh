#!/bin/bash -e

vault kv put secret/demo/config \
  username="demo-user" \
  password="demo-password" \
  api_key="my-api-key-12345" || true
