#!/bin/sh
set -e

cd /app

# If the version file does not exist, installation and hash
if [ ! -f "node_modules/package.json.version" ]; then
  echo "package.json.version yok, bun install calisiyor..."
  bun install
  md5sum package.json | awk '{print $1}' > node_modules/package.json.version
fi

# Default: Run CMD or the passed command
exec "$@"