#!/bin/sh
set -eu

# Ensure runtime dirs exist
mkdir -p /var/run/nginx

exec "$@"