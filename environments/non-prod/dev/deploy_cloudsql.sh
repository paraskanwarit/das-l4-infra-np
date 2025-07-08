t#!/bin/bash
# Script to deploy CloudSQL using Terraform in the dev environment
# Make sure you are authenticated to GCP and have set the correct project

set -e

# Step 1: Change directory to the dev environment
cd "$(dirname "$0")"
echo "[Step 1] Changed directory to $(pwd)"

# Step 2: Initialize Terraform (downloads providers and sets up backend)
echo "[Step 2] Initializing Terraform..."
terraform init

# Step 3: Show the Terraform execution plan
echo "[Step 3] Creating Terraform plan..."
terraform plan -out=tfplan

# Step 4: Apply the Terraform plan (provision resources)
echo "[Step 4] Applying Terraform plan..."
terraform apply tfplan

echo "[Done] CloudSQL deployment complete!"
