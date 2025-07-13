# 🚀 Automated Infrastructure Workflow - Showcase Guide

## Overview
This repository demonstrates a **fully automated infrastructure-as-code workflow** using Terraform and GitHub Actions. The system automatically creates and destroys CloudSQL instances based on folder structure changes.

## 🎯 Key Features

### ✅ **Zero Manual Intervention**
- No manual triggers needed
- No complex configurations
- Pure automation based on Git operations

### ✅ **Simple Logic**
- **Add folder** → Infrastructure created automatically
- **Delete folder** → Infrastructure destroyed automatically

### ✅ **Safe & Reliable**
- State stored in GCS bucket
- Passwords auto-generated and stored securely
- Proper error handling

## 📁 Repository Structure

```
environments/
├── non-prod/
│   ├── dev/          # Dev environment
│   │   ├── main.tf   # Terraform configuration
│   │   ├── variables.tf
│   │   └── backend.tf
│   └── [new-env]/    # Any new environment
└── production/       # Future production environments
```

## 🔄 How It Works

### **Adding an Environment**
```bash
# 1. Create new environment folder
mkdir environments/non-prod/staging

# 2. Add Terraform files (copy from dev)
cp -r environments/non-prod/dev/* environments/non-prod/staging/

# 3. Update names in main.tf
# - instance_name = "staging-sql-instance"
# - db_user = "staginguser"
# - db_name = "stagingdb"

# 4. Update backend.tf
# - prefix = "staging/terraform/state"

# 5. Commit and push
git add .
git commit -m "Add staging environment"
git push

# ✅ Apply workflow runs automatically
# ✅ Creates staging-sql-instance in GCP
# ✅ Stores passwords in Secret Manager
```

### **Deleting an Environment**
```bash
# 1. Delete environment folder
rm -rf environments/non-prod/staging

# 2. Commit and push
git add .
git commit -m "Remove staging environment"
git push

# ✅ Destroy workflow runs automatically
# ✅ Destroys staging-sql-instance from GCP
# ✅ Cleans up all resources
```

## 🛠️ Workflows

### **Apply Workflow** (`terraform.yml`)
- **Trigger:** Changes to `environments/non-prod/**`
- **Action:** Deploy all environments
- **Logic:** Find all folders with `main.tf` and deploy them

### **Destroy Workflow** (`terraform-destroy.yml`)
- **Trigger:** Changes to `environments/non-prod/**`
- **Action:** Destroy deleted environments
- **Logic:** Compare previous vs current state, destroy what was deleted

## 🎯 Demo Scenarios

### **Scenario 1: Add New Environment**
```bash
# Create staging environment
mkdir environments/non-prod/staging
# [Add Terraform files...]
git add . && git commit -m "Add staging" && git push
# Watch GitHub Actions → Apply workflow runs → Infrastructure created
```

### **Scenario 2: Remove Environment**
```bash
# Remove staging environment
rm -rf environments/non-prod/staging
git add . && git commit -m "Remove staging" && git push
# Watch GitHub Actions → Destroy workflow runs → Infrastructure destroyed
```

### **Scenario 3: Update Environment**
```bash
# Modify existing environment
vim environments/non-prod/dev/main.tf
git add . && git commit -m "Update dev config" && git push
# Watch GitHub Actions → Apply workflow runs → Infrastructure updated
```

## 📊 Benefits for Showcase

### **For Developers:**
- ✅ **Simple:** Just add/delete folders
- ✅ **Fast:** No manual infrastructure setup
- ✅ **Safe:** Automatic cleanup

### **For Operations:**
- ✅ **Consistent:** Same process for all environments
- ✅ **Auditable:** All changes tracked in Git
- ✅ **Reliable:** State managed in GCS

### **For Business:**
- ✅ **Cost Effective:** Automatic cleanup prevents orphaned resources
- ✅ **Scalable:** Easy to add new environments
- ✅ **Compliant:** Passwords stored securely

## 🔍 Monitoring

### **GitHub Actions Dashboard**
- Go to Actions tab
- See both workflows running automatically
- Check logs for deployment status

### **GCP Console**
- CloudSQL instances created/destroyed
- Secret Manager for passwords
- GCS bucket for Terraform state

## 🎯 Key Takeaways for Showcase

1. **Zero Manual Work:** Everything is automated
2. **Simple Operations:** Just Git commands
3. **Safe & Reliable:** Proper state management
4. **Cost Effective:** Automatic cleanup
5. **Developer Friendly:** No infrastructure expertise needed

## 📝 For the Demo

1. **Show the repository structure**
2. **Demonstrate adding an environment** (live)
3. **Show GitHub Actions running**
4. **Check GCP for created resources**
5. **Demonstrate deleting an environment** (live)
6. **Show automatic cleanup**

**This is infrastructure-as-code at its simplest and most effective!** 🚀 