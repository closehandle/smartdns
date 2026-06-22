#!/usr/bin/env bash
for ((i=0; ; i++)); do
    name="DNS${i}"
    if [[ -z "${!name}"]]; then
        break
    fi

    dnsproxy ${!name} &
done

if [[ -f /run/smartdns/smartdns.conf ]]; then
    smartdns -c /run/smartdns/smartdns.conf -f -p - &
else
    smartdns -c /etc/smartdns/smartdns.conf -f -p - &
fi

wait -n
exit $?
