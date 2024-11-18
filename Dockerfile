FROM alpine:latest

RUN apk update && \
    apk add --no-cache \
    rsyslog \
    rsyslog-mysql \
    mariadb-client \
    bash \
    && rm -rf /var/cache/apk/*

COPY entrypoint.sh /etc/entrypoint.sh

RUN echo "module(load=\"imudp\")" >> /etc/rsyslog.conf && \
    echo "input(type=\"imudp\" port=\"514\")" >> /etc/rsyslog.conf && \
    echo "module(load=\"imtcp\")" >> /etc/rsyslog.conf && \
    echo "input(type=\"imtcp\" port=\"514\")" >> /etc/rsyslog.conf && \
    echo "*.* /var/log/syslog" >> /etc/rsyslog.conf

RUN chmod a+x /etc/entrypoint.sh

ENTRYPOINT ["/etc/entrypoint.sh"]

EXPOSE 514/udp
EXPOSE 514/tcp
