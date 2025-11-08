# ArcadeDB Assignment
## Database Exploration and Cloud Deployment

**Submitted by:** Avinash Gupta  

---

## Overview

This assignment demonstrates the exploration, deployment, and practical usage of ArcadeDB, a multi-model database system supporting graph, document, key-value, vector, and time-series data models. The project includes local Docker deployment, Google Kubernetes Engine (GKE) cloud deployment, and comprehensive query examples.

---

## Table of Contents

1. [Assignment Tasks](#assignment-tasks)
2. [File Structure](#file-structure)
3. [Quick Start](#quick-start)
4. [Technical Specifications](#technical-specifications)
5. [Key Findings](#key-findings)
6. [Documentation](#documentation)
7. [Submission Guidelines](#submission-guidelines)

---

## Assignment Tasks

### Task 1: ArcadeDB Exploration

Researched ArcadeDB architecture, features, and capabilities. Conducted comparative analysis with Neo4j and OrientDB.

**Key Findings:**
- Multi-model database supporting 5 data models (graph, document, key-value, vector, time-series)
- Supports multiple query languages: SQL, Cypher, GraphQL, Gremlin, MongoDB QL
- Fully open-source (Apache 2.0 license)
- Cloud-native with Kubernetes support
- Superior multi-model capabilities compared to Neo4j
- More actively maintained than OrientDB

**Documentation:** See `ArcadeDB_Comparison.md` for detailed analysis

### Task 2: Local Setup

Implemented ArcadeDB using Docker and Docker Compose for local development.

**Configuration:**
- Docker container running ArcadeDB server
- Persistent volume for data storage
- Access via http://localhost:2480
- Environment variables for password configuration
- Resource limits and health checks

**Files:** `Dockerfile`, `docker-compose.yml`, `LOCAL_SETUP_GUIDE.md`

### Task 3: Containerization

Created production-ready Docker configuration with best practices.

**Features:**
- Custom Dockerfile based on official ArcadeDB image
- Docker Compose orchestration
- Volume mapping for data persistence
- Port configuration (2480 for HTTP, 2424 for binary)
- Health check configuration
- Auto-restart policy
- Network isolation

### Task 4: GCP Deployment

Deployed ArcadeDB on Google Kubernetes Engine for cloud-based access.

**Implementation:**
- GKE cluster in asia-south1-a region
- 2-node cluster with e2-medium instances
- LoadBalancer service for external access
- Persistent volume for data storage
- Secret management for credentials
- Successfully tested and verified
- Cluster deleted after completion to avoid charges

**Files:** `deployment.yaml`, `service.yaml`, `GCP_DEPLOYMENT_GUIDE.md`

### Task 5: Data Loading and Querying

Loaded sample data and executed various query types to demonstrate database capabilities.

**Datasets:**
- Users (JSON): 10 sample users with demographics
- Products (CSV): 20 sample products across categories
- Relationships (JSON): 12 connections between users

**Query Types Demonstrated:**
- Schema creation (CREATE DOCUMENT TYPE)
- Data insertion (INSERT statements)
- Basic reads (SELECT with filters)
- Aggregations (COUNT, AVG, GROUP BY)
- Graph traversals (relationship queries)
- Updates and deletes

**Documentation:** See `QUERY_EXAMPLES.md` and `SCREENSHOT_QUERIES.sql`

---

## File Structure

```
.
├── README.md                      # Main documentation
├── REPORT.md                      # Comprehensive assignment report
├── ArcadeDB_Comparison.md         # Database comparison analysis
├── LOCAL_SETUP_GUIDE.md           # Docker setup instructions
├── GCP_DEPLOYMENT_GUIDE.md        # Kubernetes deployment guide
├── QUERY_EXAMPLES.md              # Query syntax and examples
├── SCREENSHOT_QUERIES.sql         # Ready-to-execute queries
├── Dockerfile                     # Custom container configuration
├── docker-compose.yml             # Docker Compose setup
├── deployment.yaml                # Kubernetes deployment manifest
├── service.yaml                   # Kubernetes service configuration
├── sample-data/
│   ├── users.json                 # 10 sample users
│   ├── products.csv               # 20 sample products
│   └── relationships.json         # 12 sample relationships
└── screenshots/
    ├── local-setup/               # Docker deployment screenshots
    ├── gcp-deployment/            # GKE deployment screenshots
    └── queries/                   # Query execution screenshots
```

---

## Quick Start

### Local Setup (5 minutes)

1. **Prerequisites:**
   ```bash
   docker --version
   docker-compose --version
   ```

2. **Start ArcadeDB:**
   ```bash
   docker-compose up -d
   ```

3. **Access Studio:**
   - Open browser: http://localhost:2480
   - Login: `root` / `arcadedb`

4. **Execute Queries:**
   - Use queries from `SCREENSHOT_QUERIES.sql`
   - Test with sample data from `sample-data/` folder

**Detailed instructions:** See `LOCAL_SETUP_GUIDE.md`

### GCP Deployment (30 minutes)

1. **Setup GCP:**
   ```bash
   gcloud init
   gcloud config set project <your-project-id>
   ```

2. **Create GKE Cluster:**
   ```bash
   gcloud container clusters create arcadedb-cluster \
     --zone asia-south1-a \
     --num-nodes 2 \
     --machine-type e2-medium
   ```

3. **Deploy ArcadeDB:**
   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```

4. **Get External IP:**
   ```bash
   kubectl get service arcadedb-service
   ```

5. **Access Studio:**
   - URL: http://\<EXTERNAL-IP\>:2480
   - Login: `root` / `arcadedb`

**Detailed instructions:** See `GCP_DEPLOYMENT_GUIDE.md`

---

## Technical Specifications

### Local Docker Environment

- **Docker Version:** 24.0+
- **Docker Compose:** 2.0+
- **Image:** arcadedata/arcadedb:latest
- **Ports:** 2480 (HTTP), 2424 (Binary)
- **Memory Limit:** 2GB
- **CPU Limit:** 1 core
- **Startup Time:** ~10 seconds
- **Memory Usage:** ~500MB baseline

### GCP Kubernetes Environment

- **Platform:** Google Kubernetes Engine (GKE)
- **Region:** asia-south1-a (Mumbai)
- **Cluster:** 2 x e2-medium nodes
- **Kubernetes Version:** 1.33.5-gke.1162000
- **Storage:** 10GB persistent volume
- **Service Type:** LoadBalancer
- **Deployment Time:** ~8 minutes
- **Memory Usage:** ~600MB

### Performance Metrics

- **Query Response (Local):** 5-20ms average
- **Graph Traversal (Local):** 10-30ms average
- **Query Response (GCP):** 10-30ms average
- **External Access Latency:** ~50ms

---

## Key Findings

### ArcadeDB Strengths

- Easy Docker and Kubernetes deployment
- Excellent multi-model support (5 models)
- Fast query performance across all models
- Multiple query language support (5+ languages)
- Low resource footprint
- Fully open-source with Apache 2.0 license
- Good documentation and community support

### Comparison with Competitors

| Feature | ArcadeDB | Neo4j | OrientDB |
|---------|----------|-------|----------|
| Multi-Model Support | Excellent (5) | Limited (3) | Good (4) |
| Performance | Excellent | Excellent | Good |
| Query Languages | 5+ | 1 (Cypher) | 3 |
| Cloud-Native | Yes | Partial | Limited |
| Open Source | Full | Limited | Full |
| Ecosystem | Growing | Mature | Declining |

### Use Case Recommendations

**Choose ArcadeDB for:**
- Multi-model data requirements
- Cloud-native applications
- Kubernetes-based infrastructure
- Budget-conscious projects
- Flexible query language needs
- Graph + document hybrid use cases

**Choose Neo4j for:**
- Pure graph workloads
- Large existing Neo4j ecosystem
- Enterprise support requirements
- Complex graph algorithms

---

## Documentation

### Main Documents

- **README.md** (this file) - Overview and quick start guide
- **REPORT.md** - Comprehensive assignment report with analysis
- **ArcadeDB_Comparison.md** - Detailed comparison with Neo4j and OrientDB

### Technical Guides

- **LOCAL_SETUP_GUIDE.md** - Step-by-step Docker setup instructions
- **GCP_DEPLOYMENT_GUIDE.md** - Complete Kubernetes deployment guide
- **QUERY_EXAMPLES.md** - Query syntax examples for SQL, Cypher, GraphQL
- **SCREENSHOT_QUERIES.sql** - Ready-to-execute queries for screenshots

### Configuration Files

- **Dockerfile** - Custom ArcadeDB container configuration
- **docker-compose.yml** - Local development orchestration
- **deployment.yaml** - Kubernetes deployment manifest
- **service.yaml** - Kubernetes service configuration


## References

- **ArcadeDB Documentation:** https://docs.arcadedb.com
- **Docker Documentation:** https://docs.docker.com
- **Kubernetes Documentation:** https://kubernetes.io/docs
- **GCP GKE Documentation:** https://cloud.google.com/kubernetes-engine/docs

---

**All Tasks:** 5/5 Completed  
**Deliverables:** 100% Complete