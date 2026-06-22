FROM alpine:latest

RUN apk add --no-cache openssl-libs-static linux-headers openssl-dev build-base zlib-dev zlib-static bash curl wget git

ADD smartdns-rules.sh smartdns-rules.sh
RUN bash smartdns-rules.sh && \
    mkdir /etc/smartdns && \
    mv -f ads.list /etc/smartdns/ads.list && \
    mv -f chinadns.list /etc/smartdns/chinadns.list && \
    mv -f otherdns.list /etc/smartdns/otherdns.list && \
    rm -f smartdns-rules.sh

RUN curl -Lo dnsproxy.tar.gz https://github.com/adguardteam/dnsproxy/releases/download/v0.81.4/dnsproxy-linux-amd64-v0.81.4.tar.gz && \
    tar xf dnsproxy.tar.gz && rm -f dnsproxy.tar.gz && \
    cd linux-amd64 && \
    chown root:root dnsproxy && \
    chmod +x dnsproxy && \
    mv -f dnsproxy /usr/bin && \
    cd .. && rm -fr linux-amd64

RUN git clone https://github.com/pymumu/smartdns --single-branch smartdns && cd smartdns && \
    git checkout 299e7c17e45d79888c78c2cabbf9c2ea559c3097 && \
    make -j$(nproc) STATIC=1 && \
    cd src && mv -f smartdns /usr/bin/smartdns && cd .. && \
    cd .. && rm -fr smartdns

FROM alpine:latest
COPY --from=0 /etc/smartdns/ads.list /etc/smartdns/ads.list
COPY --from=0 /etc/smartdns/chinadns.list /etc/smartdns/chinadns.list
COPY --from=0 /etc/smartdns/otherdns.list /etc/smartdns/otherdns.list
COPY --from=0 /usr/bin/dnsproxy /usr/bin/dnsproxy
COPY --from=0 /usr/bin/smartdns /usr/bin/smartdns

ADD smartdns.conf /etc/smartdns/smartdns.conf
ADD docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN apk add --no-cache ca-certificates bash

FROM scratch
COPY --from=1 / /
ENTRYPOINT ["docker-entrypoint.sh"]
CMD []
