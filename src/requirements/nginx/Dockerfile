FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=DE/ST=Berlin/L=Berlin/O=42/CN=ltreser.42.fr"

COPY conf /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]
