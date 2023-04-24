# Pull base image.
FROM ubuntu:jammy

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install apt-utils curl && \
    DEBIAN_FRONTEND=noninteractive apt -y upgrade

RUN curl -fsSL https://raw.githubusercontent.com/Percona-Lab/single_install/main/install_percona | \
bash -s -- --mode=ps

RUN cd /opt && \
    curl -L https://github.com/datacharmer/test_db/releases/download/v1.0.7/test_db-1.0.7.tar.gz -o test_db-1.0.7.tar.gz


# Remove later when we have debug
RUN curl -fsSL https://raw.githubusercontent.com/Percona-Lab/single_install/main/install_percona | \
bash -s -- --mode=ps --backup

# Install Sysbench
RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt -y install sysbench

COPY entrypoint.sh /bin/entrypoint.sh

RUN chmod +x /bin/entrypoint.sh

COPY run_load.sh /bin/run_load.sh

RUN chmod +x /bin/run_load.sh

CMD ["/bin/entrypoint.sh"]
