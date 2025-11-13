#!/bin/bash
set -e

echo "Starting deployment to EKS cluster..."

aws eks update-kubeconfig --region ap-south-1 --name brain-task-cluster

kubectl apply -f /tmp/app/deployment.yaml
kubectl apply -f /tmp/app/service.yaml

echo "Deployment completed successfully!"
