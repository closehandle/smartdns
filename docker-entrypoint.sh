#!/usr/bin/env bash
if [[ -f /run/smartdns/smartdns.conf ]]; then
    exec smartdns -c /run/smartdns/smartdns.conf -f -p -
else
    exec smartdns -c /etc/smartdns/smartdns.conf -f -p -
fi
