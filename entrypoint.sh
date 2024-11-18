#!/bin/sh

if [ -z "$MYSQL_HOST" ] || [ -z "$MYSQL_DBNAME" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Error: MySQL/Mariadb Connection Credential is missing."
  exit 1
fi

echo "Starting rsyslog..."
sed -i 's/^module(load="imklog")/#module(load="imklog")/' /etc/rsyslog.conf
if ! grep -q 'module(load="ommysql")' /etc/rsyslog.conf; then
  echo 'module(load="ommysql")' >> /etc/rsyslog.conf
  echo 'template(name="RSYSLOG_TEMPLATE" type="string" sql="INSERT INTO logs (timestamp, hostname, fromhost_ip, programname, syslogseverity, msg) VALUES ('"'%timestamp%','%hostname%','%fromhost-ip%','%programname%','%syslogseverity%','%msg%'"');")' >> /etc/rsyslog.conf
  echo '*.* :ommysql:server=${MYSQL_HOST},db=${MYSQL_DBNAME},uid=${MYSQL_USER},pwd=${MYSQL_PASSWORD};RSYSLOG_TEMPLATE' >> /etc/rsyslog.conf
fi

exec rsyslogd -n
