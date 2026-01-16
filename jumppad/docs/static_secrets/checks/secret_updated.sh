#!/bin/bash -e

# Check that the secret has been updated (version > 1)
VERSION=$(vault kv get -format=json secret/demo/config | jq -r '.data.metadata.version')
if [ "$VERSION" -gt 1 ]; then
  exit 0
else
  exit 1
fi
