#!/bin/sh
set -e

if [ -z "$NETDATA_USER" ] || [ -z "$NETDATA_PASSWORD" ]; then
  echo "ERROR: NETDATA_USER or NETDATA_PASSWORD is not set. Provide them in .env or environment."
  exit 1
fi

# create htpasswd file
htpasswd -bc /etc/nginx/htpasswd "$NETDATA_USER" "$NETDATA_PASSWORD"

exec nginx -g 'daemon off;'
