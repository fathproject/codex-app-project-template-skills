---
name: cicd-delivery
description: Use when CI/CD pipelines or delivery automation must be designed or updated, but pair it with release, security, and environment skills for production use.
version: 1.0.0
created: 2026-04-07
author: User
license: MIT
compatibility:
  - codex app
categories:
  - cicd
  - devops
  - deployment
  - automation
tags:
  - cicd
  - github-actions
  - gitlab-ci
  - docker
  - kubernetes
  - deployment
  - automation
---

# CI/CD & Delivery Skill

## Status

Supporting delivery-automation skill.

Use it together with:

1. `infra-environments`
2. `security-production-readiness`
3. `qa-e2e-release`

This skill is strongest once the stack and release path are already known.

## Overview

AI creates complete CI/CD pipelines for automated build, test, and deployment. Supports multiple platforms and deployment targets.

---

## Part 1: CI/CD Pipeline Templates

### GitHub Actions - Node.js

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

env:
  NODE_VERSION: '18'
  NODE_ENV: test

jobs:
  lint:
    name: Lint Code
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run linter
        run: npm run lint
      
      - name: Check formatting
        run: npm run format:check

  test:
    name: Test
    runs-on: ubuntu-latest
    needs: lint
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test_db
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      
      redis:
        image: redis:7
        ports:
          - 6379:6379

    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Run tests
        run: npm test
        env:
          DATABASE_URL: postgresql://test:test@localhost:5432/test_db
          REDIS_URL: redis://localhost:6379
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info
          fail_ci_if_error: true
          verbose: true
      
      - name: Run mutation tests
        run: npm run test:mutation
        if: github.event_name == 'pull_request'

  build:
    name: Build Docker Image
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=sha,prefix=
            type=ref,event=branch
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/develop'
    environment: staging
    
    steps:
      - name: Deploy to staging
        run: |
          # kubectl rollout restart deployment/app-staging -n staging
          echo "Deploying to staging..."
      
      - name: Verify deployment
        run: |
          curl -f https://staging.example.com/health || exit 1

  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    environment: production
    
    steps:
      - name: Deploy to production
        run: |
          # kubectl rollout restart deployment/app-prod -n production
          echo "Deploying to production..."
      
      - name: Verify deployment
        run: |
          curl -f https://example.com/health || exit 1
      
      - name: Notify success
        if: success()
        run: |
          echo "✅ Deployment successful!"

      - name: Notify failure
        if: failure()
        run: |
          echo "❌ Deployment failed!"
```

### GitHub Actions - Python/FastAPI

```yaml
# .github/workflows/python-ci.yml
name: Python CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  lint:
    name: Lint & Type Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install ruff mypy black
      
      - name: Run ruff (linter)
        run: ruff check .
      
      - name: Run mypy (type check)
        run: mypy src/
      
      - name: Check formatting
        run: black --check .

  test:
    name: Test
    runs-on: ubuntu-latest
    needs: lint
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: test_db
        ports:
          - 5432:5432
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install -e ".[dev]"
      
      - name: Run pytest
        run: pytest --cov=src --cov-report=xml
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3

  build:
    name: Build & Push
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKERHUB_USERNAME }}/app:latest
            ${{ secrets.DOCKERHUB_USERNAME }}/app:${{ github.sha }}

  deploy:
    name: Deploy
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/main'
    
    steps:
      - name: Deploy to server
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SERVER_SSH_KEY }}
          script: |
            cd /app
            docker-compose pull
            docker-compose up -d
            docker-compose exec -T app alembic upgrade head
```

### GitHub Actions - Multi-Environment Deploy

```yaml
# .github/workflows/deploy.yml
name: Deploy

on:
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        type: choice
        options:
          - staging
          - production

