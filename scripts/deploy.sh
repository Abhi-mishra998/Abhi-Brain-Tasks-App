#!/bin/bash
echo "Deploying to EKS cluster..."
aws eks update-kubeconfig --region ap-south-1 --name brain-task-cluster
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
echo "Deployment completed successfully!"

