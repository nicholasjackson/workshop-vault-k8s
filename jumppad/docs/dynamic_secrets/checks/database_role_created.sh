#!/bin/bash -e

# Check if the database role is configured
vault read database/roles/demo-role > /dev/null 2>&1
