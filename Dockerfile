FROM debian:latest

ADD smartdns.sh /usr/bin/smartdns.sh
RUN chmod +x /usr/bin/smartdns.sh && \
    chown root:root /usr/bin/smartdns.sh && \
    apt update && \
    apt install curl -y && \
    smartdns.sh

FROM alpine:latest

RUN apk --no-cache add ca-certificates

ADD https://github.com/pymumu/smartdns/releases/download/Release46/smartdns-x86_64 /usr/bin/smartdns
ADD smartdns.conf /etc/smartdns/smartdns.conf
RUN chmod +x /usr/bin/smartdns && \
    chown root:root /usr/bin/smartdns

COPY --from=0 /chinadns.list /etc/smartdns/chinadns.list
COPY --from=0 /otherdns.list /etc/smartdns/otherdns.list

ENTRYPOINT ["/usr/bin/smartdns"]
CMD ["-f", "/etc/smartdns/smartdns.conf", "-p", "-"]
