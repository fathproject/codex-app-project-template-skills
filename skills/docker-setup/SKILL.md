---
name: docker-setup
description: Use when containerization or Docker runtime setup is required, but pair it with environment and security skills before treating it as production-ready.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - docker
  - containerization
  - devops
tags:
  - docker
  - containerization
  - dockerfile
  - docker-compose
  - security
---

# Docker Setup Skill

## Status

Supporting containerization skill.

Use it together with:

1. `infra-environments`
2. `security-production-readiness`
3. `cicd-delivery`

This skill is strongest when the target runtime, deployment path, and secret model are already known.

## Overview

AI creates production-ready Docker configurations with multi-stage builds, security hardening, and optimization.

---

## Multi-Stage Dockerfile Templates

### Node.js Multi-Stage

```dockerfile
# syntax=docker/dockerfile:1

# ============================================
# Stage 1: Dependencies
# ============================================
FROM node:18-alpine AS deps

WORKDIR /app

COPY package*.json ./

RUN npm ci --only=production && \
    npm cache clean --force

# ============================================
# Stage 2: Builder
# ============================================
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

RUN npm run build

# ============================================
# Stage 3: Production
# ============================================
FROM node:18-alpine AS production

# Add labels
LABEL maintainer="team@example.com"
LABEL description="Application container"
LABEL version="1.0.0"

# Security: Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs

WORKDIR /app

# Copy only production dependencies
COPY --from=deps --chown=nodejs:nodejs /app/node_modules ./node_modules

# Copy built application
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/package.json ./

# Set environment
ENV NODE_ENV=production
ENV PORT=3000

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD node_modules/.bin/health-check || exit 1

# Switch to non-root user
USER nodejs

# Start application
CMD ["node", "dist/main.js"]
```

### Python Multi-Stage

```dockerfile
# syntax=docker/dockerfile:1

# ============================================
# Stage 1: Base
# ============================================
FROM python:3.11-slim AS base

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# ============================================
# Stage 2: Dependencies
# ============================================
FROM base AS deps

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ============================================
# Stage 3: Builder
# ============================================
FROM base AS builder

COPY --from=deps /install /usr/local

COPY . .

RUN pip install --no-cache-dir -e .

RUN python manage.py collectstatic --noinput

# ============================================
# Stage 4: Production
# ============================================
FROM base AS production

# Security: Create non-root user
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash appuser

COPY --from=deps /install /usr/local
COPY --from=builder /app .

RUN chown -R appuser:appuser /app

USER appuser

# Environment
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=config.settings.production

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "120", "config.wsgi:application"]
```

### Go Multi-Stage

```dockerfile
# syntax=docker/dockerfile:1

# ============================================
# Stage 1: Builder
# ============================================
FROM golang:1.21-alpine AS builder

WORKDIR /app

# Install dependencies
RUN apk add --no-cache git

# Copy go mod files
COPY go.mod go.sum ./
RUN go mod download

# Copy source code
COPY . .

# Build binary
RUN CGO_ENABLED=0 GOOS=linux go build \
    -ldflags="-w -s" \
    -o /app/server \
    ./cmd/server

# ============================================
# Stage 2: Production
# ============================================
FROM alpine:3.19 AS production

# Security labels
LABEL maintainer="team@example.com"
LABEL description="Go server"

# Install CA certificates
RUN apk --no-cache add ca-certificates tzdata

# Create non-root user
RUN addgroup -g 1001 -S appgroup && \
    adduser -S appuser -u 1001 -G appgroup

WORKDIR /app

# Copy binary from builder
COPY --from=builder /app/server .

# Copy static files if exists
COPY --from=builder /app/static ./static

# Set ownership
RUN chown -R appuser:appgroup /app

USER appuser

ENV GIN_MODE=release

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

CMD ["./server"]
```

---

## Docker Compose Templates

### Full Stack (Node + PostgreSQL + Redis + Nginx)

