#!/bin/bash -e

# Check if the demo-policy exists in Vault
vault policy read demo-policy > /dev/null 2>&1
