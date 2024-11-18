FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y \
    rsyslog \
    mariadb-client \
    rsyslog-mysql && \
    rm -rf /var/cache/apt/archives/* && \
    apt-get clean

COPY entrypoint.sh /etc/entrypoint.sh
RUN chmod +x /etc/entrypoint.sh

RUN echo "module(load=\"imudp\")" >> /etc/rsyslog.conf && \
    echo "input(type=\"imudp\" port=\"514\")" >> /etc/rsyslog.conf && \
    echo "module(load=\"imtcp\")" >> /etc/rsyslog.conf && \
    echo "input(type=\"imtcp\" port=\"514\")" >> /etc/rsyslog.conf && \
    echo "*.* /var/log/syslog" >> /etc/rsyslog.conf

ENTRYPOINT ["/etc/entrypoint.sh"]

EXPOSE 514/udp
EXPOSE 514/tcp
