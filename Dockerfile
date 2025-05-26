FROM debian:latest

RUN apt update && \
    apt full-upgrade -y && \
    apt autoremove --purge -y
RUN apt install build-essential libssl-dev curl wget git -y

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

FROM debian:latest
COPY --from=0 /etc/smartdns/chinadns.list /etc/smartdns/chinadns.list
COPY --from=0 /etc/smartdns/otherdns.list /etc/smartdns/otherdns.list
COPY --from=0 /usr/bin/smartdns /usr/bin/smartdns

ADD smartdns.conf /usr/bin/smartdns.conf
ADD docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN apt update && \
    apt full-upgrade -y && \
    apt autoremove --purge -y
RUN apt install ca-certificates -y

FROM scratch
COPY --from=0 / /
ENTRYPOINT ["docker-entrypoint.sh"]
CMD []