jobs:
  deploy:
    name: Deploy to ${{ inputs.environment }}
    runs-on: ubuntu-latest
    environment: ${{ inputs.environment }}
    
    environment:
      name: ${{ inputs.environment }}
      url: ${{ inputs.environment == 'production' && 'https://app.com' || 'https://staging.app.com' }}
    
    steps:
      - name: Checkout
        uses: actions/checkout@v4
      
      - name: Deploy
        run: |
          echo "Deploying to ${{ inputs.environment }}"
          
          case ${{ inputs.environment }} in
            staging)
              # Deploy to staging
              kubectl apply -f k8s/staging/
              ;;
            production)
              # Blue-green deploy to production
              kubectl apply -f k8s/production/
              kubectl rollout status deployment/app -n production
              ;;
          esac
```

---

## Part 2: Docker Configuration

### Dockerfile - Node.js

```dockerfile
# Dockerfile
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

RUN npm run build

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./

USER node

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3000/health || exit 1

CMD ["node", "dist/main.js"]
```

### Dockerfile - Python

```dockerfile
# Dockerfile
FROM python:3.11-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN pip install --no-cache-dir -e .

RUN python manage.py collectstatic --noinput

# Production stage
FROM python:3.11-slim AS production

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /app /app

USER nobody

EXPOSE 8000

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:8000/health/ || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "120", "config.wsgi:application"]
```

### docker-compose.yml

```yaml
# docker-compose.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    image: app:latest
    container_name: app
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:pass@db:5432/app
      - REDIS_URL=redis://redis:6379
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

  db:
    image: postgres:15-alpine
    container_name: app-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: app
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d app"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: app-redis
    restart: unless-stopped
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

  nginx:
    image: nginx:alpine
    container_name: app-nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - ./ssl:/etc/nginx/ssl:ro
    depends_on:
      - app

volumes:
  postgres_data:
  redis_data:
```

---

## Part 3: Kubernetes Deployment

### deployment.yaml

```yaml
# k8s/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: production
  labels:
    app: app
    version: v1
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
        version: v1
    spec:
      containers:
        - name: app
          image: ghcr.io/org/app:latest
          imagePullPolicy: Always
          ports:
            - containerPort: 3000
              name: http
          
          env:
            - name: NODE_ENV
              value: "production"
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: app-secrets
                  key: database-url
          
          resources:
            requests:
              cpu: 100m
              memory: 256Mi
            limits:
              cpu: 500m
              memory: 512Mi
          
          livenessProbe:
            httpGet:
              path: /health
              port: 3000
            initialDelaySeconds: 30
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
          
          readinessProbe:
            httpGet:
              path: /ready
              port: 3000
            initialDelaySeconds: 5
            periodSeconds: 5
            timeoutSeconds: 3
            failureThreshold: 3
          
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sh", "-c", "sleep 10"]
```

### service.yaml

```yaml
# k8s/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: app-service
  namespace: production
spec:
  selector:
    app: app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: ClusterIP

---
apiVersion: v1
kind: Service
metadata:
  name: app-loadbalancer
  namespace: production
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
spec:
  selector:
    app: app
  ports:
    - protocol: TCP
      port: 443
      targetPort: 3000
  type: LoadBalancer
```

### ingress.yaml

```yaml
# k8s/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: production
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/rate-limit: "100"
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
spec:
  tls:
    - hosts:
        - app.com
        - www.app.com
      secretName: app-tls
  rules:
    - host: app.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: app-service
                port:
                  number: 80
```

### horizontal-pod-autoscaler.yaml

```yaml
# k8s/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: app-hpa
  namespace: production
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: app
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
```

---

## Part 4: Deployment Scripts

### Deploy Script

```bash
#!/bin/bash
# scripts/deploy.sh

set -e

ENVIRONMENT=${1:-staging}
APP_NAME="app"
DOCKER_IMAGE="ghcr.io/org/${APP_NAME}"
TAG=${2:-latest}

echo "🚀 Deploying ${APP_NAME}:${TAG} to ${ENVIRONMENT}"

# Pull latest image
docker pull ${DOCKER_IMAGE}:${TAG}

