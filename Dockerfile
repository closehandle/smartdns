FROM alpine:latest

RUN apk --no-cache add ca-certificates

ADD https://github.com/pymumu/smartdns/releases/download/Release46/smartdns-x86_64 /usr/bin/smartdns
ADD smartdns.sh /usr/bin/smartdns.sh
ADD smartdns.conf /etc/smartdns/smartdns.conf

RUN chmod +x /usr/bin/smartdns && \
    chmod +x /usr/bin/smartdns.sh && \
    chown root:root /usr/bin/smartdns && \
    chown root:root /usr/bin/smartdns.sh && \
    cd /etc/smartdns && \
    smartdns.sh

ENTRYPOINT ["/usr/bin/smartdns"]
CMD ["-f", "/etc/smartdns/smartdns.conf", "-p", "-"]
