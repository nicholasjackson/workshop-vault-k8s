#!/bin/bash -e

# Check if the database secrets engine is enabled
vault secrets list | grep -q "^database/"
