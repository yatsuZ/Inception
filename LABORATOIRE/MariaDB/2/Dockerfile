FROM debian:bullseye

RUN apt update -y && \
    apt install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    bash \
    vim \
    curl \
    tree \
    && rm -rf /var/lib/apt/lists/*



COPY ./config_vim /root/.vimrc
#COPY ./mariadb-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
