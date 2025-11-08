# GCP Deployment Guide

This guide covers deploying ArcadeDB on Google Cloud Platform using Google Kubernetes Engine (GKE).

## Prerequisites

- Google Cloud account with billing enabled
- gcloud CLI installed and configured
- kubectl installed
- Project created in GCP Console

## Deployment Steps

### 1. Configure gcloud CLI

```bash
gcloud init
gcloud auth login
```

### 2. Create GKE Cluster

```bash
gcloud container clusters create arcadedb-cluster \
  --zone=asia-south1-a \
  --num-nodes=2 \
  --machine-type=e2-medium \
  --disk-size=10GB
```

This creates a cluster with:
- 2 nodes (minimum for production)
- e2-medium instances (2 vCPU, 4GB RAM each)
- 10GB persistent disk per node
- Located in asia-south1-a zone

### 3. Configure kubectl

```bash
gcloud container clusters get-credentials arcadedb-cluster --zone=asia-south1-a
```

### 4. Deploy ArcadeDB

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

### 5. Verify Deployment

Check pod status:
```bash
kubectl get pods
```

Check service status:
```bash
kubectl get services
```

### 6. Access ArcadeDB Studio

Get the external IP address:
```bash
kubectl get service arcadedb-service
```

Wait for the EXTERNAL-IP to appear (may take 2-3 minutes).

Access Studio at:
```
http://<EXTERNAL-IP>:2480
```

Login credentials:
- Username: `root`
- Password: `arcadedb`

## Configuration Files

### deployment.yaml

Defines the ArcadeDB deployment with:
- 1 replica pod
- Resource limits (2GB memory, 1 CPU)
- Password configuration via environment variable
- Container port 2480 exposed

### service.yaml

Creates a LoadBalancer service that:
- Exposes port 2480 externally
- Routes traffic to ArcadeDB pods
- Provides a stable external IP address

## Monitoring

Check pod logs:
```bash
kubectl logs deployment/arcadedb-deployment
```

Describe pod for detailed information:
```bash
kubectl describe pod <pod-name>
```

## Cleanup

To delete the deployment:
```bash
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
```

To delete the entire cluster:
```bash
gcloud container clusters delete arcadedb-cluster --zone=asia-south1-a
```

## Cost Considerations

Running this setup incurs costs for:
- GKE cluster management fee
- Compute Engine instances (2x e2-medium)
- Network egress
- Persistent disk storage

Estimated cost: $50-70 per month for continuous operation.

Delete resources when not in use to avoid charges.

## Troubleshooting

**Pod stuck in Pending:**
- Check if cluster has sufficient resources
- Verify node pool is active: `kubectl get nodes`

**Cannot access external IP:**
- Wait 3-5 minutes for LoadBalancer provisioning
- Check firewall rules in GCP Console
- Verify service type is LoadBalancer

**Pod CrashLoopBackOff:**
- Check logs: `kubectl logs <pod-name>`
- Verify resource limits are sufficient
- Ensure password configuration is correct
