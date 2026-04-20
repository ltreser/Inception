#!/bin/bash
cd /var/www/html

until mysqladmin ping -h mariadb -u ${DB_USER} -p${DB_PASSWORD} --silent; do
    echo "waiting for mariadb..."
    sleep 2
done

if [ ! -f wp-login.php ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    ./wp-cli.phar core download --allow-root
    ./wp-cli.phar config create --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} --dbhost=mariadb --allow-root
    ./wp-cli.phar core install --url=ltreser.42.fr --title=inception \
        --admin_user=avatarstate \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=aang@ltreser.42.fr \
        --allow-root
    ./wp-cli.phar user create regularuser user@ltreser.42.fr \
        --role=subscriber \
        --user_pass=${WP_USER_PASSWORD} \
        --allow-root
fi

php-fpm8.2 -F
