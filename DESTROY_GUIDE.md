# 🗑️ Infrastructure Destroy Guide

This guide explains how to safely destroy infrastructure using the automated workflows.

## ⚠️ **Important Safety Warnings**

**Before destroying any infrastructure:**
- ✅ **Backup your data** - Ensure all important data is backed up
- ✅ **Verify environment** - Double-check you're destroying the correct environment
- ✅ **Team notification** - Inform your team before destroying production resources
- ✅ **Dependencies** - Ensure no applications depend on the resources being destroyed

## 🚀 **How to Use Destroy Workflows**

### **Option 1: Main Workflow with Destroy Option**

1. **Go to GitHub Actions** in your repository
2. **Click on "CI" workflow**
3. **Click "Run workflow"**
4. **Select parameters:**
   - **Action**: `destroy`
   - **Confirm Destroy**: Type `DESTROY` (exactly as shown)
5. **Click "Run workflow"**

### **Option 2: Dedicated Destroy Workflow**

1. **Go to GitHub Actions** in your repository
2. **Click on "Terraform Destroy" workflow**
3. **Click "Run workflow"**
4. **Select parameters:**
   - **Environment**: Choose environment to destroy
   - **Confirm Destroy**: Type `DESTROY` (exactly as shown)
5. **Click "Run workflow"**

## 🔒 **Safety Features**

### **Confirmation Required**
- You must type `DESTROY` exactly to confirm
- Workflow will fail if confirmation is incorrect
- Prevents accidental destruction

### **Environment Selection**
- Choose specific environment to destroy
- Prevents destroying wrong environment
- Clear labeling of what will be destroyed

### **State Cleanup**
- Automatically cleans up Terraform state files
- Removes local cache files
- Ensures clean slate for future deployments

## 📋 **What Gets Destroyed**

### **Dev Environment** (`environments/non-prod/dev`)
- ✅ CloudSQL instance: `dev-sql-instance`
- ✅ Database: `devdb`
- ✅ Database user: `devuser`
- ✅ All associated resources

### **Production Environment** (`environments/production/prod`)
- ✅ CloudSQL instance: `prod-sql-instance`
- ✅ Database: `proddb`
- ✅ Database user: `produser`
- ✅ All associated resources

## 🔄 **Recovery Process**

### **If You Need to Recreate Infrastructure**

1. **Run the apply workflow** with the same configuration
2. **Import existing resources** (if any remain)
3. **Verify all resources** are recreated correctly
4. **Test connectivity** to ensure everything works

### **Data Recovery**
- **Backups**: Check if CloudSQL backups exist in GCS
- **Point-in-time recovery**: Use CloudSQL backup features
- **Manual restoration**: Restore from backup files

## 🛡️ **Best Practices**

### **Before Destroying**
1. **Document current state**
   ```bash
   terraform show
   terraform state list
   ```

2. **Create backup**
   ```bash
   # Export current state
   terraform state pull > backup-state.json
   
   # Backup database (if accessible)
   gcloud sql export sql dev-sql-instance gs://your-backup-bucket/backup.sql
   ```

3. **Notify stakeholders**
   - Team members
   - Application owners
   - Database administrators

### **After Destroying**
1. **Verify destruction**
   ```bash
   gcloud sql instances list
   ```

2. **Clean up secrets**
   ```bash
   gcloud secrets delete cloudsql-root-password
   gcloud secrets delete cloudsql-app-password
   ```

3. **Update documentation**
   - Remove references to destroyed resources
   - Update connection strings
   - Update application configurations

## 🚨 **Emergency Procedures**

### **If Destroy Fails**
1. **Check logs** in GitHub Actions
2. **Manual cleanup** if needed:
   ```bash
   gcloud sql instances delete dev-sql-instance
   ```
3. **Contact support** if resources are stuck

### **If You Destroyed Wrong Environment**
1. **Immediately stop** any running workflows
2. **Assess impact** on applications
3. **Restore from backup** if available
4. **Recreate infrastructure** using apply workflow

## 📊 **Monitoring Destruction**

### **What to Watch**
- ✅ **Workflow progress** in GitHub Actions
- ✅ **Resource deletion** in GCP Console
- ✅ **Cost impact** in billing dashboard
- ✅ **Application errors** if any

### **Expected Timeline**
- **Small instances**: 2-5 minutes
- **Large instances**: 5-15 minutes
- **Complex setups**: 15-30 minutes

## 🔧 **Troubleshooting**

### **Common Issues**

1. **"Instance not found"**
   - Resource already destroyed
   - Check GCP Console for current state

2. **"Permission denied"**
   - Check service account permissions
   - Verify Workload Identity Federation

3. **"State file not found"**
   - Normal for fresh environments
   - Import resources if they exist

### **Manual Cleanup**
```bash
# If automated destroy fails
gcloud sql instances delete dev-sql-instance --quiet
gcloud secrets delete cloudsql-root-password --quiet
gcloud secrets delete cloudsql-app-password --quiet
```

## 📞 **Support**

### **When to Contact Support**
- ❌ Destroy workflow fails repeatedly
- ❌ Resources stuck in "deleting" state
- ❌ Accidental destruction of production
- ❌ Data loss concerns

### **Information to Provide**
- Workflow run ID
- Error messages
- Resource names
- Timeline of events

## 🎯 **Summary**

The destroy workflows provide:
- ✅ **Safe destruction** with confirmation
- ✅ **Environment isolation** 
- ✅ **Automatic cleanup**
- ✅ **Audit trail**
- ✅ **Recovery options**

**Remember**: Always backup before destroying, and double-check your environment selection! 