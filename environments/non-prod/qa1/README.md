# QA1 Environment

This directory contains the Terraform configuration for the QA1 environment.

## Overview

The QA1 environment is a copy of the dev environment with the following changes:
- Instance name: `qa1-sql-instance`
- Database name: `qa1db`
- Database user: `qa1user`
- Environment label: `qa1`
- State storage: GCS bucket with prefix `qa1/terraform/state`

## Configuration

- **Project ID**: `affable-beaker-464822-b4`
- **Region**: `australia-southeast1`
- **Database Version**: PostgreSQL 16
- **Tier**: `db-perf-optimized-N-2`
- **Availability**: Regional
- **Disk Size**: 50GB (SSD)
- **Network**: Private network only (no public IP)

## Deployment

To deploy this environment:

1. **Via GitHub Actions**:
   - Go to Actions → CI
   - Click "Run workflow"
   - Select environment: `qa1`
   - Click "Run workflow"

2. **Via CLI** (for testing):
   ```bash
   cd environments/non-prod/qa1
   terraform init
   terraform plan
   terraform apply
   ```

## State Management

The state is stored in GCS bucket `terraform-statefile-p` with prefix `qa1/terraform/state`.

## Destruction

To destroy this environment:

1. **Via GitHub Actions**:
   - Go to Actions → Terraform Destroy
   - Select environment: `qa1`
   - Type "DESTROY" to confirm
   - Click "Run workflow"

2. **Via CLI** (for testing):
   ```bash
   cd environments/non-prod/qa1
   terraform destroy
   ```

## Notes

- This environment uses the same network and project as dev
- Passwords are auto-generated and stored in GCP Secret Manager
- Deletion protection is enabled by default 