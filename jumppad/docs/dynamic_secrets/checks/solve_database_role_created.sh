#!/bin/bash -e

vault write database/roles/demo-role \
  db_name="demo-db" \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="60s" \
  max_ttl="120s"
