# QA Environment

This directory contains the Terraform configuration for the QA environment.

## Overview

The QA environment is a copy of the dev environment with the following changes:
- Instance name: `qa-sql-instance`
- Database name: `qadb`
- Database user: `qauser`
- Environment label: `qa`
- State storage: GCS bucket with prefix `qa/terraform/state`

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
   - Select environment: `qa`
   - Click "Run workflow"

2. **Via CLI** (for testing):
   ```bash
   cd environments/non-prod/qa
   terraform init
   terraform plan
   terraform apply
   ```

## State Management

The state is stored in GCS bucket `terraform-statefile-p` with prefix `qa/terraform/state`.

## Destruction

To destroy this environment:

1. **Via GitHub Actions**:
   - Go to Actions → Terraform Destroy
   - Select environment: `qa`
   - Type "DESTROY" to confirm
   - Click "Run workflow"

2. **Via CLI** (for testing):
   ```bash
   cd environments/non-prod/qa
   terraform destroy
   ```

## Notes

- This environment uses the same network and project as dev
- Passwords are auto-generated and stored in GCP Secret Manager
- Deletion protection is enabled by default 