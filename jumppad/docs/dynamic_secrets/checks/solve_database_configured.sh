#!/bin/bash -e

vault write database/config/demo-db \
  plugin_name="postgresql-database-plugin" \
  allowed_roles="demo-role" \
  connection_url="postgresql://{{username}}:{{password}}@10.100.0.201:5432/demo?sslmode=disable" \
  username="postgres" \
  password="postgres"
