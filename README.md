# 🛒 ShopSphere — E-Commerce Microservices Platform

> **Note:** This project's microservices architecture and business logic was pre-built. My contribution focuses entirely on the **DevOps & Containerization** layer — Dockerizing all services, orchestrating them with Docker Compose, and automating the pipeline with GitHub Actions.

---

## 🚀 What I Did (DevOps Contribution)

- ✅ Wrote **10 Dockerfiles** (9 Spring Boot services + React frontend) using multi-stage builds
- ✅ Solved **multi-module Maven** build challenge (root `pom.xml` context issue)
- ✅ Configured **Docker Compose** to orchestrate all services with MongoDB & Redis
- ✅ Set up **named volumes** for data persistence (MongoDB + Redis)
- ✅ Used **environment variables** for service discovery (`MONGODB_HOST`, `REDIS_HOST`)
- ✅ Optimized build context with `.dockerignore` (reduced from 451MB → 28KB)
- ✅ Implemented **multi-stage builds** to minimize final image size (~150MB vs 500MB+)
- ✅ Built **CI/CD pipeline** with GitHub Actions — auto build, test, and push all 9 service images to Docker Hub on every `main` branch push

---

## 🏗️ Architecture

```
                        ┌─────────────────┐
                        │  React Frontend  │
                        │  (Nginx :3000)   │
                        └────────┬────────┘
                                 │
                        ┌────────▼────────┐
                        │   API Gateway   │
                        │    (:8080)      │
                        └────────┬────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌────────▼───────┐    ┌──────────▼───────┐   ┌──────────▼───────┐
│  User Service  │    │ Product Service  │   │  Order Service   │
│    (:8083)     │    │    (:8081)       │   │    (:8082)       │
└────────┬───────┘    └──────────┬───────┘   └──────────┬───────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌────────────┼────────────┐
                    │                         │
           ┌────────▼────────┐      ┌─────────▼───────┐
           │    MongoDB      │      │      Redis       │
           │   (:27017)      │      │     (:6379)      │
           └─────────────────┘      └─────────────────┘
```

---

## 🔄 CI/CD Pipeline

Every push to `main` branch triggers this automated pipeline:

```
git push origin main
        │
        ▼
┌───────────────────┐
│  GitHub Actions   │
│  automatically:   │
│                   │
│  1. Checkout code │
│  2. Setup Java 17 │
│  3. Build + Test  │
│     all services  │
│  4. Build Docker  │
│     images        │
│  5. Push to       │
│     Docker Hub    │
└───────────────────┘
        │
        ▼
   ✅ All 9 images
   live on Docker Hub
```

### Pipeline Jobs

| Job | What it does |
|---|---|
| `build` | Compiles all 9 Spring Boot services with Maven |
| `docker-push` | Builds Docker images and pushes to Docker Hub (runs only if build passes) |

---

## 🛠️ Tech Stack

### Application (Pre-built)
| Layer | Technology |
|---|---|
| Backend | Java 17 + Spring Boot 3.2 |
| Frontend | React 18 + TypeScript + Vite |
| Database | MongoDB 7 |
| Cache | Redis 7 |
| API Gateway | Spring Cloud Gateway |

### DevOps (My Work)
| Tool | Usage |
|---|---|
| Docker | Containerization |
| Docker Compose | Multi-service orchestration |
| Multi-stage Build | Optimized image size |
| Named Volumes | Data persistence |
| .dockerignore | Build optimization |
| GitHub Actions | CI/CD pipeline automation |
| Docker Hub | Container image registry |

---

## 📦 Services & Ports

| Service | Port | Description |
|---|---|---|
| API Gateway | 8080 | Routes requests, JWT auth |
| User Service | 8083 | Registration, login, JWT |
| Product Service | 8081 | Catalog, inventory, search |
| Order Service | 8082 | Orders, tracking, history |
| Cart Service | 8084 | Shopping cart, coupons |
| Payment Service | 8085 | Payment processing |
| Shipping Service | 8086 | Shipment, delivery tracking |
| Notification Service | 8087 | In-app notifications |
| Review Service | 8088 | Reviews, ratings |
| React Frontend | 3000 | Customer storefront |

---

## ⚡ Run Locally (One Command)

### Prerequisites
- Docker Desktop installed and running
- 15GB+ free disk space

### Start Everything
```bash
git clone https://github.com/Razasheikh942/ShopSphere-Docker-CICD.git
cd ShopSphere-Docker-CICD
docker compose up --build
```

That's it. Docker will:
1. Build all 10 images automatically
2. Start MongoDB + Redis
3. Start all 9 microservices
4. Start React frontend

### Access
- Frontend: http://localhost:3000
- API Gateway: http://localhost:8080

### Stop Everything
```bash
docker compose down
```

### Stop + Delete All Data (volumes)
```bash
docker compose down -v
```

---

## 🔑 Key DevOps Challenges Solved

### 1. Multi-module Maven Build
**Problem:** Root `pom.xml` declares all 9 modules. Docker couldn't find sibling modules when building from a service subfolder.

**Solution:** Used root as build context (`docker build -f service/Dockerfile .`) with `COPY . .` so Maven can resolve all module dependencies.

### 2. Service Discovery via Environment Variables
**Problem:** All services had `localhost:27017` hardcoded for MongoDB — this breaks in Docker (containers can't reach each other via localhost).

**Solution:** Config already used `${MONGODB_HOST:localhost}` pattern. Simply passed `MONGODB_HOST=mongodb` in Compose, where `mongodb` is the container service name resolved by Docker's internal DNS.

### 3. Build Context Optimization
**Problem:** Initial build transferred 451MB context to Docker daemon (slow builds).

**Solution:** Added `.dockerignore` excluding `**/target`, `.git`, `node_modules` etc. — reduced to 28KB (16x improvement).

### 4. CI/CD Pipeline with Dependency Control
**Problem:** Docker images should not be pushed if any service fails to build/compile.

**Solution:** Used `needs: build` in GitHub Actions — `docker-push` job only runs after `build` job passes successfully. Prevents broken images from reaching Docker Hub.

---

## 📁 Project Structure
```
ShopSphere-Docker-CICD/
├── .github/
│   └── workflows/
│       └── ci-cd.yml           ← GitHub Actions pipeline
├── docker-compose.yml          ← orchestrates everything
├── .dockerignore               ← build optimization
├── common/                     ← shared library (no Dockerfile)
├── api-gateway/
│   └── Dockerfile
├── user-service/
│   └── Dockerfile
├── product-service/
│   └── Dockerfile
├── order-service/
│   └── Dockerfile
├── cart-service/
│   └── Dockerfile
├── payment-service/
│   └── Dockerfile
├── shipping-service/
│   └── Dockerfile
├── notification-service/
│   └── Dockerfile
├── review-service/
│   └── Dockerfile
└── frontend/
    └── Dockerfile
```

---

## 🔮 Next Steps (Roadmap)
- [x] Containerization with Docker & Docker Compose
- [x] CI/CD Pipeline with GitHub Actions
- [ ] Deploy to AWS EC2
- [ ] Infrastructure as Code with Terraform
- [ ] Kubernetes orchestration (K8s)
- [ ] Monitoring with Prometheus + Grafana