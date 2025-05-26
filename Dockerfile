FROM alpine:latest

RUN apk add --no-cache openssl-dev build-base curl wget git

ADD smartdns-rules.sh smartdns-rules.sh
RUN bash smartdns-rules.sh && \
    mkdir /etc/smartdns && \
    mv -f chinadns.list /etc/smartdns/chinadns.list && \
    mv -f otherdns.list /etc/smartdns/otherdns.list && \
    rm -f smartdns-rules.sh

RUN git clone https://github.com/pymumu/smartdns --depth 1 --single-branch smartdns && cd smartdns && \
    make -j$(nproc) && \
    cd src && mv -f smartdns /usr/bin/smartdns && cd .. && \
    cd .. && rm -fr smartdns

FROM alpine:latest
COPY --from=0 /etc/smartdns/chinadns.list /etc/smartdns/chinadns.list
COPY --from=0 /etc/smartdns/otherdns.list /etc/smartdns/otherdns.list
COPY --from=0 /usr/bin/smartdns /usr/bin/smartdns

ADD smartdns.conf /etc/smartdns/smartdns.conf
ADD docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN apk add --no-cache ca-certificates

FROM scratch
COPY --from=1 / /
ENTRYPOINT ["docker-entrypoint.sh"]
CMD []
