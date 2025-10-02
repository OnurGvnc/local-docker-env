#

```dockerfile
RUN set -eux; \
    if [ "$TARGETARCH" = "amd64" ]; then \
      curl -L -o /tmp/nginx https://jirutka.github.io/nginx-binaries/nginx-${NGINX_VERSION}-x86_64-linux && \
      curl -L -o /tmp/njs   https://jirutka.github.io/nginx-binaries/njs-${NJS_VERSION}-x86_64-linux && \
      curl -L -o /tmp/lego.tar.gz https://github.com/go-acme/lego/releases/download/v${LEGO_VERSION}/lego_v${LEGO_VERSION}_linux_amd64.tar.gz && \
      curl -L -o /tmp/openobserve.tar.gz https://github.com/openobserve/openobserve/releases/download/v${OO_VERSION}/openobserve-v${OO_VERSION}-linux-amd64.tar.gz ; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      curl -L -o /tmp/nginx https://jirutka.github.io/nginx-binaries/nginx-${NGINX_VERSION}-aarch64-linux && \
      curl -L -o /tmp/njs   https://jirutka.github.io/nginx-binaries/njs-${NJS_VERSION}-aarch64-linux && \
      curl -L -o /tmp/lego.tar.gz https://github.com/go-acme/lego/releases/download/v${LEGO_VERSION}/lego_v${LEGO_VERSION}_linux_arm64.tar.gz && \
      curl -L -o /tmp/openobserve.tar.gz https://github.com/openobserve/openobserve/releases/download/v${OO_VERSION}/openobserve-v${OO_VERSION}-linux-arm64.tar.gz ; \
    else \
      echo "Unsupported arch: $TARGETARCH" && exit 1; \
    fi; \
    mv /tmp/nginx /usr/local/bin/nginx; \
    mv /tmp/njs   /usr/local/bin/njs; \
    tar -xzf /tmp/lego.tar.gz -C /usr/local/bin lego || (tar -xzf /tmp/lego.tar.gz -C /tmp && mv /tmp/lego* /usr/local/bin/lego); \
    tar -xzf /tmp/openobserve.tar.gz -C /usr/local/bin openobserve || (tar -xzf /tmp/openobserve.tar.gz -C /tmp && mv /tmp/openobserve* /usr/local/bin/openobserve); \
    chmod +x /usr/local/bin/nginx /usr/local/bin/njs /usr/local/bin/lego /usr/local/bin/openobserve /usr/local/bin/workerd /usr/local/bin/pm2-runtime; \
    rm -f /tmp/*.tar.gz

```

```dockerfile
RUN bun install --trust --global pm2@${PM2_VERSION} \
    && ln -sf /root/.bun/install/global/node_modules/pm2/bin/pm2-runtime /usr/local/bin/pm2-runtime
RUN bun install --trust --global workerd@${WORKERD_VERSION} \
    && if [ "$TARGETARCH" = "amd64" ]; then \
      ln -sf /root/.bun/install/global/node_modules/@cloudflare/workerd-linux-64/bin/workerd /usr/local/bin/workerd; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      ln -sf /root/.bun/install/global/node_modules/@cloudflare/workerd-linux-arm64/bin/workerd /usr/local/bin/workerd; \
    fi
```