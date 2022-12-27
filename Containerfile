ARG ALPINE_VERSION="3.17.0"

FROM gautada/alpine:$ALPINE_VERSION

# ╭――――――――――――――――――――╮
# │ METADATA           │
# ╰――――――――――――――――――――╯
LABEL source="https://github.com/gautada/barbican-container.git"
LABEL maintainer="Adam Gautier <adam@gautier.org>"
LABEL description="A container for a barbican key manager"

# ╭――――――――――――――――――――╮
# │ STANDARD CONFIG    │
# ╰――――――――――――――――――――╯

# USER:
ARG USER=mariadb

ARG UID=1001
ARG GID=1001
RUN /usr/sbin/addgroup -g $GID $USER \
 && /usr/sbin/adduser -D -G $USER -s /bin/ash -u $UID $USER \
 && /usr/sbin/usermod -aG wheel $USER \
 && /bin/echo "$USER:$USER" | chpasswd

# PRIVILEGE:
COPY wheel  /etc/container/wheel

# BACKUP:
COPY backup /etc/container/backup

# ENTRYPOINT:
RUN rm -v /etc/container/entrypoint
COPY entrypoint /etc/container/entrypoint

# FOLDERS
RUN /bin/chown -R $USER:$USER /mnt/volumes/container \
 && /bin/chown -R $USER:$USER /mnt/volumes/backup \
 && /bin/chown -R $USER:$USER /var/backup \
 && /bin/chown -R $USER:$USER /tmp/backup


# ╭――――――――――――――――――――╮
# │ APPLICATION        │
# ╰――――――――――――――――――――╯
RUN /sbin/apk add --no-cache fcgi lighttpd mariadb mariadb-client phpmyadmin
RUN /sbin/apk add --no-cache php81-cgi php81-json
RUN /sbin/apk add --no-cache  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing php81-pecl-xmlrpc php81-pecl-mcrypt
RUN mkdir -p /run/mysqld
RUN chown $USER:$USER -R /run/mysqld
RUN /bin/mv /etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf~ \
 && /bin/ln -svf /mnt/volumes/configmaps/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf \
 && /bin/ln -svf /mnt/volumes/container/mariadb-server.cnf /mnt/volumes/configmaps/mariadb-server.cnf

RUN /bin/mv /etc/lighttpd/lighttpd.conf /etc/lighttpd/lighttpd.conf~ \
 && /bin/ln -svf /mnt/volumes/configmaps/lighttpd.conf /etc/lighttpd/lighttpd.conf  \
 && /bin/ln -svf /mnt/volumes/container/lighttpd.conf /mnt/volumes/configmaps/lighttpd.conf

RUN /bin/mkdir -p /run/lighttpd
RUN /bin/chown lighttpd:lighttpd /run/lighttpd
RUN /bin/ln -s /usr/share/webapps/phpmyadmin/* /var/www/localhost/htdocs/

RUN /bin/mv /etc/phpmyadmin/config.inc.php /etc/phpmyadmin/config.inc.php~ \
 && /bin/ln -svf /mnt/volumes/configmaps/config.inc.php /etc/phpmyadmin/config.inc.php  \
 && /bin/ln -svf /mnt/volumes/container/config.inc.php /mnt/volumes/configmaps/config.inc.php


# ╭――――――――――――――――――――╮
# │ CONTAINER          │
# ╰――――――――――――――――――――╯
USER $USER
VOLUME /mnt/volumes/backup
VOLUME /mnt/volumes/configmaps
VOLUME /mnt/volumes/container
EXPOSE 3306/tcp 8080/tcp
WORKDIR /home/$USER
