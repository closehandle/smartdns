#!/usr/bin/env bash
ads=$(curl --retry-all-errors \
    https://adrules.top/smart-dns.conf \
    https://anti-ad.net/anti-ad-for-smartdns.conf \
    https://raw.githubusercontent.com/neodevpro/neodevhost/master/smartdns.conf \
    https://raw.githubusercontent.com/loyalsoldier/v2ray-rules-dat/release/reject-list.txt)
chinadns=$(curl --retry-all-errors \
    https://raw.githubusercontent.com/loyalsoldier/v2ray-rules-dat/release/direct-list.txt \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf)
otherdns=$(curl --retry-all-errors \
    https://raw.githubusercontent.com/loyalsoldier/v2ray-rules-dat/release/proxy-list.txt)

echo "${ads}" | grep -Ev '^#' | sed 's|address /||g' | sed 's|/#||g' | grep -E '.' | sort | uniq | awk '{ print length, $0 }' | sort -n -k1,1 -k2 | cut -d' ' -f2- > ads.list
echo "${chinadns}" | grep -Ev '^#' | sed 's|full:||g' | grep -Ev '^regexp:' | sed 's|server=/||g' | sed 's|/114.114.114.114||g' | grep -E '.' | sort | uniq | awk '{ print length, $0 }' | sort -n -k1,1 -k2 | cut -d' ' -f2- > chinadns.list
echo "${otherdns}" | grep -Ev '^#' | sed 's|full:||g' | grep -Ev '^regexp:' | grep -E '.' | sort | uniq | awk '{ print length, $0 }' | sort -n -k1,1 -k2 | cut -d' ' -f2- > otherdns.list

exit 0
