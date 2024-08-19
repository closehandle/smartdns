#!/usr/bin/env bash
chinadns=$(curl --retry-all-errors \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/apple.china.conf \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/google.china.conf \
    https://raw.githubusercontent.com/felixonmars/dnsmasq-china-list/master/accelerated-domains.china.conf)
otherdns=$(curl --retry-all-errors \
    https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt)

chinadns=$(echo "${chinadns}" | sed 's|server=/||' | sed 's|/114.114.114.114||' | grep -Ev '^#' | sort | uniq | sort)
while read -r i; do
    echo "${i}" >> chinadns.list
done <<< "${chinadns}"

otherdns=$(echo "${otherdns}" | base64 -d | grep -vE '^\!|\[|^@@|(https?://){0,1}[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sed -r 's#^(\|\|?)?(https?://)?##g' | sed -r 's#/.*$|%2F.*$##g' | grep -E '([a-zA-Z0-9][-a-zA-Z0-9]*(\.[a-zA-Z0-9][-a-zA-Z0-9]*)+)' | sed -r 's#^(([a-zA-Z0-9]*\*[-a-zA-Z0-9]*)?(\.))?([a-zA-Z0-9][-a-zA-Z0-9]*(\.[a-zA-Z0-9][-a-zA-Z0-9]*)+)(\*[a-zA-Z0-9]*)?#\4#g' | sort | uniq | sort)
while read -r i; do
    echo "${i}" >> otherdns.list
done <<< "${otherdns}"

exit 0
