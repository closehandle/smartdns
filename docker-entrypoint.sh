#!/usr/bin/env bash
BIND=(
    '[::]:53'
)
BOOTDNS=()
CHINADNS=(
    'server 1.2.4.8:53 -b -e -g chinadns'
    'server 114.114.114.114:53 -b -e -g chinadns'
    'server 114.114.115.115:53 -b -e -g chinadns'
    'server 119.29.29.29:53 -b -e -g chinadns'
    'server 180.76.76.76:53 -b -e -g chinadns'
    'server 210.2.4.8:53 -b -e -g chinadns'
    'server 223.5.5.5:53 -b -e -g chinadns'
    'server 223.6.6.6:53 -b -e -g chinadns'
    'server [2400:3200:0000:0000:0000:0000:0000:0001]:53 -b -e -g chinadns'
    'server [2400:3200:baba:0000:0000:0000:0000:0001]:53 -b -e -g chinadns'
    'server [2400:da00:0000:0000:0000:0000:0000:6666]:53 -b -e -g chinadns'
    'server [2001:0dc7:1000:0000:0000:0000:0000:0001]:53 -b -e -g chinadns'
    'server [2402:4e00:0000:0000:0000:0000:0000:0000]:53 -b -e -g chinadns'
)
OTHERDNS=(
    'server-tls 1.0.0.1:853 -g otherdns'
    'server-tls 1.1.1.1:853 -g otherdns'
    'server-tls 8.8.4.4:853 -g otherdns'
    'server-tls 8.8.8.8:853 -g otherdns'
    'server-quic 94.140.14.140:853 -g otherdns'
    'server-quic 94.140.14.141:853 -g otherdns'
    'server-tls [2001:4860:4860:0000:0000:0000:0000:8844]:853 -g otherdns'
    'server-tls [2001:4860:4860:0000:0000:0000:0000:8888]:853 -g otherdns'
    'server-tls [2606:4700:4700:0000:0000:0000:0000:1001]:853 -g otherdns'
    'server-tls [2606:4700:4700:0000:0000:0000:0000:1111]:853 -g otherdns'
    'server-quic [2a10:50c0:0000:0000:0000:0000:0001:00ff]:853 -g otherdns'
    'server-quic [2a10:50c0:0000:0000:0000:0000:0002:00ff]:853 -g otherdns'
)
ADDITIONAL=()

UPDATE_LIST() {
    name="${1}"
    for i in {1..99}; do
        if [[ "${#i}" == '1' ]]; then
            i="0${i}"
        fi

        k="${name}${i}"
        v="${!k}"
        if [[ -z "${v}" ]]; then
            break
        fi

        if [[ "${i}" == '01' ]]; then
            eval "${name}=()"
        fi

        eval "${name}+=('${v}')"
    done
}

UPDATE_LIST 'BIND'
UPDATE_LIST 'BOOTDNS'
UPDATE_LIST 'CHINADNS'
UPDATE_LIST 'OTHERDNS'
UPDATE_LIST 'ADDITIONAL'

rm -fr /run/smartdns && mkdir /run/smartdns

touch /run/smartdns/bind.conf
for i in "${BIND[@]}"; do
    echo "bind ${i}" >> /run/smartdns/bind.conf
    echo "bind-tcp ${i}" >> /run/smartdns/bind.conf
done
touch /run/smartdns/bootdns.conf
for i in "${BOOTDNS[@]}"; do
    echo "${i}" >> /run/smartdns/bootdns.conf
done
touch /run/smartdns/chinadns.conf
for i in "${CHINADNS[@]}"; do
    echo "${i}" >> /run/smartdns/chinadns.conf
done
touch /run/smartdns/otherdns.conf
for i in "${OTHERDNS[@]}"; do
    echo "${i}" >> /run/smartdns/otherdns.conf
done
touch /run/smartdns/additional.conf
for i in "${ADDITIONAL[@]}"; do
    echo "${i}" >> /run/smartdns/additional.conf
done

exec smartdns -f /etc/smartdns/smartdns.conf -p -
