FROM debian:latest

ADD smartdns.sh /usr/bin/smartdns.sh
RUN apt update && \
    apt install curl -y && \
    apt clean && \
    chmod +x /usr/bin/smartdns.sh && \
    chown root:root /usr/bin/smartdns.sh && \
    smartdns.sh && \
    openssl req -x509 -newkey rsa -sha512 -days 3650 -nodes \
        -keyout default.key -out default.crt -subj '/CN=microsoft.com' \
        -addext 'subjectAltName=DNS:microsoft.com,DNS:*.microsoft.com'

FROM debian:latest
COPY --from=0 /ads.list /etc/smartdns/ads.list
COPY --from=0 /default.crt /etc/smartdns/default.crt
COPY --from=0 /default.key /etc/smartdns/default.key
COPY --from=0 /chinadns.list /etc/smartdns/chinadns.list
COPY --from=0 /otherdns.list /etc/smartdns/otherdns.list

ADD https://github.com/pymumu/smartdns/releases/download/Release46/smartdns-x86_64 /usr/bin/smartdns
ADD smartdns.conf /etc/smartdns/smartdns.conf
ADD chinadns.conf /etc/smartdns/chinadns.conf
ADD otherdns.conf /etc/smartdns/otherdns.conf
RUN apt update && \
    apt install ca-certificates -y && \
    apt clean && \
    chmod +x /usr/bin/smartdns && \
    chown root:root /usr/bin/smartdns && \
    mkdir /var/lib/smartdns

ENTRYPOINT ["/usr/bin/smartdns"]
CMD ["-f", "/etc/smartdns/smartdns.conf", "-p", "-"]
