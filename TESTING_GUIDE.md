# 🧪 Testing Guide for Destroy Workflow

This guide shows you how to safely test the destroy functionality without risking your production infrastructure.

## 🎯 **Testing Strategy Overview**

### **Safe Testing Approaches:**
1. **Test with temporary resources** (Recommended)
2. **Test with dry-run mode** (Local testing)
3. **Test with staging environment** (Production-like)
4. **Test with mock resources** (Development only)

## 🚀 **Option 1: Test with Temporary Resources (Safest)**

### **Step 1: Create Test Resources**
We've already added a test bucket resource (`test-resource.tf`) that's safe to destroy.

### **Step 2: Deploy Test Resources**
```bash
# Apply the test resources
cd environments/non-prod/dev
terraform apply -auto-approve
```

### **Step 3: Test Destroy Workflow**

#### **Method A: GitHub Actions Workflow**
1. **Go to GitHub Actions** in your repository
2. **Click on "CI" workflow**
3. **Click "Run workflow"**
4. **Set parameters:**
   - **Action**: `destroy`
   - **Confirm Destroy**: Type `DESTROY`
5. **Click "Run workflow"**

#### **Method B: Dedicated Destroy Workflow**
1. **Go to GitHub Actions** → "Terraform Destroy"
2. **Click "Run workflow"**
3. **Set parameters:**
   - **Environment**: `dev`
   - **Confirm Destroy**: Type `DESTROY`
4. **Click "Run workflow"**

### **Step 4: Verify Destruction**
```bash
# Check if resources were destroyed
gcloud storage buckets list --filter="name:test-destroy-bucket"
gcloud sql instances list --filter="name:dev-sql-instance"
```

## 🔍 **Option 2: Local Testing (Dry Run)**

### **Test Destroy Plan Locally**
```bash
cd environments/non-prod/dev

# Test destroy plan (doesn't actually destroy)
terraform plan -destroy

# Test destroy with auto-approve (BE CAREFUL!)
terraform destroy -auto-approve
```

### **Test with Specific Resources**
```bash
# Destroy only test bucket
terraform destroy -target=google_storage_bucket.test_bucket

# Destroy only specific resources
terraform destroy -target=random_string.bucket_suffix
```

## 🛡️ **Option 3: Staging Environment Testing**

### **Create Staging Environment**
```bash
# Copy dev environment to staging
cp -r environments/non-prod/dev environments/staging/staging

# Modify staging configuration
cd environments/staging/staging
# Edit main-local.tf to use staging names
```

### **Test in Staging**
1. **Deploy to staging** using apply workflow
2. **Test destroy** using destroy workflow
3. **Verify** no production impact

## 🎭 **Option 4: Mock Testing (Development)**

### **Create Mock Resources**
```bash
# Create mock Terraform configuration
cat > mock-test.tf << EOF
resource "null_resource" "mock_resource" {
  provisioner "local-exec" {
    command = "echo 'Mock resource created'"
  }
  
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Mock resource destroyed'"
  }
}
EOF
```

### **Test Mock Destruction**
```bash
terraform init
terraform apply
terraform destroy
```

## 📊 **Testing Checklist**

### **Before Testing**
- [ ] **Backup important data**
- [ ] **Verify test environment**
- [ ] **Notify team members**
- [ ] **Check resource dependencies**
- [ ] **Review destroy plan**

### **During Testing**
- [ ] **Monitor workflow progress**
- [ ] **Check resource deletion**
- [ ] **Verify state cleanup**
- [ ] **Test confirmation prompts**
- [ ] **Validate error handling**

### **After Testing**
- [ ] **Verify resources destroyed**
- [ ] **Check cost impact**
- [ ] **Clean up test files**
- [ ] **Document test results**
- [ ] **Update documentation**

## 🔧 **Testing Commands**

### **Pre-Test Verification**
```bash
# List current resources
terraform state list

# Show current state
terraform show

# Check what will be destroyed
terraform plan -destroy
```

### **Post-Test Verification**
```bash
# Verify resources are gone
gcloud sql instances list
gcloud storage buckets list

# Check state files cleaned up
ls -la .terraform*
ls -la terraform.tfstate*
```

## 🚨 **Safety Measures**

### **Test Environment Isolation**
```bash
# Use separate state files for testing
export TF_VAR_environment="test"
terraform init -backend-config="key=test/terraform.tfstate"
```

### **Resource Tagging**
```bash
# Tag test resources for easy identification
resource "google_storage_bucket" "test_bucket" {
  name = "test-${random_string.suffix.result}"
  
  labels = {
    environment = "test"
    purpose     = "destroy-testing"
    owner       = "developer"
  }
}
```

### **Rollback Plan**
```bash
# Backup state before testing
terraform state pull > backup-state.json

# Restore if needed
terraform state push backup-state.json
```

## 📈 **Testing Scenarios**

### **Scenario 1: Normal Destroy**
1. **Create resources** → **Run destroy workflow** → **Verify cleanup**

### **Scenario 2: Partial Destroy**
1. **Create multiple resources** → **Destroy specific resources** → **Verify remaining**

### **Scenario 3: Error Handling**
1. **Create resources** → **Simulate error** → **Test recovery**

### **Scenario 4: Confirmation Testing**
1. **Try destroy without confirmation** → **Verify failure**
2. **Try destroy with wrong confirmation** → **Verify failure**
3. **Try destroy with correct confirmation** → **Verify success**

## 🎯 **Expected Results**

### **Successful Destroy Test**
- ✅ **Workflow completes** without errors
- ✅ **Resources deleted** from GCP
- ✅ **State files cleaned up**
- ✅ **Confirmation prompts work**
- ✅ **No impact on production**

### **Failed Destroy Test**
- ❌ **Workflow fails** with clear error messages
- ❌ **Resources remain** intact
- ❌ **State preserved** for recovery
- ❌ **Confirmation validation** works

## 📝 **Test Documentation**

### **Record Test Results**
```markdown
## Destroy Workflow Test Results

**Date**: [Date]
**Tester**: [Your Name]
**Environment**: [Dev/Staging/Test]

### Test Scenarios
- [ ] Normal destroy workflow
- [ ] Confirmation validation
- [ ] Error handling
- [ ] State cleanup
- [ ] Resource verification

### Results
- **Status**: [Pass/Fail]
- **Issues Found**: [List any issues]
- **Recommendations**: [Improvements needed]
```

## 🎉 **Success Criteria**

Your destroy workflow test is successful when:
- ✅ **Confirmation prompts** work correctly
- ✅ **Resources are destroyed** as expected
- ✅ **State files are cleaned up**
- ✅ **No production impact** occurs
- ✅ **Error handling** works properly
- ✅ **Documentation** is updated

## 🚀 **Next Steps After Testing**

1. **Clean up test resources**
2. **Remove test files**
3. **Update documentation**
4. **Share results with team**
5. **Plan production deployment**

---

**Remember**: Always test in a safe environment first, and never test destroy workflows on production without proper backups! 