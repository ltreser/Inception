FROM debian:bookworm

RUN apt update && apt upgrade -y && apt install -y \
    php-fpm \
    php-mysqli \
    curl \
    mariadb-client \
    default-mysql-client \
    && rm -rf /var/lib/apt/lists/*

COPY conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/init.sh /init.sh

RUN chmod +x init.sh

CMD ["/init.sh"]
