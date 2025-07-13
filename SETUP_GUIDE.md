# 🚀 GitHub Actions Setup Guide

This guide will help you set up GitHub Secrets and Workload Identity Federation for secure Terraform deployments.

## ✅ What's Already Configured

### GCP Resources Created:
- ✅ Service Account: `github-actions-sa@affable-beaker-464822-b4.iam.gserviceaccount.com`
- ✅ IAM Roles: CloudSQL Admin, Storage Admin, Compute Network Admin
- ✅ Workload Identity Pool: `github-actions-pool`
- ✅ Workload Identity Provider: `github-provider`
- ✅ Service Account Key: `github-actions-key.json` (backup method)

## 🔐 Step 1: Set Up GitHub Secrets

Go to your GitHub repository: `https://github.com/paraskanwarit/das-l4-infra-np`

### Navigate to Settings → Secrets and Variables → Actions

Add these secrets:

### **Required Secrets:**

1. **SQL_ROOT_PASSWORD**
   - Value: `your-secure-root-password-here`
   - Description: Root password for CloudSQL instance

2. **SQL_APP_PASSWORD**
   - Value: `your-secure-app-password-here`
   - Description: Application user password for CloudSQL

### **Backup Method (Service Account Key):**
If you prefer to use service account keys instead of Workload Identity Federation:

3. **GCP_SA_KEY** (Alternative to Workload Identity)
   - Value: Copy the entire content of `github-actions-key.json`
   - Description: Service account key JSON for GCP authentication

4. **GCP_PROJECT_ID**
   - Value: `affable-beaker-464822-b4`
   - Description: GCP Project ID

## 🔐 Step 2: Workload Identity Federation (Recommended)

The GitHub Actions workflow is now configured to use Workload Identity Federation, which is more secure than service account keys.

### Benefits:
- ✅ No long-lived credentials stored in GitHub
- ✅ Automatic token rotation
- ✅ Fine-grained access control
- ✅ Audit trail for authentication

### How it works:
1. GitHub Actions requests a token from GCP
2. GCP validates the request using the Workload Identity Pool
3. GCP issues a short-lived token for the service account
4. Terraform uses this token for authentication

## 🧪 Step 3: Test the Setup

### Option 1: Test via GitHub Actions
1. Push a change to the `main` branch
2. Go to Actions tab in your GitHub repository
3. Monitor the workflow execution

### Option 2: Test Locally
```bash
cd environments/non-prod/dev

# Set environment variables
export TF_VAR_sql_root_password="your-secure-root-password"
export TF_VAR_sql_app_password="your-secure-app-password"

# Test Terraform
terraform plan
```

## 🔧 Troubleshooting

### Common Issues:

1. **Authentication Failed**
   - Ensure Workload Identity Pool is configured correctly
   - Check service account permissions
   - Verify GitHub repository name matches the attribute condition

2. **Terraform Plan Fails**
   - Check if all required secrets are set
   - Verify project ID and region settings
   - Ensure Terraform module source is accessible

3. **Permission Denied**
   - Verify service account has required IAM roles
   - Check if the service account can access the GCS bucket for state files

### Debug Commands:
```bash
# Check service account permissions
gcloud projects get-iam-policy affable-beaker-464822-b4 --flatten="bindings[].members" --filter="bindings.members:github-actions-sa@affable-beaker-464822-b4.iam.gserviceaccount.com"

# Check Workload Identity Pool
gcloud iam workload-identity-pools describe github-actions-pool --location=global

# Check Workload Identity Provider
gcloud iam workload-identity-pools providers describe github-provider --workload-identity-pool=github-actions-pool --location=global
```

## 🔒 Security Best Practices

1. **Use Workload Identity Federation** instead of service account keys
2. **Rotate passwords regularly** for SQL instances
3. **Use strong passwords** (12+ characters, mixed case, numbers, symbols)
4. **Monitor access logs** in GCP Console
5. **Review IAM permissions** regularly

## 📋 Checklist

- [ ] Set up GitHub Secrets (SQL_ROOT_PASSWORD, SQL_APP_PASSWORD)
- [ ] Test GitHub Actions workflow
- [ ] Verify CloudSQL instance creation
- [ ] Test database connectivity
- [ ] Review security settings
- [ ] Document any custom configurations

## 🆘 Support

If you encounter issues:
1. Check the GitHub Actions logs for detailed error messages
2. Verify all secrets are correctly set
3. Ensure GCP project has billing enabled
4. Check if the Terraform module repository is accessible 