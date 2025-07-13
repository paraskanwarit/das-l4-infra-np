# CloudSQL Dev Environment

This directory contains Terraform configuration for provisioning a CloudSQL instance in the dev environment.

## Prerequisites

1. **GCP Authentication**: Ensure you have authenticated with GCP
   ```bash
   gcloud auth application-default login
   ```

2. **Terraform**: Ensure Terraform is installed and configured

3. **GitHub Secrets** (for CI/CD):
   - `GCP_SA_KEY`: Service account key JSON
   - `GCP_PROJECT_ID`: GCP Project ID
   - `SQL_ROOT_PASSWORD`: Root password for CloudSQL
   - `SQL_APP_PASSWORD`: Application user password

## Local Deployment

### Option 1: Using the deployment script
```bash
./deploy_cloudsql.sh
```

### Option 2: Manual Terraform commands
```bash
# Initialize
terraform init

# Plan (set passwords via environment variables)
export TF_VAR_sql_root_password="your-secure-root-password"
export TF_VAR_sql_app_password="your-secure-app-password"
terraform plan

# Apply
terraform apply
```

## Resources Created

- **CloudSQL Instance**: `dev-sql-instance`
  - PostgreSQL 16
  - Region: australia-southeast1
  - Tier: db-f1-micro
  - Storage: 50GB PD_SSD
  - Private network only

- **Database**: `devdb`

- **Database User**: `devuser`

## Security Notes

- Instance is configured for private network access only
- No public IP enabled
- Passwords should be managed via environment variables or secrets
- Deletion protection is enabled

## Troubleshooting

If you encounter module source changes:
```bash
terraform init -upgrade
``` 