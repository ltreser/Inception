# Developer Documentation

## Prerequisites

Make sure the following are installed on your machine:

- Docker
- Docker Compose (v2+)
- make
- git

## Setting up from scratch

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd inception
```

### 2. Add the domain to /etc/hosts

```bash
echo "127.0.0.1 ltreser.42.fr" | sudo tee -a /etc/hosts
```

### 3. Create the data directories

```bash
mkdir -p ~/data/web ~/data/db
```

These are used as bind mounts for persistent storage:
- `~/data/web` — WordPress files
- `~/data/db` — MariaDB database files

### 4. Create the .env file

Create `src/.env` with the following content:

```env
MARIADB_ROOT_PASSWORD=yourpassword
DB_NAME=wordpress
DB_USER=wpuser
DB_PASSWORD=yourpassword
WP_ADMIN_PASSWORD=youradminpassword
WP_USER_PASSWORD=youruserpassword
```

This file is excluded from git via `.gitignore` and must never be committed.

## Project structure

```
inception/
├── Makefile
├── README.md
├── USER_DOC.md
├── DEV_DOC.md
└── src/
    ├── docker-compose.yml
    ├── .env                        ← not committed to git
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf                ← nginx site config
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf                ← php-fpm pool config
        │   └── tools/
        │       └── init.sh         ← wp-cli install script
        └── mariadb/
            ├── Dockerfile
            ├── cnf                 ← 50-server.cnf
            └── tools/
                └── init.sh         ← db init script
```

## Building and launching with make

| Command | Description |
|---------|-------------|
| `make` | Create data dirs, build images, start containers |
| `make down` | Stop and remove containers (data preserved) |
| `make clean` | Stop containers and remove Docker images |
| `make fclean` | Full cleanup: containers, images, volumes, data dirs |
| `make re` | `fclean` + `all` — full rebuild from scratch |

## Managing containers manually

**Build and start:**
```bash
docker compose -f src/docker-compose.yml up --build -d
```

**Stop:**
```bash
docker compose -f src/docker-compose.yml down
```

**Rebuild a single service:**
```bash
docker compose -f src/docker-compose.yml build --no-cache nginx
docker compose -f src/docker-compose.yml up -d nginx
```

**View logs:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Open a shell inside a container:**
```bash
docker exec -it nginx bash
docker exec -it wordpress bash
docker exec -it mariadb bash
```

**Check running containers:**
```bash
docker ps
```

## Managing volumes

**List volumes:**
```bash
docker volume ls
```

**Remove all project volumes:**
```bash
docker compose -f src/docker-compose.yml down -v
```

**Manually wipe data (bind mounts):**
```bash
sudo rm -rf ~/data/web/*
sudo rm -rf ~/data/db/*
```

## Where data is stored

| Data | Location on host | Location in container |
|------|------------------|-----------------------|
| WordPress files | `~/data/web` | `/var/www/html` |
| MariaDB database | `~/data/db` | `/var/lib/mysql` |

Data persists across `make down` / `make up` cycles because it is stored on the host via bind mounts. To reset all data, run `make fclean`.

## Network

All containers communicate over a custom Docker bridge network called `inception`. NGINX is the only container exposed to the host, on port `443`. WordPress and MariaDB are not directly accessible from outside the Docker network.

```
Host
 └── 443 ──► nginx ──► wordpress:9000 (FastCGI)
                   └──► mariadb:3306
```

## TLS

NGINX uses a self-signed SSL certificate generated during the Docker build process using `openssl`. The certificate and key are stored at `/etc/nginx/ssl/` inside the nginx container. Only TLSv1.2 and TLSv1.3 are allowed.
