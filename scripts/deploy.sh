#!/bin/bash
set -e

# Add Lambda layer binaries to PATH
export PATH=/opt/bin:$PATH

echo "Starting deployment to EKS cluster..."

# Update kubeconfig for your EKS cluster
aws eks update-kubeconfig --region ap-south-1 --name brain-task-cluster

# Apply Kubernetes manifests
kubectl apply -f /tmp/app/deployment.yaml
kubectl apply -f /tmp/app/service.yaml

echo "Deployment completed successfully!"
