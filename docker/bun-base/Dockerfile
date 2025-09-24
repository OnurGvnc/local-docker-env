FROM oven/bun:1.2.22

ARG TARGETPLATFORM

RUN bun install -g pm2@6.0.13

# Install required tools
RUN apt-get update && apt-get install -y curl tar && rm -rf /var/lib/apt/lists/*

# Create bin directory
RUN mkdir -p /usr/local/bin

# Download and install binaries based on platform
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
      curl -L -o /tmp/nginx https://jirutka.github.io/nginx-binaries/nginx-1.28.0-x86_64-linux && \
      curl -L -o /tmp/njs https://jirutka.github.io/nginx-binaries/njs-0.9.1-x86_64-linux && \
      curl -L -o /tmp/lego.tar.gz https://github.com/go-acme/lego/releases/download/v4.25.2/lego_v4.25.2_linux_amd64.tar.gz && \
      curl -L -o /tmp/openobserve.tar.gz https://github.com/openobserve/openobserve/releases/download/v0.14.0/openobserve-v0.14.0-linux-amd64.tar.gz; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      curl -L -o /tmp/nginx https://jirutka.github.io/nginx-binaries/nginx-1.28.0-aarch64-linux && \
      curl -L -o /tmp/njs https://jirutka.github.io/nginx-binaries/njs-0.9.1-aarch64-linux && \
      curl -L -o /tmp/lego.tar.gz https://github.com/go-acme/lego/releases/download/v4.25.2/lego_v4.25.2_linux_arm64.tar.gz && \
      curl -L -o /tmp/openobserve.tar.gz https://github.com/openobserve/openobserve/releases/download/v0.14.0/openobserve-v0.14.0-linux-arm64.tar.gz; \
    fi && \
    mv /tmp/nginx /usr/local/bin/nginx && \
    mv /tmp/njs /usr/local/bin/njs && \
    tar -xzf /tmp/lego.tar.gz -C /usr/local/bin lego && \
    tar -xzf /tmp/openobserve.tar.gz -C /usr/local/bin openobserve && \
    chmod +x /usr/local/bin/nginx /usr/local/bin/njs /usr/local/bin/lego /usr/local/bin/openobserve && \
    rm -f /tmp/*.tar.gz

ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
CMD ["bun", "x", "pm2-runtime", "start", "ecosystem.config.js"]
