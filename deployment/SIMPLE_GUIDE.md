# Simple EKS Deployment Guide

## Prerequisites
1. EKS cluster created
2. kubectl configured: `aws eks update-kubeconfig --name YOUR_CLUSTER --region us-east-1`
3. Images in ECR

## Quick Setup (5 minutes)

### Step 1: Edit app.yaml
Replace `YOUR_ACCOUNT_ID` with your AWS account ID (12 digits)

### Step 2: Deploy Manually First
```bash
# Deploy everything
kubectl apply -f deployment/kubernetes/app.yaml

# Check status
kubectl get pods -n sd5055-msa

# Get frontend URL
kubectl get svc frontend -n sd5055-msa
```

### Step 3: Create Jenkins Job
1. Jenkins → New Item → Pipeline
2. Name: `deploy-to-eks`
3. Script Path: `deployment/Jenkinsfile-Deploy`
4. Save

### Step 4: Run Deployment
- Build with Parameters
- Enter IMAGE_TAG (or use 'latest')
- Click Build

## Common Commands

**Check status:**
```bash
kubectl get all -n sd5055-msa
```

**View logs:**
```bash
kubectl logs -f deployment/backend -n sd5055-msa
```

**Update image:**
```bash
./deployment/deploy.sh 42  # Deploy build #42
```

**Delete everything:**
```bash
kubectl delete namespace sd5055-msa
```

## Troubleshooting

**Pods not starting?**
```bash
kubectl describe pod <pod-name> -n sd5055-msa
```

**Can't access frontend?**
```bash
# Wait 2-3 minutes, then:
kubectl get svc frontend -n sd5055-msa
```

That's it! 🎉
