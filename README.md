# Technical Challenge - Backend Developer Sr.

gzip encoding : accept-encoding header through deflater middleware

A Ruby-based REST API built with Cuba framework for managing products, with authentication, and Sidekiq for async job processing.

## Features

- User authentication with JWT-like tokens
- Product management (CRUD operations)
- Asynchronous product creation using Sidekiq
- Rate limiting with Nginx reverse proxy
- PostgreSQL database with Sequel ORM
- Redis for background job processing
- OpenAPI compliant documentation

## Diagrams
> [!NOTE]  
> Mermaid(`vstirbu.vscode-mermaid-preview`) is required to visualise diagrams locally.

### App Architecture

```mermaid
graph TD
    A["🌐 Nginx Proxy"] --> B["🚀 Cuba API Server"]
    B --> C["🗄️ PostgreSQL Database"]
    B --> D["⚡ Sidekiq Worker"]
    D --> E["📦 Redis Cache"]
    
    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style D fill:#fff3e0
    style E fill:#ffebee
```

### Deployment Architecture
```mermaid
graph TB
    subgraph "Production Environment"
        subgraph "Load Balancer"
            LB[Nginx Load Balancer]
        end
        
        subgraph "Application Tier"
            API1[Cuba API Instance 1]
            API2[Cuba API Instance 2]
            API3[Cuba API Instance 3]
        end
        
        subgraph "Worker Tier"
            W1[Sidekiq Worker 1]
            W2[Sidekiq Worker 2]
        end
        
        subgraph "Data Tier"
            DB[(PostgreSQL Primary)]
            DB_REPLICA[(PostgreSQL Replica)]
            REDIS[(Redis Cluster)]
        end
    end
    
    LB --> API1
    LB --> API2
    LB --> API3
    
    API1 --> DB
    API2 --> DB
    API3 --> DB
    
    API1 --> REDIS
    API2 --> REDIS
    API3 --> REDIS
    
    W1 --> REDIS
    W2 --> REDIS
    W1 --> DB
    W2 --> DB
    
    DB --> DB_REPLICA
```


## Quick Start

1. **Clone and setup**
   ```bash
   git clone https://github.com/MartinLupa/fudo-backend-challenge
   cd fudo-backend-challenge
   ```

2. **Environment setup**
   Create a \`.env\` file with:
   ```bash
   # App
   RACK_ENV=development
   SERVER_PORT=3000
   
   # Database
   DB_PORT=5432
   DB_NAME=development_db
   DB_USER=user
   DB_PASSWORD=password
   DATABASE_URL=postgres://user:password@localhost:5432/development_db
   
   # Redis
   REDIS_URL=redis://localhost:6379/0
   ```

3. **Start services**
   ```bash
   docker-compose up
   ```
4. **Run the API**
   ```bash
   bundle install
   foreman start
   ```

5. **Alternatively to steps 3 and 4, you can run all services and the API through Docker**
   ```bash
   # Uncomment app definition in docker-compose.yml and run
   docker-compose up
   ```

## API Endpoints

> [!NOTE]  
> If targetting the API Gateway port, append `/api/` to all endpoints after the port.\
>
> **Base endpoint**: `http://localhost:<app_port>/`\
> **Proxy endpoint**: `http://localhost:<nginx_port>/api`

### Authentication
- `POST /api/login` - Login with username/password # username: admin / password: admin (these values are seed on db start for development)

### Products
- `GET /api/products` - List all products (requires auth)
- `GET /api/products/:id` - Get product by ID (requires auth)
- `POST /api/products` - Create product asynchronously (requires auth)

### Information
- `GET /api/AUTHORS` - Get authors information
- `GET /api/openapi.yaml` - Get API documentation

## Default Users

- Username: `admin`, Password: `admin`
- Username: `user`, Password: `user`


## API Documentation

Full OpenAPI specification available at \`/api/openapi.yaml\` or view the \`openapi.yaml\` file.

## Author

Martin I. Lupa