# Tag for environment
docker tag ${DOCKER_IMAGE}:${TAG} ${DOCKER_IMAGE}:${ENVIRONMENT}

# Deploy based on environment
case ${ENVIRONMENT} in
  staging)
    kubectl config use-context staging
    kubectl set image deployment/${APP_NAME} app=${DOCKER_IMAGE}:${TAG} -n staging
    kubectl rollout status deployment/${APP_NAME} -n staging --timeout=5m
    echo "✅ Deployed to staging"
    ;;
  
  production)
    kubectl config use-context production
    
    # Blue-green deployment
    kubectl label deployment/${APP_NAME} version=blue -n production --overwrite
    kubectl scale deployment/${APP_NAME} --replicas=0 -n production
    sleep 30
    
    kubectl set image deployment/${APP_NAME} app=${DOCKER_IMAGE}:${TAG} -n production
    kubectl rollout status deployment/${APP_NAME} -n production --timeout=10m
    
    # Run migrations
    kubectl exec -n production deployment/${APP_NAME} -- python manage.py migrate
    
    kubectl label deployment/${APP_NAME} version=green -n production --overwrite
    kubectl scale deployment/${APP_NAME} --replicas=3 -n production
    
    echo "✅ Deployed to production"
    ;;
esac

# Health check
sleep 10
curl -f https://${ENVIRONMENT}.app.com/health || exit 1

echo "🎉 Deployment complete!"
```

### Rollback Script

```bash
#!/bin/bash
# scripts/rollback.sh

set -e

ENVIRONMENT=${1:-staging}
APP_NAME="app"

echo "🔄 Rolling back ${APP_NAME} in ${ENVIRONMENT}"

case ${ENVIRONMENT} in
  staging|production)
    kubectl config use-context ${ENVIRONMENT}
    kubectl rollout undo deployment/${APP_NAME} -n ${ENVIRONMENT}
    kubectl rollout status deployment/${APP_NAME} -n ${ENVIRONMENT} --timeout=5m
    ;;
  
  *)
    echo "❌ Unknown environment: ${ENVIRONMENT}"
    exit 1
    ;;
esac

echo "✅ Rollback complete!"
```

### Database Migration Script

```bash
#!/bin/bash
# scripts/migrate.sh

set -e

COMMAND=${1:-up}

echo "📊 Running migrations: ${COMMAND}"

case ${COMMAND} in
  up)
    alembic upgrade head
    ;;
  down)
    alembic downgrade -1
    ;;
  reset)
    read -p "This will reset the database. Continue? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      alembic downgrade base
      alembic upgrade head
    fi
    ;;
  status)
    alembic current
    alembic history
    ;;
esac

echo "✅ Migrations complete!"
```

---

## Part 5: Deployment Checklist

### Pre-Deployment Checklist

```markdown
## Pre-Deployment Checklist

### Code
- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] No linting errors
- [ ] Type check passed
- [ ] Security scan clean

### Database
- [ ] Migrations tested
- [ ] Rollback plan ready
- [ ] Backup taken

### Configuration
- [ ] Environment variables configured
- [ ] Secrets updated
- [ ] Feature flags set

### Infrastructure
- [ ] Servers reachable
- [ ] DNS configured
- [ ] SSL certificates valid
- [ ] Monitoring active

### Communication
- [ ] Team notified
- [ ] Stakeholders aware
- [ ] Rollback plan communicated

### Validation
- [ ] Smoke tests ready
- [ ] Health checks configured
- [ ] Alerts set up
```

### Post-Deployment Checklist

```markdown
## Post-Deployment Checklist

### Verification
- [ ] Health check passing
- [ ] Smoke tests passing
- [ ] No critical errors in logs
- [ ] Performance metrics normal
- [ ] Error rates normal

### Monitoring
- [ ] APM dashboard looks good
- [ ] No unusual spikes
- [ ] Logs being collected
- [ ] Alerts firing correctly

