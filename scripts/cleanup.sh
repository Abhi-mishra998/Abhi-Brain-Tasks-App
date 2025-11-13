#!/bin/bash
set -e  # Exit on any error

# Add Lambda layer binaries to PATH
export PATH=/opt/bin:$PATH

echo "Cleaning up old deployment (if exists)..."

# Delete old deployment and service if they exist
kubectl delete -f /tmp/app/deployment.yaml --ignore-not-found
kubectl delete -f /tmp/app/service.yaml --ignore-not-found

echo "Cleanup completed!"
