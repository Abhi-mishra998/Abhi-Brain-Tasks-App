#!/bin/bash
set -e  # Exit immediately if a command fails

echo "Starting deployment to EKS cluster..."

# Update kubeconfig for your EKS cluster
aws eks update-kubeconfig --region ap-south-1 --name brain-task-cluster

# Apply Kubernetes manifests
kubectl apply -f /home/ubuntu/brain-task-app/deployment.yaml
kubectl apply -f /home/ubuntu/brain-task-app/service.yaml

echo "Deployment completed successfully!"

