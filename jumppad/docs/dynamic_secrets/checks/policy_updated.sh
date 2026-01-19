#!/bin/bash -e

# Check if the demo-policy includes database credentials path
vault policy read demo-policy | grep -q "database/creds/demo-role"
