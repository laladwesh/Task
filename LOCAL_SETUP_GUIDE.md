# Local Setup Guide

This guide provides instructions for deploying ArcadeDB locally using Docker.

## Prerequisites

- Docker Desktop installed and running
- At least 2GB of available RAM
- Port 2480 available on localhost

## Setup Steps

### 1. Start Docker Desktop

Ensure Docker Desktop is running on your system before proceeding.

### 2. Navigate to Project Directory

```bash
cd path/to/project
```

### 3. Start ArcadeDB Container

```bash
docker-compose up -d
```

This command will:
- Pull the ArcadeDB image if not already available
- Create and start the container
- Configure memory settings (2GB max, 512MB min)
- Set root password to 'arcadedb'

### 4. Verify Container Status

```bash
docker ps
```

You should see `arcadedb-server` container running.

### 5. Access ArcadeDB Studio

Open your browser and navigate to:
```
http://localhost:2480
```

Login credentials:
- Username: `root`
- Password: `arcadedb`

## Configuration Details

The docker-compose.yml file includes:

```yaml
environment:
  JAVA_OPTS: -Xmx2G -Xms512M -Darcadedb.server.rootPassword=arcadedb
```

This configuration:
- Sets maximum heap memory to 2GB
- Sets initial heap memory to 512MB
- Configures root password to avoid interactive prompts

## Stopping the Container

```bash
docker-compose down
```

## Troubleshooting

**Container exits immediately:**
- Check if port 2480 is already in use
- Verify Docker has sufficient memory allocated

**Cannot access Studio:**
- Wait 30 seconds after container start for initialization
- Check container logs: `docker logs arcadedb-server`

**Password not working:**
- Ensure the JAVA_OPTS environment variable includes the password setting
- Restart the container if configuration was changed
