#!/bin/sh
set -e

cd /app

# Check all installed binaries from Dockerfile if CHECK_SETUP=true
if [ "$CHECK_SETUP" = "true" ]; then
  echo "Checking installed binaries..."

  BINARIES="nginx njs lego openobserve"
  for binary in $BINARIES; do
    if [ -x "/usr/local/bin/$binary" ]; then
      echo "✓ $binary found at /usr/local/bin/$binary"

      # Show version if possible
      case $binary in
        nginx)
          /usr/local/bin/nginx -v 2>&1 | head -1
          ;;
        njs)
          echo "  njs binary present"
          ;;
        lego)
          /usr/local/bin/lego --version 2>&1 | head -1
          ;;
        openobserve)
          echo "  openobserve binary present"
          ;;
      esac
    else
      echo "✗ $binary NOT FOUND at /usr/local/bin/$binary"
      exit 1
    fi
  done

  echo "All binaries verified successfully!"
  echo ""
fi

# version dosyası yoksa kurulum ve hash
if [ ! -f "node_modules/package.json.version" ]; then
  echo "package.json.version yok, bun install calisiyor..."
  bun install
  md5sum package.json | awk '{print $1}' > node_modules/package.json.version
fi

# Varsayılan: CMD veya geçilen komutu çalıştır
exec "$@"