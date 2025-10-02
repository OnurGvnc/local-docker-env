FROM oven/bun:1.2.23
# https://github.com/oven-sh/bun/blob/main/dockerhub/debian/Dockerfile
# https://hub.docker.com/r/oven/bun/tags

ARG TARGETARCH
# TARGETARCH=amd64 | arm64

ARG DEBIAN_FRONTEND=noninteractive

ENV LEGO_VERSION=4.25.2 \
    NGINX_VERSION=1.28.0 \
    NJS_VERSION=0.9.1 \
    LITESTREAM_VERSION=0.3.13 \
    WORKERD_VERSION=1.20250924.0 \
    NEON_PROXY_VERSION=0.0.0-release-9129 \
    PM2_VERSION=6.0.13 \
    PROTO_VERSION=0.53.0 \
    ATLAS_VERSION=0.37.0 \
    YQ_VERSION=4.47.2 \
    JQ_VERSION=1.8.1 \
    UV_VERSION=0.8.22 \
    LEGO_VERSION=4.26.0 \
    DENO_VERSION=2.5.2 \
    OPENOBSERVE_VERSION=0.15.1 \
    TASK_VERSION=3.45.4 \
    PROTO_HOME="/root/.proto" \
    PATH="/root/.proto/bin:$PATH"

# install apt dependencies
RUN set -eux; \
    apt-get update -qq; \
    apt-get install -y -qq --no-install-recommends \
      -o Dpkg::Options::=--force-confold \
      -o Dpkg::Options::=--force-confdef \
      curl \
      ca-certificates \
      tar unzip gzip xz-utils \
      procps \
      postgresql-client; \
    rm -rf /var/lib/apt/lists/*; \
    mkdir -p /usr/local/bin
# git unzip gzip xz-utils: proto
# procps: pm2

# global bun install
RUN bun install --trust --global pm2@${PM2_VERSION}

COPY ./proto /root/proto

# https://github.com/moonrepo/proto
RUN curl -fsSL https://moonrepo.dev/install/proto.sh | bash -s -- ${PROTO_VERSION} --yes && \
  cd /root/proto && \
  proto install task ${TASK_VERSION} && \
  proto install litestream ${LITESTREAM_VERSION} && \
  proto install workerd ${WORKERD_VERSION} && \
  proto install neon-proxy ${NEON_PROXY_VERSION} && \
  proto install nginx ${NGINX_VERSION} && \
  proto install njs ${NJS_VERSION} && \
  proto install atlas ${ATLAS_VERSION} && \
  # proto install lego ${LEGO_VERSION} && \
  # proto install openobserve ${OPENOBSERVE_VERSION} && \
  # proto install uv ${UV_VERSION} && \
  # proto install deno ${DENO_VERSION} && \
  proto install yq ${YQ_VERSION} && \
  proto install jq ${JQ_VERSION} && \
  proto clean temp --yes && proto clean cache --yes && rm -rf ~/.proto/temp ~/.proto/cache

# COPY --from=ghcr.io/onurgvnc/local-neon-http-proxy:main --chmod=0755 /app/neon-proxy /usr/local/bin/neon-proxy
# COPY --from=php:8.3.7-cli /usr/local/bin/php /usr/bin/php
# COPY --from=docker:dind /usr/local/bin/docker /usr/local/bin/docker
RUN mkdir -p /usr/local/lib/docker/cli-plugins
COPY --from=docker:28.4.0 /usr/local/bin/docker /usr/local/bin/docker
COPY --from=docker:28.4.0 /usr/local/bin/docker-compose /usr/local/bin/docker-compose

# COPY --from=docker:28.4.0 /usr/libexec/docker/cli-plugins/docker-compose /usr/libexec/docker/cli-plugins/docker-compose
# COPY --from=dockercli /usr/libexec/docker/cli-plugins/docker-buildx /usr/libexec/docker/cli-plugins/docker-buildx

# HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://localhost:3005/ || exit 1

# ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
# CMD ["/usr/local/bin/pm2-runtime", "start", "--no-auto-exit", "ecosystem.config.js"]


COPY --chmod=755 ./usr-local-bin/docker-entrypoint.sh ./usr-local-bin/wait-for-it.sh /usr/local/bin/

WORKDIR /app
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/usr/local/bin/bun"]
