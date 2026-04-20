# User Documentation

## What services are provided?

This stack runs three services:

- **WordPress** — a website accessible at `https://ltreser.42.fr`
- **MariaDB** — the database that stores all WordPress content (runs in the background)
- **NGINX** — the web server that handles all incoming HTTPS traffic on port 443

As a user, you only interact with WordPress through your browser. NGINX and MariaDB run silently in the background.

## Starting and stopping the project

**Start:**
```bash
make
```

**Stop (keeps data):**
```bash
make down
```

**Full cleanup (deletes all data):**
```bash
make fclean
```

## Accessing the website

Open your browser and go to:

```
https://ltreser.42.fr
```

You will see a certificate warning because the SSL certificate is self-signed. Click "Advanced" and then "Proceed" to continue.

## Accessing the administration panel

Go to:

```
https://ltreser.42.fr/wp-admin
```

Log in with the administrator credentials found in the `.env` file located at `src/.env`.

| Field | Value |
|-------|-------|
| Username | `avatarstate` |
| Password | value of `WP_ADMIN_PASSWORD` in `src/.env` |

## Locating and managing credentials

All credentials are stored in `src/.env`. This file is not committed to git for security reasons.

```
src/.env
├── MARIADB_ROOT_PASSWORD   — MariaDB root password
├── DB_NAME                 — WordPress database name
├── DB_USER                 — Database user for WordPress
├── DB_PASSWORD             — Database user password
├── WP_ADMIN_PASSWORD       — WordPress admin password
└── WP_USER_PASSWORD        — WordPress regular user password
```

To change a password, update the value in `src/.env`, then run:
```bash
make fclean
make
```

## WordPress users

| Username | Role | Email |
|----------|------|-------|
| `avatarstate` | Administrator | aang@ltreser.42.fr |
| `regularuser` | Subscriber | user@ltreser.42.fr |

## Checking that services are running correctly

**Check all containers are up:**
```bash
docker ps
```

You should see three containers running: `nginx`, `wordpress`, `mariadb`.

**Check a specific service's logs:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Test the website is responding:**
```bash
curl -k https://ltreser.42.fr
```

**Check the database is accessible:**
```bash
docker exec -it mariadb mariadb -u root -p
```
