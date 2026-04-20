FROM debian:bookworm

RUN apt update && apt install -y \
    mariadb-server \ 
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

COPY tools/init.sh /init.sh

COPY conf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"] 

# CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql"]
