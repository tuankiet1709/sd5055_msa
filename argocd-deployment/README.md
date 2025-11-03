# ArgoCD Deployment Guide for sd5055-msa

This folder contains ArgoCD-specific configuration files for deploying the application.

## Quick Setup

1. **Create namespace and ECR secret:**
   ```bash
   kubectl create namespace sd5055-msa
   bash argocd-deployment/ecr-secret.sh
   ```

2. **Update deployment/app.yaml** to include imagePullSecrets (if not already added)

3. **Add Git repository to ArgoCD:**
   ```bash
   argocd repo add https://github.com/YOUR_USERNAME/sd5055_msa.git \
     --username YOUR_GITHUB_USERNAME \
     --password YOUR_GITHUB_TOKEN
   ```

4. **Deploy ArgoCD Application:**
   ```bash
   kubectl apply -f argocd-deployment/application.yaml
   ```

5. **Configure Image Updater (Optional - for auto-updates):**
   ```bash
   kubectl apply -f argocd-deployment/image-updater-config.yaml
   ```

6. **Verify:**
   ```bash
   argocd app get sd5055-msa
   kubectl get all -n sd5055-msa
   ```

## How It Works

- **Jenkins**: Builds images and pushes to ECR (CI only)
- **ArgoCD Image Updater**: Detects new images in ECR
- **ArgoCD Image Updater**: Updates `deployment/app.yaml` in Git
- **ArgoCD**: Syncs changes from Git to EKS cluster

## Troubleshooting

```bash
# Check application status
argocd app get sd5055-msa

# Check Image Updater logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-image-updater -f

# Manual sync
argocd app sync sd5055-msa

# Refresh ECR credentials (they expire after 12 hours)
bash argocd-deployment/ecr-secret.sh
```
