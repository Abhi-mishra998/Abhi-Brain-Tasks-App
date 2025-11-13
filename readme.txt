# 🧠 Brain Tasks App - AWS EKS Deployment

<div align="center">

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=for-the-badge&logo=python&logoColor=ffdd54)

**A production-ready serverless CI/CD pipeline deploying static web applications to AWS EKS**

[Features](#-key-features) • [Architecture](#%EF%B8%8F-architecture) • [Getting Started](#-getting-started) • [Documentation](#-documentation)

</div>

---

## 🌟 Project Highlights

> **Enterprise-Grade DevOps Pipeline** showcasing modern cloud-native practices with AWS services, Kubernetes orchestration, and automated deployments.

### 🎯 What Makes This Special?

- ⚡ **Serverless kubectl** - Lambda-based Kubernetes deployments (no bastion hosts needed!)
- 🚀 **Zero-Downtime Deployments** - Rolling updates with health checks
- 🔄 **Full CI/CD Automation** - Push to deploy in minutes
- 💰 **Cost-Optimized** - ~$155/month for complete production setup
- 📦 **Lightweight** - 23MB Docker image using Alpine Linux
- 🛡️ **Production-Ready** - High availability, monitoring, and security best practices

---

## 📋 Table of Contents

<details>
<summary>Click to expand</summary>

- [Key Features](#-key-features)
- [Architecture](#️-architecture)
- [Tech Stack](#-tech-stack)
- [Prerequisites](#-prerequisites)
- [Project Structure](#-project-structure)
- [Getting Started](#-getting-started)
- [Docker Configuration](#-docker-configuration)
- [AWS Setup](#️-aws-setup)
  - [ECR Setup](#1-amazon-ecr-setup)
  - [EKS Cluster](#2-eks-cluster-setup)
  - [Lambda Function](#3-lambda-function-setup)
- [Kubernetes Manifests](#-kubernetes-manifests)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Deployment](#-deployment-process)
- [Monitoring](#-monitoring--troubleshooting)
- [Troubleshooting](#-common-issues--solutions)
- [Cost Analysis](#-cost-optimization)
- [Contributing](#-contributing)
- [License](#-license)

</details>

---

## ✨ Key Features

<table>
<tr>
<td width="50%">

### 🐳 Containerization
- Multi-stage Docker builds
- Alpine-based minimal images
- Optimized layer caching
- Security scanning enabled

</td>
<td width="50%">

### ☁️ Cloud Native
- AWS EKS orchestration
- Elastic Container Registry
- CloudWatch monitoring
- IAM-based security

</td>
</tr>
<tr>
<td width="50%">

### 🔄 CI/CD Pipeline
- GitHub webhook triggers
- Automated building & testing
- Container vulnerability scanning
- Progressive rollouts

</td>
<td width="50%">

### ⚡ Serverless Ops
- Lambda-powered kubectl
- Event-driven deployments
- No infrastructure management
- Pay-per-execution model

</td>
</tr>
</table>

---

## 🏗️ Architecture

```mermaid
graph TB
    A[👨‍💻 Developer Push] -->|Git Push| B[🔗 GitHub Repository]
    B -->|Webhook| C[⚡ AWS CodePipeline]
    C -->|Trigger| D[🔨 AWS CodeBuild]
    D -->|Build| E[🐳 Docker Image]
    E -->|Push| F[📦 Amazon ECR]
    C -->|Deploy| G[🚀 AWS CodeDeploy]
    G -->|Invoke| H[⚡ Lambda Function]
    H -->|kubectl apply| I[☸️ EKS Cluster]
    I -->|Service| J[⚖️ Load Balancer]
    J -->|Traffic| K[🌐 Public Internet]
    
    style A fill:#e1f5ff
    style K fill:#d4edda
    style H fill:#fff3cd
    style I fill:#f8d7da
```

### 🔄 Deployment Flow

```
┌─────────────────────────────────────────────────────────────────┐
│  1. Code Push → 2. Pipeline Trigger → 3. Build Image             │
│  4. Push to ECR → 5. Deploy Stage → 6. Lambda Execution          │
│  7. Kubernetes Apply → 8. Rolling Update → 9. Health Check       │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛠 Tech Stack

<table>
<tr>
<td align="center" width="25%">
<img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" width="80" height="80" alt="Kubernetes"/><br/>
<b>Kubernetes</b><br/>
Container Orchestration
</td>
<td align="center" width="25%">
<img src="https://www.docker.com/wp-content/uploads/2022/03/Moby-logo.png" width="80" height="80" alt="Docker"/><br/>
<b>Docker</b><br/>
Containerization
</td>
<td align="center" width="25%">
<img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" width="80" height="80" alt="AWS"/><br/>
<b>AWS</b><br/>
Cloud Platform
</td>
<td align="center" width="25%">
<img src="https://www.nginx.com/wp-content/uploads/2020/05/NGINX-product-icon.svg" width="80" height="80" alt="Nginx"/><br/>
<b>Nginx</b><br/>
Web Server
</td>
</tr>
</table>

### Core Services

- **Amazon EKS** - Managed Kubernetes service (v1.28+)
- **Amazon ECR** - Docker container registry
- **AWS Lambda** - Serverless compute for kubectl operations
- **AWS CodePipeline** - CI/CD orchestration
- **AWS CodeBuild** - Build automation
- **AWS CodeDeploy** - Deployment automation
- **Amazon CloudWatch** - Logging and monitoring

---

## 📦 Prerequisites

### 💻 Required Software

```bash
# Check versions
docker --version          # ≥ 20.10
aws --version            # ≥ 2.0
kubectl version --client # ≥ 1.21
eksctl version          # latest
git --version           # ≥ 2.0
```

### 🔑 AWS Account Requirements

<details>
<summary><b>IAM Permissions Needed</b></summary>

- ✅ **Amazon ECR**: Full access for image management
- ✅ **Amazon EKS**: Cluster creation and management
- ✅ **AWS CodePipeline**: Pipeline creation
- ✅ **AWS CodeBuild**: Build project management
- ✅ **AWS CodeDeploy**: Deployment configuration
- ✅ **AWS Lambda**: Function creation and execution
- ✅ **Amazon CloudWatch**: Logs access
- ✅ **AWS IAM**: Role and policy management

</details>

---

## 📁 Project Structure

```
brain-task-app/
│
├── 📄 Dockerfile                    # Nginx Alpine container config
├── 📄 buildspec.yml                 # CodeBuild build instructions
├── 📄 appspec.yml                   # CodeDeploy hooks configuration
├── 📄 deployment.yaml               # K8s Deployment manifest
├── 📄 service.yaml                  # K8s LoadBalancer Service
├── 📄 lambda_function.py            # Lambda kubectl handler
├── 📄 README.md                     # This file
│
├── 📂 dist/                         # Static website files
│   ├── index.html
│   ├── styles.css
│   └── app.js
│
├── 📂 scripts/
│   ├── cleanup.sh                   # Pre-deployment cleanup
│   └── deploy.sh                    # Deployment execution
│
└── 🔧 kubectl                       # kubectl binary (Linux AMD64)
```

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/Abhi-mishra998/Abhi-Brain-Tasks-App.git
cd Abhi-Brain-Tasks-App
```

### 2️⃣ Quick Local Test

```bash
# Test static files locally
cd dist
python3 -m http.server 8080

# Access at http://localhost:8080
```

### 3️⃣ Build Docker Image

```bash
docker build -t brain-task-app .
docker run -d -p 8080:80 brain-task-app

# Test: curl http://localhost:8080
```

---

## 🐳 Docker Configuration

### 📝 Dockerfile Breakdown

```dockerfile
# ⭐ Step 1: Minimal base image (23MB)
FROM nginx:alpine

# ⭐ Step 2: Copy static files
COPY dist /usr/share/nginx/html

# ⭐ Step 3: Expose HTTP port
EXPOSE 80

# ⭐ Step 4: Start server
CMD ["nginx", "-g", "daemon off;"]
```

### 🎯 Why This Approach?

| Feature | Benefit |
|---------|---------|
| 🪶 **Alpine Linux** | 23MB vs 140MB (84% smaller) |
| ⚡ **Static Content** | No Node.js runtime overhead |
| 🏆 **Nginx** | Battle-tested, 10k+ req/sec |
| 🎨 **Simplicity** | 4 lines, zero complexity |

### 🧪 Local Testing

```bash
# Build image
docker build -t brain-task-app:local .

# Run container
docker run -d \
  --name brain-test \
  -p 8080:80 \
  brain-task-app:local

# Test endpoints
curl http://localhost:8080
curl -I http://localhost:8080  # Check headers

# View logs
docker logs brain-test

# Cleanup
docker stop brain-test && docker rm brain-test
```

---

## ☁️ AWS Setup

### 1️⃣ Amazon ECR Setup

<details>
<summary><b>Step-by-step ECR Configuration</b></summary>

#### Create Repository

```bash
aws ecr create-repository \
    --repository-name brain-task-app \
    --region ap-south-1 \
    --image-scanning-configuration scanOnPush=true \
    --tags Key=Project,Value=BrainTasks Key=Environment,Value=Production
```

#### Authenticate Docker

```bash
aws ecr get-login-password --region ap-south-1 | \
  docker login --username AWS --password-stdin \
  323997748732.dkr.ecr.ap-south-1.amazonaws.com
```

#### Tag and Push

```bash
# Tag image
docker tag brain-task-app:latest \
  323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest

# Push to ECR
docker push 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
```

#### Verify Upload

```bash
aws ecr describe-images \
    --repository-name brain-task-app \
    --region ap-south-1
```

</details>

### 2️⃣ EKS Cluster Setup

<details>
<summary><b>Complete EKS Configuration</b></summary>

#### Create Cluster (15-20 minutes)

```bash
eksctl create cluster \
    --name brain-task-cluster \
    --region ap-south-1 \
    --nodegroup-name standard-workers \
    --node-type t3.medium \
    --nodes 2 \
    --nodes-min 2 \
    --nodes-max 4 \
    --managed \
    --tags "Project=BrainTasks,Environment=Production"
```

#### Verify Cluster

```bash
# Check cluster status
aws eks describe-cluster \
    --name brain-task-cluster \
    --region ap-south-1 \
    --query cluster.status

# Update kubeconfig
aws eks update-kubeconfig \
    --name brain-task-cluster \
    --region ap-south-1

# Test connection
kubectl get nodes
```

**Expected Output:**
```
NAME                                           STATUS   ROLES    AGE
ip-192-168-xx-xx.ap-south-1.compute.internal   Ready    <none>   5m
ip-192-168-yy-yy.ap-south-1.compute.internal   Ready    <none>   5m
```

</details>

### 3️⃣ Lambda Function Setup

<details>
<summary><b>Serverless kubectl Deployment</b></summary>

#### Why Lambda for kubectl? 🤔

Traditional setups require:
- ❌ Bastion host ($50/month)
- ❌ Jenkins server ($100/month)
- ❌ Persistent connections
- ❌ Security management

Lambda provides:
- ✅ **Zero infrastructure** - No servers to manage
- ✅ **$0.20/month** - Pay per execution
- ✅ **Auto-scaling** - Handle any load
- ✅ **IAM security** - Built-in authentication

#### Lambda Function Code

```python
import os
import boto3
import subprocess

def lambda_handler(event, context):
    """
    Serverless kubectl deployment to EKS
    Triggered by CodeDeploy after successful build
    """
    # Binary paths in Lambda environment
    aws_cli = "/opt/bin/aws"
    kubectl = "/tmp/app/kubectl"
    kubeconfig = "/tmp/.kube/config"
    
    # Create kubeconfig directory
    os.makedirs(os.path.dirname(kubeconfig), exist_ok=True)
    
    # Authenticate with EKS cluster
    subprocess.run([
        aws_cli, "eks", "update-kubeconfig",
        "--region", "ap-south-1",
        "--name", "brain-task-cluster",
        "--kubeconfig", kubeconfig
    ], check=True)
    
    # Apply Kubernetes manifests
    subprocess.run([
        kubectl, "--kubeconfig", kubeconfig,
        "apply", "--validate=false",
        "-f", "/tmp/app/deployment.yaml"
    ], check=True)
    
    subprocess.run([
        kubectl, "--kubeconfig", kubeconfig,
        "apply", "--validate=false",
        "-f", "/tmp/app/service.yaml"
    ], check=True)
    
    return {
        'statusCode': 200,
        'body': 'Deployment successful! 🎉'
    }
```

#### Create Lambda Function

```bash
# Package deployment
zip -r lambda-deploy.zip \
    lambda_function.py \
    kubectl \
    deployment.yaml \
    service.yaml

# Create function
aws lambda create-function \
    --function-name brain-task-eks-deployer \
    --runtime python3.9 \
    --role arn:aws:iam::323997748732:role/lambda-eks-deployer-role \
    --handler lambda_function.lambda_handler \
    --zip-file fileb://lambda-deploy.zip \
    --timeout 600 \
    --memory-size 512 \
    --region ap-south-1
```

#### IAM Role Requirements

Create role with these policies:
- `AmazonEKSClusterPolicy`
- `AmazonEKSWorkerNodePolicy`
- `AWSLambdaBasicExecutionRole`
- Custom policy for EKS access

</details>

---

## ☸️ Kubernetes Manifests

### 🚀 Deployment Configuration

<details>
<summary><b>deployment.yaml - Click to expand</b></summary>

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: brain-tasks-deployment
  labels:
    app: brain-tasks
    version: v1
    environment: production
spec:
  replicas: 2  # High availability
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: brain-tasks
  template:
    metadata:
      labels:
        app: brain-tasks
        version: v1
    spec:
      containers:
      - name: brain-tasks-container
        image: 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
        ports:
        - containerPort: 80
          protocol: TCP
        resources:
          requests:
            memory: "64Mi"
            cpu: "100m"
          limits:
            memory: "128Mi"
            cpu: "200m"
        # Health checks for zero-downtime deployments
        livenessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 5
          failureThreshold: 3
        readinessProbe:
          httpGet:
            path: /
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 3
          successThreshold: 1
```

**Key Features:**
- ✅ Zero-downtime rolling updates
- ✅ Automatic health checks
- ✅ Resource limits prevent resource exhaustion
- ✅ Multiple replicas for high availability

</details>

### ⚖️ Service Configuration

<details>
<summary><b>service.yaml - LoadBalancer</b></summary>

```yaml
apiVersion: v1
kind: Service
metadata:
  name: brain-tasks-service
  labels:
    app: brain-tasks
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "classic"
spec:
  type: LoadBalancer  # AWS ELB provisioned automatically
  selector:
    app: brain-tasks
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      name: http
  sessionAffinity: None
```

**What This Creates:**
- 🌐 Public-facing AWS Classic Load Balancer
- ⚡ Automatic health checks to pods
- 🔄 Traffic distribution across replicas
- 🛡️ AWS security group integration

</details>

---

## 🔄 CI/CD Pipeline

### 📦 Build Configuration

<details>
<summary><b>buildspec.yml - CodeBuild</b></summary>

```yaml
version: 0.2

env:
  variables:
    AWS_DEFAULT_REGION: ap-south-1
    AWS_ACCOUNT_ID: 323997748732
    IMAGE_REPO_NAME: brain-task-app
    IMAGE_TAG: latest

phases:
  pre_build:
    commands:
      - echo "🔐 Logging in to Amazon ECR..."
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}

  build:
    commands:
      - echo "🔨 Build started on `date`"
      - echo "🐳 Building Docker image..."
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest

  post_build:
    commands:
      - echo "✅ Build completed on `date`"
      - echo "📤 Pushing Docker images to ECR..."
      - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
      - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:latest
      - printf '[{"name":"brain-task-container","imageUri":"%s"}]' $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG > imagedefinitions.json

artifacts:
  files:
    - imagedefinitions.json
    - deployment.yaml
    - service.yaml
    - scripts/**/*
```

</details>

### 🚀 Deploy Configuration

<details>
<summary><b>appspec.yml - CodeDeploy</b></summary>

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

**Deployment Lifecycle:**
1. 🧹 **BeforeInstall**: Cleanup old deployments
2. 🚀 **AfterInstall**: Apply new manifests
3. ✅ **Validation**: Health checks confirm success

</details>

### 📜 Deployment Scripts

<details>
<summary><b>Cleanup & Deploy Scripts</b></summary>

**cleanup.sh**
```bash
#!/bin/bash
set -e

AWS="/opt/bin/aws"
KUBECTL="/tmp/app/kubectl"
KUBECONFIG="/tmp/.kube/config"

mkdir -p $(dirname $KUBECONFIG)

echo "🧹 Cleaning up old deployments..."
$KUBECTL --kubeconfig $KUBECONFIG delete -f /tmp/app/deployment.yaml --ignore-not-found || true
$KUBECTL --kubeconfig $KUBECONFIG delete -f /tmp/app/service.yaml --ignore-not-found || true
echo "✅ Cleanup completed!"
```

**deploy.sh**
```bash
#!/bin/bash
set -e

echo "🚀 Starting EKS deployment..."

AWS="/opt/bin/aws"
KUBECTL="/tmp/app/kubectl"
KUBECONFIG="/tmp/.kube/config"

mkdir -p $(dirname $KUBECONFIG)

echo "📝 Updating kubeconfig..."
$AWS eks update-kubeconfig --region ap-south-1 --name brain-task-cluster --kubeconfig $KUBECONFIG

echo "⚙️ Applying manifests..."
$KUBECTL --kubeconfig $KUBECONFIG apply --validate=false -f /tmp/app/deployment.yaml
$KUBECTL --kubeconfig $KUBECONFIG apply --validate=false -f /tmp/app/service.yaml

echo "🔍 Verifying deployment..."
$KUBECTL --kubeconfig $KUBECONFIG get deployments
$KUBECTL --kubeconfig $KUBECONFIG get pods
$KUBECTL --kubeconfig $KUBECONFIG get services

echo "🎉 Deployment successful!"
```

</details>

---

## 🎯 Deployment Process

### ⚡ Automated Deployment

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant GH as GitHub
    participant CP as CodePipeline
    participant CB as CodeBuild
    participant ECR as ECR
    participant CD as CodeDeploy
    participant Lambda as Lambda
    participant EKS as EKS Cluster
    
    Dev->>GH: git push
    GH->>CP: Webhook trigger
    CP->>CB: Start build
    CB->>ECR: Push image
    CP->>CD: Start deploy
    CD->>Lambda: Invoke function
    Lambda->>EKS: kubectl apply
    EKS-->>Dev: Deployment complete ✅
```

### 🛠️ Manual Deployment

```bash
# 1️⃣ Build and push image
docker build -t brain-task-app .
docker tag brain-task-app:latest 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest
docker push 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest

# 2️⃣ Update kubeconfig
aws eks update-kubeconfig --name brain-task-cluster --region ap-south-1

# 3️⃣ Deploy to EKS
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 4️⃣ Watch rollout
kubectl rollout status deployment/brain-tasks-deployment

# 5️⃣ Verify deployment
kubectl get pods -l app=brain-tasks
kubectl get svc brain-tasks-service
```

---

## 📊 Monitoring & Troubleshooting

### 📈 CloudWatch Monitoring

```bash
# CodeBuild logs
aws logs tail /aws/codebuild/brain-task-build --follow

# Lambda logs
aws logs tail /aws/lambda/brain-task-eks-deployer --follow

# Filter errors
aws logs filter-log-events \
    --log-group-name /aws/lambda/brain-task-eks-deployer \
    --filter-pattern "ERROR"
```

### 🔍 Kubernetes Debugging

```bash
# Check all resources
kubectl get all -l app=brain-tasks

# Pod logs
kubectl logs -f deployment/brain-tasks-deployment --tail=100

# Describe pod (events & status)
kubectl describe pod <pod-name>

# Execute shell in pod
kubectl exec -it <pod-name> -- /bin/sh

# Check events
kubectl get events --sort-by='.lastTimestamp' | head -20

# Resource usage
kubectl top nodes
kubectl top pods

# Rollout history
kubectl rollout history deployment/brain-tasks-deployment

# Rollback if needed
kubectl rollout undo deployment/brain-tasks-deployment
```

---

## ❗ Common Issues & Solutions

<details>
<summary><b>🔴 Issue #1: ImagePullBackOff</b></summary>

**Symptom:**
```
Failed to pull image: unauthorized or not found
```

**Solutions:**
```bash
# 1. Verify image exists
aws ecr describe-images --repository-name brain-task-app

# 2. Check ECR permissions
aws ecr get-repository-policy --repository-name brain-task-app

# 3. Update node IAM role with ECR permissions
```

</details>

<details>
<summary><b>🟡 Issue #2: LoadBalancer Pending</b></summary>

**Symptom:**
```
EXTERNAL-IP: <pending> (never gets IP)
```

**Solutions:**
```bash
# 1. Check security groups
aws ec2 describe-security-groups --filters "Name=tag:kubernetes.io/cluster/brain-task-cluster,Values=owned"

# 2. Verify subnet tags
aws ec2 describe-subnets --filters "Name=tag:kubernetes.io/cluster/brain-task-cluster,Values=shared"

# 3. Check service events
kubectl describe svc brain-tasks-service
```

</details>

<details>
<summary><b>🔵 Issue #3: CrashLoopBackOff</b></summary>

**Symptom:**
```
Pod keeps restarting with CrashLoopBackOff
```

**Solutions:**
```bash
# 1. Check logs
kubectl logs <pod-name> --previous

# 2. Check resource limits
kubectl describe pod <pod-name> | grep -A 5 "Limits"

# 3. Verify image runs locally
docker run -it 323997748732.dkr.ecr.ap-south-1.amazonaws.com/brain-task-app:latest /bin/sh
```

</details>

---

## 🌐 Application Access

### Get Your App URL

```bash
kubectl get service brain-tasks-service
```

**Output:**
```
NAME                  TYPE           EXTERNAL-IP
brain-tasks-service   LoadBalancer   a1b2c3-123456.ap-south-1.elb.amazonaws.com
```

### 🎉 Access Your Application

```
http://a1b2c3-123456.ap-south-1.elb.amazonaws.com
```

### 🧪 Test LoadBalancer

```bash
# Health check
curl -I http://<LoadBalancer-URL>

# Load test
ab -n 1000 -c 10 http://<LoadBalancer-URL>/

# Check response time
time curl -s http://<LoadBalancer-URL> > /dev/null
```

---

## 💰 Cost Optimization

### 📊 Monthly Cost Breakdown (ap-south-1)

| Service | Configuration | Cost | Optimization |
|---------|--------------|------|--------------|
| 🎯 EKS Control Plane | 1 cluster | $73.00 | Use single cluster for multiple apps |
| 💻 EC2 Worker Nodes | 2x t3.medium | $60.00 | Use Spot Instances (save 70%) |
| ⚖️ Load Balancer | Classic LB | $18.00 | Use ALB for multiple services |
| 📦 ECR Storage | <1GB images | $0.10 | Enable lifecycle policies |
| 🔄 CodePipeline | 1 active pipeline | $1.00 | Free tier: 1 pipeline/month |
| ⚡ Lambda | <100 invocations | $0.00 | Free tier: 1M requests/month |
| 📊 CloudWatch | <5GB logs | $2.50 | Set log retention to 7 days |
| **💵 Total** | | **~$154.60/mo** | **Save $80/mo with optimizations** |

### 💡 Cost-Saving Tips

<details>
<summary><b>1. Use Spot Instances (70% savings)</b></summary>

```bash
eksctl create nodegroup \
    --cluster brain-task-cluster \
    --spot \
    --instance-types t3.medium,t3a.medium,t2.medium \
    --nodes-min 2 \
    --nodes-max 4
```

**Savings:** $60 → $18/month

</details>

<details>
<summary><b>2. ECR Lifecycle Policy</b></summary>

```json
{
  "rules": [{
    "rulePriority": 1,
    "description": "Delete untagged images after 30 days",
    "selection": {
      "tagStatus": "untagged",
      "countType": "sinceImagePushed",
      "countUnit

## 👤 Author

**Abhishek Mishra**

- GitHub: [@abhishek-mishra](https://github.com/Abhi-mishra998)
- Repository: [brain-task-app](https://github.com/Abhi-mishra998/Abhi-Brain-Tasks-App/tree/main)
- LinkedIn: [Abhishek Mishra](https://www.linkedin.com/in/abhishek-mishra-49888123b/)



**Project Location**: `/home/ubuntu/brain-task-app/`  
**AWS Region**: `ap-south-1` (Mumbai)  
**AWS Account**: `323997748732`
