#!/bin/bash -e

# Check that the user has tested authentication by looking for the login command in history
validate history contains "vault write auth/kubernetes/login"
