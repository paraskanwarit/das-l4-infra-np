# 🏭 Production Setup Guide

This guide covers secure password management and production best practices for your CloudSQL infrastructure.

## 🔐 **Password Management Strategies**

### **Option 1: Auto-Generated Strong Passwords (Current Implementation)**

**Pros:**
- ✅ No manual password management
- ✅ Cryptographically secure (32+ characters)
- ✅ Automatically rotated on each deployment
- ✅ Stored in GCP Secret Manager

**Cons:**
- ❌ Passwords change on every deployment
- ❌ Need to retrieve passwords for application use

**Implementation:** Already configured in the workflow

### **Option 2: Fixed Strong Passwords with GitHub Secrets**

**Pros:**
- ✅ Stable passwords across deployments
- ✅ Easy to manage for applications
- ✅ Secure storage in GitHub Secrets

**Cons:**
- ❌ Manual password rotation
- ❌ Risk of password exposure in logs

**Setup:**
```bash
# Generate strong passwords
openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
```

### **Option 3: GCP Secret Manager Integration**

**Pros:**
- ✅ Centralized secret management
- ✅ Automatic rotation capabilities
- ✅ Fine-grained access control
- ✅ Audit logging

**Cons:**
- ❌ Additional complexity
- ❌ Requires IAM setup

**Setup:**
```bash
# Create secrets
gcloud secrets create cloudsql-root-password --replication-policy="automatic"
gcloud secrets create cloudsql-app-password --replication-policy="automatic"

# Add secret versions
echo "your-strong-password" | gcloud secrets versions add cloudsql-root-password --data-file=-
```

## 🛡️ **Production Security Checklist**

### **1. Network Security**
- ✅ Private network only (no public IP)
- ✅ VPC firewall rules
- ✅ Cloud Armor (if public access needed)

### **2. Authentication & Authorization**
- ✅ Workload Identity Federation
- ✅ Service account with minimal permissions
- ✅ IAM audit logging enabled

### **3. Encryption**
- ✅ Data encrypted at rest
- ✅ Data encrypted in transit (SSL/TLS)
- ✅ Customer-managed encryption keys (optional)

### **4. Monitoring & Logging**
- ✅ Cloud Logging enabled
- ✅ Cloud Monitoring alerts
- ✅ Security Command Center (if available)

### **5. Backup & Recovery**
- ✅ Automated backups enabled
- ✅ Point-in-time recovery
- ✅ Cross-region backup replication

## 🔧 **Production Environment Setup**

### **1. Create Production Environment**

```bash
# Create production directory structure
mkdir -p environments/production/prod
cp -r environments/non-prod/dev/* environments/production/prod/
```

### **2. Update Production Configuration**

```hcl
# environments/production/prod/main-local.tf
resource "google_sql_database_instance" "primary" {
  name             = "prod-sql-instance"
  database_version = "POSTGRES_16"
  region           = "australia-southeast1"

  settings {
    tier              = "db-perf-optimized-N-4"  # Larger instance for production
    availability_type = "REGIONAL"
    disk_autoresize   = true
    disk_size         = 100  # Larger disk
    disk_type         = "PD_SSD"

    backup_configuration {
      enabled    = true
      start_time = "02:00"  # Different backup window
    }

    ip_configuration {
      ipv4_enabled    = false
      private_network = "projects/affable-beaker-464822-b4/global/networks/default"
    }

    maintenance_window {
      day          = 7
      hour         = 2  # Different maintenance window
      update_track = "stable"
    }

    activation_policy            = "ALWAYS"
    deletion_protection_enabled = true
    user_labels = {
      environment = "production"
      owner       = "team"
      cost-center = "engineering"
    }
  }

  deletion_protection = true
}
```

### **3. Production Workflow**

```yaml
# .github/workflows/terraform-production.yml
name: Production Deployment

on:
  push:
    branches: [ "main" ]
    paths: [ "environments/production/**" ]
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Requires approval
    
    permissions:
      contents: 'read'
      id-token: 'write'

    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.8.2

      - name: Google Auth
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: 'projects/566479143581/locations/global/workloadIdentityPools/github-actions-pool/providers/github-provider'
          service_account: 'github-actions-sa@affable-beaker-464822-b4.iam.gserviceaccount.com'

      - name: Generate Strong Passwords
        id: passwords
        run: |
          ROOT_PASSWORD=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-32)
          echo "root_password=${ROOT_PASSWORD}" >> $GITHUB_OUTPUT
          APP_PASSWORD=$(openssl rand -base64 24 | tr -d "=+/" | cut -c1-32)
          echo "app_password=${APP_PASSWORD}" >> $GITHUB_OUTPUT

      - name: Terraform Plan
        run: terraform -chdir=environments/production/prod plan
        env:
          TF_VAR_sql_root_password: ${{ steps.passwords.outputs.root_password }}
          TF_VAR_sql_app_password: ${{ steps.passwords.outputs.app_password }}

      - name: Terraform Apply
        run: terraform -chdir=environments/production/prod apply -auto-approve
        env:
          TF_VAR_sql_root_password: ${{ steps.passwords.outputs.root_password }}
          TF_VAR_sql_app_password: ${{ steps.passwords.outputs.app_password }}
```

## 🔄 **Password Rotation Strategy**

### **Automatic Rotation (Recommended)**
- Passwords change on every deployment
- Use GCP Secret Manager to store current passwords
- Applications retrieve passwords from Secret Manager

### **Manual Rotation**
- Set fixed passwords in GitHub Secrets
- Rotate quarterly or on security events
- Use strong password generator

### **Hybrid Approach**
- Root password: Fixed (for admin access)
- App password: Auto-generated (for applications)

## 📊 **Monitoring & Alerting**

### **Essential Alerts**
```yaml
# Cloud Monitoring alerts
- High CPU usage (>80%)
- High memory usage (>80%)
- Disk space low (<20%)
- Failed connection attempts
- Backup failures
- Maintenance window issues
```

### **Log Analysis**
```bash
# Query CloudSQL logs
gcloud logging read "resource.type=cloudsql_database" --limit=50

# Monitor authentication failures
gcloud logging read "resource.type=cloudsql_database AND textPayload:authentication" --limit=20
```

## 🚨 **Security Best Practices**

1. **Never commit passwords to code**
2. **Use least privilege principle**
3. **Enable audit logging**
4. **Regular security scans**
5. **Incident response plan**
6. **Regular backup testing**
7. **Network segmentation**
8. **Encryption at rest and in transit**

## 📋 **Deployment Checklist**

- [ ] Environment-specific configurations
- [ ] Strong password generation
- [ ] Secret management setup
- [ ] Monitoring and alerting
- [ ] Backup configuration
- [ ] Security scanning
- [ ] Documentation
- [ ] Team training 