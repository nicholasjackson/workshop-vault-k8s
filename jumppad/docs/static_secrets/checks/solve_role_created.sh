#!/bin/bash -e

vault write auth/kubernetes/role/demo-app \
  bound_service_account_names=demo-app \
  bound_service_account_namespaces=default \
  policies=demo-policy \
  ttl=1h
