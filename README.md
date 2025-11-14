# Brain Tasks App - AWS EKS Deployment with Lambda-based CI/CD

A production-ready static web application deployed on AWS EKS (Elastic Kubernetes Service) with an automated CI/CD pipeline using AWS CodePipeline, CodeBuild, CodeDeploy, and Lambda functions for Kubernetes orchestration.

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Local Development Setup](#local-development-setup)
- [Docker Configuration](#docker-configuration)
- [AWS ECR Setup](#aws-ecr-setup)
- [EKS Cluster Setup](#eks-cluster-setup)
- [Lambda Function for Kubernetes Deployment](#lambda-function-for-kubernetes-deployment)
- [Kubernetes Manifests](#kubernetes-manifests)
- [CI/CD Pipeline Configuration](#cicd-pipeline-configuration)
- [Deployment Scripts](#deployment-scripts)
- [Deployment Process](#deployment-process)
- [Monitoring and Troubleshooting](#monitoring-and-troubleshooting)
- [Application Access](#application-access)
- [Common Issues and Solutions](#common-issues-and-solutions)
- [Version Control Workflow](#version-control-workflow)
- [Cost Optimization](#cost-optimization)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Project Overview

Brain Tasks App is a lightweight static web application served using Nginx, demonstrating enterprise-level DevOps practices:

- **Containerization**: Dockerized Nginx-based static site
- **Container Registry**: AWS ECR for secure image storage
- **Orchestration**: Kubernetes deployment on AWS EKS
- **CI/CD Automation**: CodePipeline → CodeBuild → CodeDeploy
- **Serverless Deployment**: Lambda function for kubectl operations
- **High Availability**: Multi-replica deployment with LoadBalancer

## 🏗️ Architecture

```
GitHub Repository
      ↓
AWS CodePipeline (Trigger on push)
      ↓
AWS CodeBuild (buildspec.yml)
      ↓
Build Docker Image
      ↓
Push to AWS ECR
      ↓
AWS CodeDeploy (appspec.yml)
      ↓
Trigger Lambda Function
      ↓
Lambda executes kubectl commands
      ↓
Deploy to EKS Cluster
      ↓
LoadBalancer Service (Public Access)
```

## 📦 Prerequisites

### Required Software

- **AWS CLI** (v2.x or higher)
- **Docker** (v20.10 or higher)
- **kubectl** (v1.21 or higher)
- **eksctl** (for EKS cluster management)
- **Git**
- **Node.js/npm** (if modifying static content)

### AWS Account Requirements

- IAM user with permissions for:
  - ECR (Full Access)
  - EKS (Cluster management)
  - CodePipeline, CodeBuild, CodeDeploy
  - Lambda (Create and execute functions)
  - CloudWatch Logs
  - IAM (Create roles for services)

### AWS Services Used

- **Amazon ECR**: Container image registry
- **Amazon EKS**: Kubernetes cluster (1.28+)
- **AWS Lambda**: Serverless kubectl execution
- **AWS CodePipeline**: CI/CD orchestration
- **AWS CodeBuild**: Docker image building
- **AWS CodeDeploy**: Deployment automation
- **Amazon CloudWatch**: Logging and monitoring

## 📁 Project Structure

```
brain-task-app/
├── dist/                      # Static website files (HTML, CSS, JS)
├── scripts/
│   ├── cleanup.sh            # Pre-deployment cleanup script
│   └── deploy.sh             # Lambda deployment script
├── Dockerfile                # Docker configuration for Nginx
├── buildspec.yml             # CodeBuild build specification
├── appspec.yml               # CodeDeploy deployment specification
├── deployment.yaml           # Kubernetes Deployment manifest
├── service.yaml              # Kubernetes Service manifest (LoadBalancer)
├── lambda_function.py        # Lambda handler for kubectl operations
├── kubectl                   # kubectl binary (Linux AMD64)
├── package-lock.json         # npm lock file
└── README.md                 # Project documentation
```

## 🚀 Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/brain-task-app.git
cd brain-task-app
```

### 2. Verify Project Structure

```bash
ls -la
# Ensure dist/, scripts/, Dockerfile, and YAML files are present
```

### 3. Test Static Files Locally

If you have Python installed:

```bash
cd dist
python3 -m http.server 8080
```

Access at: `http://localhost:8080`

## 🐳 Docker Configuration

### Dockerfile Explanation

```dockerfile
# Step 1: Use official Nginx image (Alpine for minimal size)
FROM nginx:alpine

# Step 2: Copy static files from dist folder to Nginx html directory
COPY dist /usr/share/nginx/html

# Step 3: Expose port 80 (default HTTP port)
EXPOSE 80

# Step 4: Start Nginx server in foreground
CMD ["nginx", "-g", "daemon off;"]
```

**Why this approach?**
- **Alpine Linux**: Minimal image size (~23MB vs ~140MB for standard Nginx)
- **Static Content**: No Node.js runtime needed in production
- **Nginx**: Battle-tested, high-performance web server
- **Simple**: No complex build steps, just copy and serve

### Build Docker Image Locally

```bash
# Build the image
docker build -t brain-task-app .

# Verify image was created
docker images | grep brain-task-app
```

### Test Docker Container Locally

```bash
# Run container
docker run -d -p 8080:80 --name brain-task-test brain-task-app

# Test in browser
curl http://localhost:8080

# View logs
docker logs brain-task-test

# Stop and remove container
docker stop brain-task-test
docker rm brain-task-test
```

## ☁️ AWS ECR Setup

### 1. Create ECR Repository

```bash
aws ecr create-repository \
    --repository-name brain-task-app \
    --region ap-south-1 \
    --image-scanning-configuration scanOnPush=true
```

**Expected Output:**
```json
{
    "repository": {
        "repositoryArn": "arn:aws:ecr:ap-south-1:323997748732:repository/brain-task-app",
        "registryId": "323997748732",
        "repositoryName": "brain-task-app",
        "repositoryUri": "323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app"
    }
}
```

### 2. Authenticate Docker to ECR

```bash
aws ecr get-login-password --region ap-south-1 | \
docker login --username AWS --password-stdin 323997748732.dkr.ecr.ap-south-1.amazonaws.com
```

**Expected Output:**
```
Login Succeeded
```

### 3. Tag Docker Image

```bash
docker tag brain-task-app:latest \
323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
```

### 4. Push Image to ECR

```bash
docker push 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
```

### 5. Verify Image in ECR

```bash
aws ecr describe-images \
    --repository-name brain-task-app \
    --region ap-south-1
```

## ⚓ EKS Cluster Setup

### 1. Create EKS Cluster

```bash
eksctl create cluster \
    --name brain-task-cluster \
    --region ap-south-1 \
    --nodegroup-name standard-workers \
    --node-type t3.medium \
    --nodes 2 \
    --nodes-min 2 \
    --nodes-max 4 \
    --managed
```

**Note**: This process takes 15-20 minutes.

### 2. Verify Cluster Creation

```bash
# Check cluster status
aws eks describe-cluster --name brain-task-cluster --region ap-south-1 --query cluster.status

# Update local kubeconfig
aws eks update-kubeconfig --name brain-task-cluster --region ap-south-1

# Test connection
kubectl get nodes
```

**Expected Output:**
```
NAME                                           STATUS   ROLES    AGE   VERSION
ip-192-168-xx-xx.ap-south-1.compute.internal   Ready    <none>   5m    v1.28.x
ip-192-168-yy-yy.ap-south-1.compute.internal   Ready    <none>   5m    v1.28.x
```

### 3. Create Namespace (Optional)

```bash
kubectl create namespace brain-tasks
```

## 🔧 Lambda Function for Kubernetes Deployment

### Why Lambda for kubectl?

Traditional approaches require a bastion host or Jenkins for kubectl commands. Using Lambda provides:
- **Serverless**: No server maintenance
- **Cost-effective**: Pay only for execution time
- **Secure**: IAM-based authentication
- **Scalable**: Automatic scaling

### Lambda Function Structure

**lambda_function.py** (Python 3.9+)

```python
import os
import boto3
import subprocess

def lambda_handler(event, context):
    """
    Lambda handler to deploy Kubernetes manifests to EKS
    """
    # Paths
    aws_cli = "/opt/bin/aws"
    kubectl = "/tmp/app/kubectl"
    kubeconfig = "/tmp/.kube/config"
    
    # Create kubeconfig directory
    os.makedirs(os.path.dirname(kubeconfig), exist_ok=True)
    
    # Update kubeconfig for EKS
    subprocess.run([
        aws_cli, "eks", "update-kubeconfig",
        "--region", "ap-south-1",
        "--name", "brain-task-cluster",
        "--kubeconfig", kubeconfig
    ], check=True)
    
    # Apply Kubernetes manifests
    subprocess.run([
        kubectl, "--kubeconfig", kubeconfig,
        "apply", "--validate=false", "-f", "/tmp/app/deployment.yaml"
    ], check=True)
    
    subprocess.run([
        kubectl, "--kubeconfig", kubeconfig,
        "apply", "--validate=false", "-f", "/tmp/app/service.yaml"
    ], check=True)
    
    return {
        'statusCode': 200,
        'body': 'Deployment successful!'
    }
```

### Lambda Deployment Package Structure

```
lambda-kubectl/
├── lambda_function.py
├── kubectl (binary)
└── awscli-layer/ (AWS CLI v2)
```

### Create Lambda Function

```bash
# Create deployment package
cd /home/ubuntu/brain-task-app
zip -r lambda-deployment.zip lambda_function.py kubectl deployment.yaml service.yaml

# Create Lambda function
aws lambda create-function \
    --function-name brain-task-eks-deployer \
    --runtime python3.9 \
    --role arn:aws:iam::323997748732:role/lambda-eks-deployer-role \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://lambda-deployment.zip \
    --timeout 300 \
    --memory-size 512 \
    --region ap-south-1
```

### Lambda IAM Role Requirements

Create IAM role with these policies:
- `AmazonEKSClusterPolicy`
- `AmazonEKSWorkerNodePolicy`
- `AWSLambdaBasicExecutionRole`

## 📝 Kubernetes Manifests

### deployment.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: brain-tasks-deployment
  labels:
    app: brain-tasks
spec:
  replicas: 2  # High availability with 2 replicas
  selector:
    matchLabels:
      app: brain-tasks
  template:
    metadata:
      labels:
        app: brain-tasks
    spec:
      containers:
      - name: brain-tasks-container
        image: 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
```

### service.yaml

```yaml
apiVersion: v1
kind: Service
metadata:
  name: brain-tasks-service
  labels:
    app: brain-tasks
spec:
  type: LoadBalancer  # Creates AWS Classic Load Balancer
  selector:
    app: brain-tasks
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      name: http
  sessionAffinity: None
```

**LoadBalancer Service Features:**
- Automatically provisions AWS Elastic Load Balancer
- Public IP address for external access
- Health checks to pods
- Distributes traffic across replicas

## 🔄 CI/CD Pipeline Configuration

### buildspec.yml

```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 323997748732.dkr.ecr.ap-south-1.amazonaws.com

  build:
    commands:
      - echo Build started on `date`
      - echo Building Docker image...
      - docker build -t brain-task-app .
      - docker tag brain-task-app:latest 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing Docker image to ECR...
      - docker push 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
      - echo Writing image definitions file...
      - printf '[{"name":"brain-task-container","imageUri":"323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest"}]' > imagedefinitions.json

artifacts:
  files:
    - imagedefinitions.json
    - deployment.yaml
    - service.yaml
    - scripts/**/*
```

**Build Process:**
1. **Pre-build**: Authenticate with ECR
2. **Build**: Create Docker image from Dockerfile
3. **Post-build**: Push image to ECR and create artifacts

### appspec.yml

```yaml
version: 0.0
Resources:
  - myEKSApp:
      Type: AWS::EKS::Application
      Properties:
        ClusterName: brain-task-cluster
        Namespace: default
hooks:
  BeforeInstall:
    - location: scripts/cleanup.sh
      timeout: 300
      runas: root
  AfterInstall:
    - location: scripts/deploy.sh
      timeout: 600
      runas: root
```

**Deployment Hooks:**
- **BeforeInstall**: Cleanup old deployments
- **AfterInstall**: Deploy new version to EKS

## 📜 Deployment Scripts

### scripts/cleanup.sh

```bash
#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# --- Paths for Lambda ---
AWS="/opt/bin/aws"         # AWS CLI path from Lambda layer
KUBECTL="/tmp/app/kubectl" # kubectl binary from deployment package
KUBECONFIG="/tmp/.kube/config" # Temporary kubeconfig location

# --- Ensure tmp .kube directory exists ---
mkdir -p $(dirname $KUBECONFIG)

echo "🧹 Cleaning up old deployment (if exists)..."
$KUBECTL --kubeconfig $KUBECONFIG delete -f /tmp/app/deployment.yaml --ignore-not-found || true
$KUBECTL --kubeconfig $KUBECONFIG delete -f /tmp/app/service.yaml --ignore-not-found || true
echo "✅ Cleanup completed!"
```

**Purpose**: Remove existing deployments to avoid conflicts

### scripts/deploy.sh

```bash
#!/bin/bash
set -e  # Exit on error

echo "🚀 Starting deployment to EKS cluster..."

# --- Paths ---
AWS="/opt/bin/aws"
KUBECTL="/tmp/app/kubectl"
KUBECONFIG="/tmp/.kube/config"

# --- Ensure directory exists ---
mkdir -p $(dirname $KUBECONFIG)

# --- Update kubeconfig for EKS cluster ---
echo "📝 Updating kubeconfig..."
$AWS eks update-kubeconfig --region ap-south-1 --name brain-task-cluster --kubeconfig $KUBECONFIG

# --- Apply Kubernetes manifests ---
echo "⚙️  Applying deployment manifest..."
$KUBECTL --kubeconfig $KUBECONFIG apply --validate=false -f /tmp/app/deployment.yaml

echo "⚙️  Applying service manifest..."
$KUBECTL --kubeconfig $KUBECONFIG apply --validate=false -f /tmp/app/service.yaml

# --- Verify deployment ---
echo "🔍 Verifying deployment status..."
$KUBECTL --kubeconfig $KUBECONFIG get deployments
$KUBECTL --kubeconfig $KUBECONFIG get pods
$KUBECTL --kubeconfig $KUBECONFIG get services

echo "🎉 Deployment completed successfully!"
```

**Key Features:**
- EKS authentication via AWS CLI
- Skip validation to avoid localhost OpenAPI errors
- Deployment verification
- Detailed logging

## 🚀 Deployment Process

### Automated Deployment Flow

1. **Developer pushes code** to GitHub repository
2. **CodePipeline detects** the commit (webhook trigger)
3. **CodeBuild executes** buildspec.yml:
   - Authenticates with ECR
   - Builds Docker image
   - Pushes image to ECR
   - Creates artifacts
4. **CodeDeploy triggers** deployment:
   - Executes BeforeInstall hook (cleanup.sh)
   - Invokes Lambda function
   - Lambda updates EKS cluster
   - Executes AfterInstall hook (deploy.sh)
5. **EKS updates** running pods with new image
6. **LoadBalancer** routes traffic to new pods

### Manual Deployment (For Testing)

#### Step 1: Build and Push Image

```bash
cd /home/ubuntu/brain-task-app

# Build image
docker build -t brain-task-app .

# Tag for ECR
docker tag brain-task-app:latest 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest

# Push to ECR
docker push 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
```

#### Step 2: Deploy to EKS

```bash
# Update kubeconfig
aws eks update-kubeconfig --name brain-task-cluster --region ap-south-1

# Apply manifests
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Watch deployment progress
kubectl rollout status deployment/brain-tasks-deployment
```

#### Step 3: Verify Deployment

```bash
# Check pods
kubectl get pods -l app=brain-tasks

# Check service
kubectl get svc brain-tasks-service

# View pod logs
kubectl logs -l app=brain-tasks --tail=50
```

### Rolling Update Strategy

Kubernetes automatically performs rolling updates:
- New pods are created before old ones are terminated
- Zero-downtime deployment
- Automatic rollback on failure

## 📊 Monitoring and Troubleshooting

### AWS CloudWatch Logs

#### CodeBuild Logs

```bash
# View recent builds
aws codebuild list-builds-for-project --project-name brain-task-build

# Tail logs
aws logs tail /aws/codebuild/brain-task-build --follow
```

#### Lambda Logs

```bash
# View Lambda execution logs
aws logs tail /aws/lambda/brain-task-eks-deployer --follow

# Filter errors
aws logs filter-log-events \
    --log-group-name /aws/lambda/brain-task-eks-deployer \
    --filter-pattern "ERROR"
```

### Kubernetes Monitoring

#### Check Deployment Status

```bash
# View all resources
kubectl get all -l app=brain-tasks

# Detailed deployment info
kubectl describe deployment brain-tasks-deployment

# Check replica sets
kubectl get rs -l app=brain-tasks
```

#### Pod Troubleshooting

```bash
# View pod status
kubectl get pods -l app=brain-tasks -o wide

# Check pod logs
kubectl logs -f deployment/brain-tasks-deployment

# Describe pod for events
kubectl describe pod <pod-name>

# Execute commands in pod
kubectl exec -it <pod-name> -- /bin/sh
```

#### Service Debugging

```bash
# Check service endpoints
kubectl get endpoints brain-tasks-service

# Describe service
kubectl describe svc brain-tasks-service

# Test internal connectivity
kubectl run test-pod --image=busybox --rm -it -- wget -O- http://brain-tasks-service
```

### Common kubectl Commands

```bash
# View events
kubectl get events --sort-by='.lastTimestamp'

# Check resource usage
kubectl top nodes
kubectl top pods

# View deployment history
kubectl rollout history deployment/brain-tasks-deployment

# Rollback deployment
kubectl rollout undo deployment/brain-tasks-deployment

# Scale deployment
kubectl scale deployment brain-tasks-deployment --replicas=3
```

## 🌐 Application Access

### Get LoadBalancer URL

```bash
kubectl get service brain-tasks-service
```

**Example Output:**
```
NAME                   TYPE           EXTERNAL-IP                                                               PORT(S)        AGE
brain-tasks-service    LoadBalancer   a1b2c3d4e5f6-1234567890.ap-south-1.elb.amazonaws.com                    80:31234/TCP   5m
```

### Access Application

**URL Format:**
```
http://<EXTERNAL-IP>
```

**Example:**
```
http://a1b2c3d4e5f6-1234567890.ap-south-1.elb.amazonaws.com
```

### Test LoadBalancer

```bash
# Using curl
curl http://<EXTERNAL-IP>

# Check response time
time curl -s http://<EXTERNAL-IP> > /dev/null
```

### DNS Setup (Optional)

You can create a CNAME record in Route 53:
```
brain-tasks.yourdomain.com -> <LoadBalancer-DNS>
```

## ❗ Common Issues and Solutions

### Issue 1: Image Pull Error

**Symptom:**
```
Failed to pull image: unauthorized
```

**Solution:**
```bash
# Update ECR permissions
aws ecr set-repository-policy \
    --repository-name brain-task-app \
    --policy-text file://ecr-policy.json
```

### Issue 2: LoadBalancer Pending

**Symptom:**
```
EXTERNAL-IP: <pending>
```

**Solution:**
```bash
# Check AWS Load Balancer Controller
kubectl get pods -n kube-system | grep aws-load-balancer

# Verify security groups allow port 80
aws ec2 describe-security-groups --group-ids <sg-id>
```

### Issue 3: Pods CrashLoopBackOff

**Symptom:**
```
STATUS: CrashLoopBackOff
```

**Solution:**
```bash
# Check logs
kubectl logs <pod-name> --previous

# Verify image exists
aws ecr describe-images --repository-name brain-task-app
```

### Issue 4: Lambda Timeout

**Symptom:**
```
Task timed out after 300.00 seconds
```

**Solution:**
```bash
# Increase Lambda timeout
aws lambda update-function-configuration \
    --function-name brain-task-eks-deployer \
    --timeout 600
```

### Issue 5: kubectl Command Not Found in Lambda

**Symptom:**
```
/tmp/app/kubectl: No such file or directory
```

**Solution:**
- Ensure kubectl binary is included in Lambda deployment package
- Verify file permissions: `chmod +x kubectl`
- Check Lambda /tmp directory limits (512MB max)

## 📝 Version Control Workflow

### Feature Development

```bash
# Create feature branch
git checkout -b feature/new-feature

# Make changes to dist/ folder
# Edit static files

# Test locally
cd dist && python3 -m http.server 8080

# Commit changes
git add .
git commit -m "feat: add new feature to landing page"

# Push to GitHub
git push origin feature/new-feature
```

### Code Review Process

1. Create Pull Request on GitHub
2. Wait for CI/CD checks to pass
3. Request review from team
4. Merge to main branch
5. Automatic deployment triggered

### Git Best Practices

```bash
# Always pull before starting work
git pull origin main

# Use meaningful commit messages
git commit -m "fix: resolve nginx configuration issue"

# Tag releases
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# View commit history
git log --oneline --graph --all
```

### Branching Strategy

```
main (production)
  ↓
develop (staging)
  ↓
feature/xxx (development)
```

## 💰 Cost Optimization

### Estimated Monthly Costs (ap-south-1)

| Service | Configuration | Estimated Cost |
|---------|--------------|----------------|
| EKS Cluster | 1 cluster | $73 |
| EC2 (Nodes) | 2x t3.medium | $60 |
| Load Balancer | Classic LB | $18 |
| ECR Storage | <1GB | $0.10 |
| CodePipeline | 1 pipeline | $1 |
| Lambda | <100 executions/month | Free Tier |
| CloudWatch Logs | <5GB | $2.50 |
| **Total** | | **~$155/month** |

### Cost-Saving Tips

1. **Use Spot Instances** for EKS nodes (50-70% savings)
```bash
eksctl create nodegroup \
    --cluster brain-task-cluster \
    --spot \
    --instance-types t3.medium,t3a.medium
```

2. **Schedule Cluster Downtime** during non-business hours
```bash
# Scale nodes to 0
eksctl scale nodegroup --cluster brain-task-cluster --nodes 0
```

3. **Use ECR Lifecycle Policies** to delete old images
```json
{
  "rules": [{
    "rulePriority": 1,
    "selection": {
      "tagStatus": "untagged",
      "countType": "sinceImagePushed",
      "countUnit": "days",
      "countNumber": 30
    },
    "action": { "type": "expire" }
  }]
}
```

4. **Optimize Docker Image Size**
   - Current: ~25MB (nginx:alpine + static files)
   - Already optimized!

## 🧪 Testing

### Unit Tests (If applicable)

```bash
# Install test dependencies
npm install --save-dev jest

# Run tests
npm test
```

### Integration Tests

```bash
# Test Docker build
docker build -t brain-task-app:test .

# Test container
docker run -d -p 8080:80 brain-task-app:test
curl http://localhost:8080

# Cleanup
docker stop $(docker ps -q --filter ancestor=brain-task-app:test)
```

### Load Testing

```bash
# Install Apache Bench
sudo apt install apache2-utils

# Run load test
ab -n 1000 -c 10 http://<LoadBalancer-URL>/
```

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Code Style

- Use meaningful variable names
- Add comments for complex logic
- Follow Dockerfile best practices
- Keep Kubernetes manifests organized

### Pull Request Process

1. Update README.md with details of changes
2. Ensure CI/CD pipeline passes
3. Request review from maintainers
4. Squash commits before merging

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2024 Abhishek Mishra

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```


## 🙏 Acknowledgments

- AWS EKS Documentation
- Kubernetes Documentation
- Docker Documentation
- Nginx Documentation
- GitHub Actions Community

## 📚 Additional Resources

- [AWS EKS Workshop](https://www.eksworkshop.com/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/configuration/overview/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [AWS CodePipeline Guide](https://docs.aws.amazon.com/codepipeline/)

## 🎉 Try It Yourself!

This project is perfect for learning:
- **Containerization**: Docker fundamentals
- **Orchestration**: Kubernetes on AWS EKS
- **CI/CD**: Automated deployments
- **Cloud Architecture**: AWS services integration
- **DevOps Practices**: Infrastructure as Code

### Quick Start Checklist

- [ ] Clone repository
- [ ] Setup AWS credentials
- [ ] Create ECR repository
- [ ] Build and push Docker image
- [ ] Create EKS cluster
- [ ] Deploy application
- [ ] Setup CI/CD pipeline
- [ ] Test deployment
- [ ] Monitor with CloudWatch

**Happy Deploying! 🚀**

---

**Note**: Replace account IDs, repository names, and URLs with your actual values.

**Project Location**: `/home/ubuntu/brain-task-app/`  
**AWS Region**: `ap-south-1` (Mumbai)  
**AWS Account**: `323997748732`

## 👤 Author

**Abhishek Mishra**

* GitHub: [@Abhi-mishra998](https://github.com/Abhi-mishra998)
* Repository: [Abhi-Brain-Tasks-App](https://github.com/Abhi-mishra998/Abhi-Brain-Tasks-App)
* LinkedIn: [Abhishek Mishra](https://www.linkedin.com/in/abhishek-mishra-49888123b/)

**Project Location:** `/home/ubuntu/brain-task-app/`
**AWS Region:** `ap-south-1` (Mumbai)
**AWS Account ID:** `323997748732`

---


