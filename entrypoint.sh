#!/bin/sh

if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_DBNAME" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Error: MySQL/Mariadb Connection Credential is missing."
  exit 1
fi

echo "Starting rsyslog..."
if ! grep -q 'module(load="ommysql")' /etc/rsyslog.conf; then
  echo "module(load=\"ommysql\")" >> /etc/rsyslog.conf
  echo "*.* :ommysql:${MYSQL_HOST},${MYSQL_DBNAME},${MYSQL_USER},${MYSQL_PASSWORD};RSYSLOG_TEMPLATE" >> /etc/rsyslog.conf
  echo "template(name=\"RSYSLOG_TEMPLATE\" type=\"string\" string=\"%TIMESTAMP% %HOSTNAME% %fromhost-ip% %programname% %syslogseverity-text% %msg%\n\")" >> /etc/rsyslog.conf
  echo "*.* :ommysql:${MYSQL_HOST},${MYSQL_DBNAME},${MYSQL_USER},${MYSQL_PASSWORD};RSYSLOG_TEMPLATE" >> /etc/rsyslog.conf
fi

exec rsyslogd -n
