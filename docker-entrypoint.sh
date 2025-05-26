#!/usr/bin/env bash
if [[ -f /run/smartdns/smartdns.conf ]]; then
    exec smartdns -f /run/smartdns/smartdns.conf -p -
else
    exec smartdns -f /etc/smartdns/smartdns.conf -p -
fi
