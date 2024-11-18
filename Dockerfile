FROM alpine:latest

RUN apk update && \
    apk add --no-cache \
    rsyslog \
    rsyslog-mysql \
    mariadb-client \
    bash \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /etc/entrypoint.sh

RUN echo "\n# Enable UDP syslog reception" >> /etc/rsyslog.conf && \
    echo "module(load=\"imudp\")" >> /etc/rsyslog.conf && \
    echo "input(type=\"imudp\" port=\"514\")" >> /etc/rsyslog.conf && \
    echo "\n# Enable TCP syslog reception" >> /etc/rsyslog.conf && \
    echo "module(load=\"imtcp\")" >> /etc/rsyslog.conf && \
    echo "input(type=\"imtcp\" port=\"514\")" >> /etc/rsyslog.conf && \
    echo "\n# Log to file (default)" >> /etc/rsyslog.conf && \
    echo "*.* /var/log/syslog" >> /etc/rsyslog.conf

RUN chmod a+x /etc/entrypoint.sh

RUN echo "\n# MySQL output configuration" >> /etc/rsyslog.conf && \
    echo "module(load=\"ommysql\")" >> /etc/rsyslog.conf && \
    echo "*.* :ommysql:${MYSQL_HOST},${MYSQL_DBNAME},${MYSQL_USER},${MYSQL_PASSWORD};RSYSLOG_TEMPLATE" >> /etc/rsyslog.conf

RUN echo "\n# Template for MySQL" >> /etc/rsyslog.conf && \
    echo "template(name=\"RSYSLOG_TEMPLATE\" type=\"string\" string=\"%TIMESTAMP% %HOSTNAME% %fromhost-ip% %programname% %syslogseverity-text% %msg%\n\")" >> /etc/rsyslog.conf && \
    echo "\n# Apply template for MySQL" >> /etc/rsyslog.conf && \
    echo "*.* :ommysql:${MYSQL_HOST},${MYSQL_DBNAME},${MYSQL_USER},${MYSQL_PASSWORD};RSYSLOG_TEMPLATE" >> /etc/rsyslog.conf

ENTRYPOINT ["/etc/entrypoint.sh"]

EXPOSE 514/udp
EXPOSE 514/tcp
