#!/bin/bash -e

validate history contains "kubectl get secret vault-token-reviewer-token -o jsonpath='{.data.token}' | base64 -d"