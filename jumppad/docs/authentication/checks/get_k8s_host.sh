#!/bin/bash -e

validate history contains "kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'"