### Documentation
- [ ] Release notes updated
- [ ] Changelog updated
- [ ] Runbooks updated

### Sign-off
- [ ] QA sign-off
- [ ] Product sign-off
- [ ] Deployment documented
```

---

## Part 6: Multi-Environment Strategy

```
┌─────────────────────────────────────────────────────────────────┐
│                    Deployment Environments                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐     │
│   │   Local     │────▶│   Dev       │────▶│  Staging    │     │
│   │  (dev)      │     │ (develop)   │     │ (main)      │     │
│   └─────────────┘     └─────────────┘     └──────┬──────┘     │
│                                                   │             │
│                                                   ▼             │
│                                            ┌─────────────┐     │
│                                            │ Production   │     │
│                                            │  (main)     │     │
│                                            └─────────────┘     │
│                                                                  │
│   Auto-deploy         Auto-deploy        Manual gate    Manual │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Environment Matrix

| Environment | Branch | Deploy | Approval | URL |
|-------------|--------|--------|----------|-----|
| Local | - | Manual | - | localhost |
| Dev | develop | Auto | None | dev.app.com |
| Staging | main | Auto | None | staging.app.com |
| Production | main (tag) | Manual | Required | app.com |

---

## Part 7: Rollback Strategies

### Blue-Green Deployment

```yaml
# Blue-Green deployment strategy
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: app-rollout
spec:
  strategy:
    blueGreen:
      activeService: app-active
      previewService: app-preview
      autoPromotionEnabled: false
      scaleDownDelaySeconds: 600
```

### Canary Deployment

```yaml
# Canary deployment strategy
apiVersion: argoproj.io/v1alpha1
kind: Rollout
metadata:
  name: app-rollout
spec:
  strategy:
    canary:
      canaryService: app-canary
      stableService: app-stable
      trafficRouter: istio
      steps:
        - setWeight: 5
        - pause: {duration: 10m}
        - setWeight: 20
        - pause: {duration: 10m}
        - setWeight: 50
        - pause: {duration: 20m}
        - setWeight: 100
```

### Quick Rollback Commands

```bash
# Kubernetes rollback
kubectl rollout undo deployment/app -n production

# Docker Compose rollback
docker-compose down
docker-compose -f docker-compose.backup.yml up -d

# Helm rollback
helm rollback app -n production

# AWS ECS rollback
aws ecs update-service \
  --cluster production \
  --service app \
  --task-definition app:PREVIOUS

# Terraform state rollback (if using IaC)
terraform apply -target=aws_instance.app -var-file=backup.tfvars
```

---

## Part 8: Monitoring & Alerts

### Health Check Endpoint

```typescript
// src/health.ts
import { Router } from 'express';

const router = Router();

router.get('/health', async (req, res) => {
  const checks = {
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    database: await checkDatabase(),
    redis: await checkRedis(),
  };
  
  const healthy = Object.values(checks).every(
    check => typeof check === 'boolean' ? check : true
  );
  
  res.status(healthy ? 200 : 503).json({
    status: healthy ? 'healthy' : 'unhealthy',
    checks,
    timestamp: new Date().toISOString(),
  });
});

router.get('/ready', async (req, res) => {
  const ready = await checkDatabase() && await checkRedis();
  res.status(ready ? 200 : 503).json({ ready });
});

export default router;
```

### Deployment Notification

```yaml
# GitHub Actions notification step
- name: Notify Deployment
  if: always()
  run: |
    STATUS=${{ job.status == 'success' && '✅' || '❌' }}
    MESSAGE="${STATUS} Deployment ${{ job.status }} for ${{ github.event.inputs.environment || 'staging' }}"
    
    # Send to Slack
    curl -X POST -H 'Content-type: application/json' \
      --data "{\"text\":\"${MESSAGE}\"}" \
      ${{ secrets.SLACK_WEBHOOK }}
```

---

*CI/CD & Delivery Skill v1.0.0*
