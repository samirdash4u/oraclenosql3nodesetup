# Copyright (c) 2022, 2025 Oracle and/or its affiliates. 
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
#
FROM ghcr.io/graalvm/jdk-community:17-ol9

LABEL org.opencontainers.image.source = "https://github.com/oracle/docker-images"

ARG KV_VERSION=25.3.21
ARG DOWNLOAD_ROOT="https://github.com/oracle/nosql/releases/download/v${KV_VERSION}"
ARG DOWNLOAD_FILE="kv-ce-${KV_VERSION}.zip"
ARG DOWNLOAD_LINK="${DOWNLOAD_ROOT}/${DOWNLOAD_FILE}"

ENV KV_PROXY_PORT 8080
ENV KV_ADMIN_PORT 5999

ENV KV_PORT 5000
ENV KV_HARANGE 5010-5020
ENV KV_SERVICERANGE 5021-5049

# hadolint ignore=DL4006
RUN useradd -d /kvroot  -m -s /bin/bash -u 1000 nosql-user && \
    chown -R nosql-user /app/

WORKDIR "/app"

RUN microdnf install -y unzip && microdnf clean all && \
    curl -OLs $DOWNLOAD_LINK && \
    unzip $DOWNLOAD_FILE && \
    rm -f $DOWNLOAD_FILE && \
    chown -R nosql-user:nosql-user /app/*

WORKDIR "/app/kv-$KV_VERSION"

VOLUME ["/kvroot"]

COPY --chown=nosql-user ./start-sna.sh /app/start-sna.sh
COPY --chown=nosql-user ./configure.sql /app/kv-$KV_VERSION/configure.sql
RUN chmod +x /app/start-sna.sh

USER nosql-user
CMD ["/app/start-sna.sh"]
