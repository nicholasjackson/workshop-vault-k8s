#!/bin/bash -e

vault kv get secret/demo/config > /dev/null 2>&1
