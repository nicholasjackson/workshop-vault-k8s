#!/bin/bash -e

# Check if the PostgreSQL connection is configured
vault read database/config/demo-db > /dev/null 2>&1
