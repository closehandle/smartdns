#!/usr/bin/env bash
ads=$(curl --retry-all-errors \
    https://adrules.top/smart-dns.conf \
    https://anti-ad.net/anti-ad-for-smartdns.conf \
    https://raw.githubusercontent.com/neodevpro/neodevhost/master/lite_smartdns.conf)
chinadns=$(curl --retry-all-errors \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf)
otherdns=$(curl --retry-all-errors \
    https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt)

echo "${ads}" | grep -Ev '^#' | grep -E '.' | awk -F '/' '{print $2}' | sort | uniq | sort > ads.list
echo "${chinadns}" | sed 's|server=/||' | sed 's|/114.114.114.114||' | grep -Ev '^#' | grep -E '.' | sort | uniq | sort > chinadns.list
echo "${otherdns}" | base64 -d | grep -Ev '^\!|\[|^@@|(https?://){0,1}[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sed -r 's#^(\|\|?)?(https?://)?##g' | sed -r 's#/.*$|%2F.*$##g' | grep -E '([a-zA-Z0-9][-a-zA-Z0-9]*(\.[a-zA-Z0-9][-a-zA-Z0-9]*)+)' | sed -r 's#^(([a-zA-Z0-9]*\*[-a-zA-Z0-9]*)?(\.))?([a-zA-Z0-9][-a-zA-Z0-9]*(\.[a-zA-Z0-9][-a-zA-Z0-9]*)+)(\*[a-zA-Z0-9]*)?#\4#g' | grep -Ev '^#' | grep -E '.' | sort | uniq | sort > otherdns.list
exit 0
