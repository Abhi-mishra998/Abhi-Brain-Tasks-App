#!/bin/bash
set -e

echo "Cleaning up old deployment (if exists)..."

# Delete old deployment and service if they exist
kubectl delete -f /home/ubuntu/brain-task-app/deployment.yaml --ignore-not-found
kubectl delete -f /home/ubuntu/brain-task-app/service.yaml --ignore-not-found

echo "Cleanup completed!"

