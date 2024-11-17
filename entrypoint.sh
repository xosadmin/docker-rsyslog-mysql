#!/bin/sh

if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_DBNAME" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Error: MySQL/Mariadb Connection Credential is missing."
  exit 1
fi

echo "Starting rsyslog..."
exec rsyslogd -n
