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
# RUN /sbin/apk add --no-cache build-base git libffi-dev linux-headers mysql python3-dev py3-pip py3-setuptools
RUN /sbin/apk add --no-cache mariadb mariadb-client
RUN mkdir -p /run/mysqld
RUN chown $USER:$USER -R /run/mysqld
RUN /bin/mv /etc/my.cnf.d/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf~ \
 && /bin/ln -svf /mnt/volumes/configmaps/mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf \
 && /bin/ln -svf /mnt/volumes/container/mariadb-server.cnf /mnt/volumes/configmaps/mariadb-server.cnf

# RUN /bin/ln -svf /mnt/volumes/configmaps/barbican.conf /etc/container/barbican.conf \
#  && /bin/ln -svf /mnt/volumes/containce/barbican.conf /mnt/volumes/configmaps/barbican.conf
#
# RUN /usr/bin/pip install barbican
#
# RUN /sbin/apk add --no-cache mysql
# RUN mysql_install_db --user=mysql --ldata=/var/lib/mysql
# RUN mkdir -p /run/mysqld
# RUN chown $USER:$USER -R /var/lib/mysql /run/mysqld

# RUN python3 -m venv /home/$USER/venv
# WORKDIR /home/$USER/venv
# RUN git clone https://opendev.org/openstack/barbican.git
# RUN . /home/$USER/venv/bin/activate
# WORKDIR /home/$USER/venv/barbican
# RUN pip install --requirement barbican/requirements.txt
# RUN python setup.py install



# ╭――――――――――――――――――――╮
# │ CONTAINER          │
# ╰――――――――――――――――――――╯
USER $USER
VOLUME /mnt/volumes/backup
VOLUME /mnt/volumes/configmaps
VOLUME /mnt/volumes/container
EXPOSE 3306/tcp
WORKDIR /home/$USER
