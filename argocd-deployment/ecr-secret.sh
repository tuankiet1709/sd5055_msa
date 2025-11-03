#!/bin/bash
# Creates ECR credentials for pulling images from AWS ECR

set -e

AWS_REGION="us-east-1"
ECR_REGISTRY="278113052993.dkr.ecr.us-east-1.amazonaws.com"
NAMESPACE="sd5055-msa"
SECRET_NAME="ecr-secret"

echo "Creating ECR pull secret..."

# Ensure namespace exists
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Get ECR password
ECR_PASSWORD=$(aws ecr get-login-password --region ${AWS_REGION})

# Create or update the secret
kubectl create secret docker-registry ${SECRET_NAME} \
  --namespace=${NAMESPACE} \
  --docker-server=${ECR_REGISTRY} \
  --docker-username=AWS \
  --docker-password=${ECR_PASSWORD} \
  --dry-run=client -o yaml | kubectl apply -f -

echo "ECR secret '${SECRET_NAME}' created in namespace '${NAMESPACE}'"
echo ""
echo "Note: ECR tokens expire after 12 hours."
echo "For production, set up a CronJob to refresh this secret."