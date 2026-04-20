# Inception

*This project has been created as part of the 42 curriculum by [ltreser].*

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small infrastructure composed of different services running inside Docker containers, orchestrated with Docker Compose. All containers are built from scratch using `debian:bookworm` — no pre-built images are allowed.

The infrastructure consists of:
- **NGINX** — the sole entrypoint, serving HTTPS on port 443 with TLSv1.2/TLSv1.3
- **WordPress + PHP-FPM** — the web application, communicating with NGINX via FastCGI
- **MariaDB** — the database backend for WordPress

### Docker in this project

Docker is used to containerize each service in isolation. Each service runs in its own container, built from a custom Dockerfile based on `debian:bookworm`. The containers communicate over a custom Docker bridge network called `inception`. Data is persisted using Docker volumes mounted to the host machine.

### Design Choices

#### Virtual Machines vs Docker

Virtual Machines emulate an entire operating system with their own kernel, making them heavy and slow to start. Docker containers share the host kernel and only package the application and its dependencies, making them lightweight, fast, and portable. For this project, Docker is the right tool because we need multiple isolated services that are easy to configure and reproduce.

#### Secrets vs Environment Variables

Environment variables are simple key-value pairs passed to containers at runtime, stored in a `.env` file. They are easy to use but can be exposed if the file is committed to version control. Docker secrets are a more secure alternative — they are stored encrypted and only mounted into containers that need them, never exposed as environment variables. For this project we use a `.env` file (excluded from git via `.gitignore`) which is sufficient for the 42 evaluation context.

#### Docker Network vs Host Network

With host networking, the container shares the host's network stack directly, meaning there is no network isolation between the container and the host. With Docker bridge networking, each container gets its own virtual network interface and containers can only communicate through explicitly defined networks. This project uses a custom bridge network (`inception`) so containers are isolated from the host and can only reach each other by service name.

#### Docker Volumes vs Bind Mounts

Bind mounts link a specific path on the host machine to a path inside the container — useful for development but tightly coupled to the host filesystem. Docker volumes are managed by Docker itself and are more portable. This project uses bind-mount-backed named volumes, storing WordPress files in `~/data/web` and the MariaDB database in `~/data/db`, so data persists across container restarts.

## Instructions

### Requirements

- Docker
- Docker Compose
- make

### Setup

1. Clone the repository:
```bash
git clone <your-repo-url>
cd inception
```

2. Add the domain to your `/etc/hosts`:
```bash
echo "127.0.0.1 ltreser.42.fr" | sudo tee -a /etc/hosts
```

3. Create a `.env` file in `src/`:
```bash
cat > src/.env << EOF
MARIADB_ROOT_PASSWORD=yourpassword
DB_NAME=wordpress
DB_USER=wpuser
DB_PASSWORD=yourpassword
WP_ADMIN_PASSWORD=youradminpassword
WP_USER_PASSWORD=youruserpassword
EOF
```

4. Build and start the infrastructure:
```bash
make
```

5. Open your browser and navigate to `https://ltreser.42.fr`

### Makefile targets

| Target | Description |
|--------|-------------|
| `make` | Build images and start all containers |
| `make down` | Stop all containers |
| `make clean` | Stop containers and remove images |
| `make fclean` | Full cleanup including volumes and data |
| `make re` | Full clean and rebuild |

## Resources

- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [MariaDB documentation](https://mariadb.com/kb/en/)
- [WordPress CLI (WP-CLI)](https://wp-cli.org/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)
- [Inception guide Part I](https://medium.com/@ssterdev/inception-guide-42-project-part-i-7e3af15eb671) — setting up NGINX and PHP-FPM
- [Inception guide Part II](https://medium.com/@ssterdev/inception-42-project-part-ii-19a06962cf3b) — setting up MariaDB and WordPress

### AI Usage

Claude (claude.ai) was used throughout this project for:
- Debugging Docker container issues (nginx config, php-fpm binding, MariaDB initialization)
- Writing and fixing shell scripts for container initialization
- Understanding TLS/SSL configuration in NGINX
- Setting up environment variables and Docker networking
- Writing this README
