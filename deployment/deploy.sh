#!/bin/bash
# Simple deployment script

# Update these values
export AWS_ACCOUNT_ID="YOUR_ACCOUNT_ID"
export IMAGE_TAG="${1:-latest}"  # Use argument or default to 'latest'

echo "Deploying with image tag: $IMAGE_TAG"

`sed "s/YOUR_ACCOUNT_ID/$AWS_ACCOUNT_ID/g" deployment/app.yaml | \
`sed "s/:latest/:$IMAGE_TAG/g" | \
kubectl apply -f -

echo "Waiting for deployments..."
kubectl rollout status deployment/backend -n sd5055-msa
kubectl rollout status deployment/frontend -n sd5055-msa

echo "Deployment complete!"
kubectl get pods -n sd5055-msa
kubectl get svc -n sd5055-msa
