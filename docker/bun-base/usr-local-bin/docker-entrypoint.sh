#!/bin/sh
set -e

cd /app

# If the version file does not exist, installation and hash
if [ ! -f "node_modules/package.json.version" ]; then
  echo "package.json.version is missing, bun install is running..."
  bun install
  md5sum package.json | awk '{print $1}' > node_modules/package.json.version
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ] || { [ -f "${1}" ] && ! [ -x "${1}" ]; }; then
  set -- /usr/local/bin/bun "$@"
fi

exec "$@"

# https://github.com/oven-sh/bun/blob/main/dockerhub/debian/docker-entrypoint.sh