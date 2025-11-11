#!/bin/bash
echo "Cleaning up old pods..."
kubectl delete -f k8s/deployment.yaml --ignore-not-found

