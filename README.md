# Desafío Técnico - Desarrollador Backend Sr.

Una API REST en Ruby construida con el framework Cuba para la gestión de productos, con autenticación y procesamiento asíncrono de trabajos con Sidekiq.

Las respuestas a las preguntas del challenge se encuentran dentro de la carpeta `docs`: [aqui](docs)

## Funcionalidades

- Autenticación de usuarios con tokens similares a JWT
- Gestión de productos (operaciones CRUD)
- Creación de productos de forma asíncrona usando Sidekiq
- Limitación de tasa (rate limiting) con Nginx como proxy inverso
- Base de datos PostgreSQL con el ORM Sequel
- Redis para procesamiento de trabajos en segundo plano
- Documentación compatible con OpenAPI

## Diagramas
> [!NOTA]  
> Para visualizar los diagramas localmente, se requiere la extensión Mermaid (`vstirbu.vscode-mermaid-preview`).

### Arquitectura de la App

```mermaid
graph TD
    A["🌐 Proxy Nginx"] --> B["🚀 Servidor API Cuba"]
    B --> C["🗄️ Base de datos PostgreSQL"]
    B --> D["⚡ Worker Sidekiq"]
    D --> E["📦 Redis Cache"]

    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style D fill:#fff3e0
    style E fill:#ffebee
```

### Arquitectura de Despliegue

```mermaid
graph TB
    subgraph "Entorno de Producción"
        subgraph "Balanceador de Carga"
            LB[Balanceador Nginx]
        end

        subgraph "Capa de Aplicación"
            API1[Instancia API Cuba 1]
            API2[Instancia API Cuba 2]
            API3[Instancia API Cuba 3]
        end

        subgraph "Capa de Workers"
            W1[Worker Sidekiq 1]
            W2[Worker Sidekiq 2]
        end

        subgraph "Capa de Datos"
            DB[(PostgreSQL Primario)]
            DB_REPLICA[(PostgreSQL Réplica)]
            REDIS[(Cluster Redis)]
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

## Inicio Rápido

### Requisitos
  - `Ruby` - [Como Instalar Ruby](https://www.ruby-lang.org/en/documentation/installation/)
  - `Docker` - [Como instalar Docker](https://docs.docker.com/engine/install/)
  - `Rbenv`, u otra herramienta que te facilite gestionar tu version de Ruby(opcional) - [rbenv](https://github.com/rbenv/rbenv)
  - `DBeaver`/`PGAdmin`, u otro visualizador de bases de datos (opcional) - [Como instalar DBeaver](https://dbeaver.io/download/).

### Pasos
1. **Clonar y configurar**
   ```bash
   git clone https://github.com/MartinLupa/fudo-backend-challenge
   cd fudo-backend-challenge
   ```

2. **Configurar entorno**

   Crear un archivo `.env` con el siguiente contenido:
   ```bash
   # App
   RACK_ENV=development
   SERVER_PORT=3000

   # Base de Datos
   DB_PORT=5432
   DB_NAME=development_db
   DB_USER=user
   DB_PASSWORD=password
   DATABASE_URL=postgres://user:password@localhost:5432/development_db

   # Redis
   REDIS_URL=redis://localhost:6379/0
   ```

3. **Iniciar servicios**
   ```bash
   docker-compose up
   ```

4. **Levantar la API**
   ```bash
   bundle install
   foreman start
   ```

5. **Alternativamente a los pasos 3 y 4, podés correr todo con Docker**
   ```bash
   # Descomentá la definición del servicio "app" y "sidekiq" en el docker-compose.yml y ejecutá:
   docker-compose up
   ```

## Endpoints de la API

> [!NOTA]  
> Si accedés a través del puerto del API Gateway, agregá `/api/` a todos los endpoints después del puerto.
>
> **Endpoint base**: `http://localhost:<puerto_app>/`> 
> **Endpoint vía proxy**: `http://localhost:<puerto_nginx>/api`

### Autenticación
- `POST /api/login` - Iniciar sesión con usuario y contraseña

> [!IMPORTANTE]  
> Primero iniciá sesión para obtener un token válido y activo (expira en 1 hora).

  ```bash
  curl -X POST -H "Content-Type: application/json" -d '{"username":"admin","password":"admin"}' http://localhost:80/api/login
  ```

### Productos
- `GET /api/products` - Listar todos los productos (requiere autenticación)

  ```bash
  curl -X GET -H "Content-Type: application/json" -H "Authorization: tu_token_aquí" http://localhost:80/api/products
  ```
- `GET /api/products/:id` - Obtener producto por ID (requiere autenticación)

  ```bash
  curl -X GET -H "Content-Type: application/json" -H "Authorization: tu_token_aquí" http://localhost:80/api/products/1
  ```
- `POST /api/products` - Crear producto de forma asíncrona (requiere autenticación)

  ```bash
  curl -X POST -H "Content-Type: application/json" -H "Authorization: tu_token_aquí" -d '{"name":"Nuevo producto"}' http://localhost:80/api/products
  ```

### Información
- `GET /api/AUTHORS` - Obtener información de autores
- `GET /api/openapi.yaml` - Obtener documentación de la API

## Usuarios por Defecto

- Usuario: `admin`, Contraseña: `admin`
- Usuario: `user`, Contraseña: `user`

## Documentación de la API

La especificación completa en formato OpenAPI está disponible en `/api/openapi.yaml` o en el archivo `openapi.yaml`.

## Autor

Martin I. Lupa
