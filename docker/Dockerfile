# Pull base image.
FROM ubuntu:jammy

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install apt-utils curl libicu70 libdbd-mysql-perl libcurl4-openssl-dev rsync libev4 zstd

# Install Percona Server
RUN curl -fsSL https://raw.githubusercontent.com/Percona-Lab/single_install/main/install_percona | \
bash -s -- --mode=ps

# Download test db
RUN cd /opt && \
    curl -L https://github.com/datacharmer/test_db/releases/download/v1.0.7/test_db-1.0.7.tar.gz -o test_db-1.0.7.tar.gz


# Install Percona Xtrabackup debug
RUN curl -o percona-xtrabackup-80_8.0.32-26-1.jammy_amd64.deb  https://downloads.percona.com/downloads/TESTING/issue-CUSTOM126/percona-xtrabackup-80_8.0.32-26-1.jammy_amd64.deb && \
dpkg -i percona-xtrabackup-80_8.0.32-26-1.jammy_amd64.deb

# Install Sysbench
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install sysbench

# Install Minio
RUN curl -o /bin/minio https://dl.min.io/server/minio/release/linux-amd64/minio && \
chmod +x /bin/minio && mkdir /mnt/data

# Install awscli
RUN DEBIAN_FRONTEND=noninteractive apt -y install awscli

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

COPY run_load.sh /bin/run_load.sh

RUN chmod +x /bin/run_load.sh

COPY xbstream_viewer.sh /bin/xbstream_viewer.sh

RUN chmod +x /bin/xbstream_viewer.sh

RUN mkdir /backups

RUN rm percona-release_latest.jammy_all.deb percona-xtrabackup-80_8.0.32-26-1.jammy_amd64.deb

EXPOSE 9090 9091

CMD ["/bin/entrypoint.sh"]