```yaml
# docker-compose.yml
version: '3.9'

services:
  # ==========================================
  # Application
  # ==========================================
  app:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    image: app:latest
    container_name: app
    restart: unless-stopped
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}
      - REDIS_URL=redis://redis:6379/0
      - JWT_SECRET=${JWT_SECRET}
    env_file:
      - .env.production
    volumes:
      - app_data:/app/data
    networks:
      - backend
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
        reservations:
          cpus: '0.25'
          memory: 256M

  # ==========================================
  # Database
  # ==========================================
  db:
    image: postgres:15-alpine
    container_name: app_db
    restart: unless-stopped
    environment:
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: ${DB_NAME}
      PGDATA: /var/lib/postgresql/data/pgdata
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backups:/backups
    networks:
      - backend
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 10s
    command: >
      postgres
      -c max_connections=100
      -c shared_buffers=256MB
      -c effective_cache_size=512MB
      -c maintenance_work_mem=64MB
      -c checkpoint_completion_target=0.9
      -c wal_buffers=16MB
      -c default_statistics_target=100

  # ==========================================
  # Redis
  # ==========================================
  redis:
    image: redis:7-alpine
    container_name: app_redis
    restart: unless-stopped
    command: >
      redis-server
      --appendonly yes
      --appendfsync everysec
      --maxmemory 256mb
      --maxmemory-policy allkeys-lru
    volumes:
      - redis_data:/data
    networks:
      - backend
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  # ==========================================
  # Nginx
  # ==========================================
  nginx:
    image: nginx:alpine
    container_name: app_nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
      - ./nginx/logs:/var/log/nginx
      - static_files:/usr/share/nginx/html:ro
    depends_on:
      - app
    networks:
      - backend
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost/health"]
      interval: 30s
      timeout: 5s
      retries: 3

  # ==========================================
  # Worker (for background jobs)
  # ==========================================
  worker:
    build:
      context: .
      dockerfile: Dockerfile
      target: production
    image: app:worker
    container_name: app_worker
    restart: unless-stopped
    command: python manage.py qcluster
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@db:5432/${DB_NAME}
      - REDIS_URL=redis://redis:6379/0
    env_file:
      - .env.production
    networks:
      - backend

  # ==========================================
  # Monitoring
  # ==========================================
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--web.console.libraries=/etc/prometheus/console_libraries'
      - '--web.console.templates=/etc/prometheus/consoles'
    networks:
      - backend

# ==========================================
# Networks
# ==========================================
networks:
  backend:
    driver: bridge

# ==========================================
# Volumes
# ==========================================
volumes:
  postgres_data:
  redis_data:
  app_data:
  prometheus_data:
  static_files:
```

---

## Docker Security Best Practices

### Security Checklist

```dockerfile
# Security practices in Dockerfile

# 1. Use specific base image versions
FROM node:18.19.0-alpine3.19  # ✅ Specific version
# FROM node:latest              # ❌ Floating tag

# 2. Use non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001 -G nodejs
USER nodejs

# 3. Read-only filesystem
# docker-compose.yml
read_only: true
tmpfs:
  - /tmp

# 4. No secrets in Dockerfile
# ❌ ENV DATABASE_PASSWORD=secret
# ✅ Use secrets at runtime: docker secret or env_file

# 5. Health checks
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

# 6. Multi-stage builds (no build tools in production)

# 7. Scan images
# docker scout cves image:tag
# trivy image image:tag
```

### .dockerignore

```
# Git
.git
.gitignore
.env
.env.*
!.env.example

# Documentation
README.md
LICENSE
docs/
*.md

# Development
.dockerignore
Dockerfile*
docker-compose*
.docker
.dockerignore

# Tests
tests/
coverage/
*.test.js
*.spec.js
__tests__/

# Development files
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.vuepress/
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
```

---

## Docker Build Commands

```bash
# Build image
docker build -t app:latest .

# Build with multiple tags
docker build -t app:latest -t app:1.0.0 -t app:$(git rev-parse --short HEAD) .

# Build with build args
docker build --build-arg VERSION=1.0.0 -t app:1.0.0 .

# Build with secrets (for private packages)
docker build --secret id=npm,src=.npmrc .

# Build and push to registry
docker build -t ghcr.io/org/app:latest .
docker push ghcr.io/org/app:latest

# Multi-platform build
docker buildx create --use
docker buildx build --platform linux/amd64,linux/arm64 -t app:latest --push .

# Prune unused images
docker image prune -f

# Remove all unused images, containers, volumes
docker system prune -a --volumes
```

---

## Docker Compose Commands

```bash
# Start services
docker-compose up -d

# Start with rebuild
docker-compose up -d --build

# Start specific service
docker-compose up -d app db

# View logs
docker-compose logs -f app
docker-compose logs -f --tail=100 app

# Scale service
docker-compose up -d --scale app=3

# Stop and remove
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Restart services
docker-compose restart app

# Pull latest images
docker-compose pull

# Check status
docker-compose ps

# Execute command in container
docker-compose exec app node --version

# Database migration
docker-compose exec app npm run migrate

# Backup database
docker-compose exec db pg_dump -U user app > backup.sql

# Restore database
docker-compose exec -T db psql -U user app < backup.sql
```

---

## Kubernetes Deployment

### Basic Kubernetes Objects

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  labels:
    app: app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: app
          image: ghcr.io/org/app:latest
          ports:
            - containerPort: 3000
          resources:
            requests:
              memory: "256Mi"
              cpu: "100m"
            limits:
              memory: "512Mi"
              cpu: "500m"
```

### Helm Chart Structure

```
helm/
├── Chart.yaml
├── values.yaml
├── values.staging.yaml
├── values.production.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── secret.yaml
│   └── _helpers.tpl
└── .helmignore
```

---

## Registry Setup

### GitHub Container Registry

```bash
# Login to GHCR
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Tag image
docker tag app:latest ghcr.io/username/app:latest

# Push
docker push ghcr.io/username/app:latest

# View packages
# https://github.com/users/USERNAME/packages/container/app
```

### Docker Hub

```bash
# Login
docker login -u USERNAME

# Tag
docker tag app:latest username/app:latest

# Push
docker push username/app:latest
```

---

*Docker Setup Skill v1.0.0*
