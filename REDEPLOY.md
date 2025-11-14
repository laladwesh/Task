# ArcadeDB GKE Redeployment Guide

Quick reference for deploying ArcadeDB on Google Kubernetes Engine (GKE).

---

## Prerequisites

```bash
# Verify tools installed
gcloud --version
kubectl version --client
```

---

## Step 1: GCP Authentication and Setup

```bash
# Login to GCP
gcloud auth login

# Set your project ID (replace with your actual project)
gcloud config set project YOUR_PROJECT_ID

# Verify current project
gcloud config get-value project
```

---

## Step 2: Create GKE Cluster

```bash
# Create cluster (2 nodes, e2-medium, asia-south1-a)
gcloud container clusters create arcadedb-cluster \
  --zone=asia-south1-a \
  --num-nodes=2 \
  --machine-type=e2-medium \
  --disk-size=10GB

# Wait 5-8 minutes for cluster creation
```

---

## Step 3: Configure kubectl

```bash
# Get cluster credentials
gcloud container clusters get-credentials arcadedb-cluster --zone=asia-south1-a

# Verify connection
kubectl cluster-info
kubectl get nodes
```

---

## Step 4: Deploy ArcadeDB

```bash
# Apply deployment manifest (creates deployment, PVC, secret)
kubectl apply -f deployment.yaml

# Apply service manifest (creates LoadBalancer service)
kubectl apply -f service.yaml
```

---

## Step 5: Verify Deployment

```bash
# Check all resources
kubectl get all

# Check pods (wait for Running status)
kubectl get pods

# Check persistent volume claim
kubectl get pvc

# Check services (wait for EXTERNAL-IP)
kubectl get services

# Watch service until external IP is assigned (2-3 minutes)
kubectl get service arcadedb-service -w
```

Press `Ctrl+C` to stop watching once EXTERNAL-IP appears.

---

## Step 6: Check Logs

```bash
# View deployment logs
kubectl logs deployment/arcadedb-deployment --tail=100

# View specific pod logs (replace POD_NAME)
kubectl get pods
kubectl logs <POD_NAME> --tail=200

# Follow logs in real-time
kubectl logs deployment/arcadedb-deployment --follow
```

---

## Step 7: Access ArcadeDB Studio

```bash
# Get external IP
kubectl get service arcadedb-service

# Look for EXTERNAL-IP column (e.g., 34.100.130.178)
```

Open browser:
```
http://<EXTERNAL-IP>:2480
```

Login credentials:
- Username: `root`
- Password: `arcadedb`

---

## Troubleshooting Commands

### Pod Not Starting

```bash
# Describe pod for detailed events
kubectl describe pod <POD_NAME>

# Check pod logs for errors
kubectl logs <POD_NAME> --previous
```

### External IP Stuck on "Pending"

```bash
# Check service details
kubectl describe service arcadedb-service

# Verify LoadBalancer provisioning
kubectl get events --sort-by='.lastTimestamp'

# If stuck > 5 minutes, delete and recreate service
kubectl delete service arcadedb-service
kubectl apply -f service.yaml
```

### Persistent Volume Issues

```bash
# Check PVC status
kubectl get pvc

# Describe PVC for binding issues
kubectl describe pvc arcadedb-pvc
```

### General Debugging

```bash
# Get all resources in namespace
kubectl get all

# Check cluster events
kubectl get events --sort-by='.lastTimestamp' | tail -20

# Check node status
kubectl get nodes
kubectl describe nodes
```

---

## Update Deployment

If you modify `deployment.yaml` or `service.yaml`:

```bash
# Apply changes
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Force rollout restart (if needed)
kubectl rollout restart deployment/arcadedb-deployment

# Check rollout status
kubectl rollout status deployment/arcadedb-deployment
```

---

## Scale Deployment

```bash
# Scale to 2 replicas
kubectl scale deployment arcadedb-deployment --replicas=2

# Verify scaling
kubectl get pods
```

---

## Delete Deployment (Keep Cluster)

```bash
# Delete service and deployment
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml

# Verify deletion
kubectl get all
```

---

## Delete Entire Cluster (Stop Billing)

```bash
# Delete cluster completely
gcloud container clusters delete arcadedb-cluster --zone=asia-south1-a

# Confirm when prompted: y
```

**Warning:** This deletes all data. Back up before deleting.

---

## Backup Data Before Deletion

```bash
# Copy data from pod to local machine
kubectl cp <POD_NAME>:/home/arcadedb/data ./backup-data

# Or export databases via Studio UI before deleting
```

---

## Quick Redeploy (All Steps)

Copy-paste this entire block for fast redeploy:

```bash
# Set project
gcloud config set project YOUR_PROJECT_ID

# Create cluster
gcloud container clusters create arcadedb-cluster \
  --zone=asia-south1-a \
  --num-nodes=2 \
  --machine-type=e2-medium \
  --disk-size=10GB

# Get credentials
gcloud container clusters get-credentials arcadedb-cluster --zone=asia-south1-a

# Deploy
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# Wait and check
sleep 60
kubectl get all
kubectl get service arcadedb-service
```

Then check external IP:
```bash
kubectl get service arcadedb-service
```

---

## Cost Estimate

Running this cluster costs approximately:
- **GKE Management:** ~$0.10/hour
- **2x e2-medium nodes:** ~$0.067/hour total
- **LoadBalancer:** ~$0.025/hour
- **Storage (10GB):** ~$0.0002/hour
- **Total:** ~$0.19/hour (~$140/month if left running)

**Remember to delete the cluster after demo/testing to avoid charges!**

---

## Common Issues and Fixes

### Issue: "ERROR: (gcloud.container.clusters.create) PERMISSION_DENIED"
**Fix:** Enable Kubernetes Engine API in GCP Console or run:
```bash
gcloud services enable container.googleapis.com
```

### Issue: Pod stuck in "ImagePullBackOff"
**Fix:** Check image name in `deployment.yaml`, ensure it's `arcadedata/arcadedb:latest`

### Issue: Pod stuck in "CrashLoopBackOff"
**Fix:** Check logs:
```bash
kubectl logs <POD_NAME>
```
Usually caused by misconfigured environment variables or missing password setting.

### Issue: Cannot access external IP
**Fix:** 
1. Wait 5 minutes for LoadBalancer provisioning
2. Check firewall rules in GCP Console (allow port 2480)
3. Verify service type is LoadBalancer:
```bash
kubectl get service arcadedb-service -o yaml | grep type
```

---

## Interview Demo Flow

1. Show cluster creation command
2. Show `kubectl get nodes` output
3. Show `kubectl apply` commands
4. Show `kubectl get all` output
5. Show external IP retrieval
6. Open Studio in browser at external IP
7. Show screenshots if cluster is deleted

---

## Useful kubectl Shortcuts

```bash
# Short aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kga='kubectl get all'
alias klog='kubectl logs'
alias kdesc='kubectl describe'

# Use them
kgp
kgs
kga
```

---

## Next Steps After Deployment

1. Create database in Studio UI
2. Import sample data from `sample-data/` folder
3. Run queries from `SCREENSHOT_QUERIES.sql`
4. Take screenshots for documentation
5. Delete cluster when done

---

**End of Guide**
