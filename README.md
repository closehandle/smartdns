# SmartDNS
```yml
services:
  smartdns:
    image: closehandle/smartdns:latest
    environment:
      TZ: Asia/Shanghai
      BIND01: '[::]:53'
      BOOTDNS01: 'server 119.29.29.29:53 -b -e'
      BOOTDNS02: 'server 223.5.5.5:53 -b -e'
      BOOTDNS03: 'server 223.6.6.6:53 -b -e'
      CHINADNS01: 'server-tls dot.pub:853 -e -g chinadns'
      CHINADNS02: 'server-tls dns.alidns.com:853 -e -g chinadns'
      OTHERDNS01: 'server-h3 h3://1.0.0.1/dns-query -g otherdns'
      OTHERDNS02: 'server-h3 h3://1.1.1.1/dns-query -g otherdns'
      OTHERDNS03: 'server-h3 h3://8.8.4.4/dns-query -g otherdns'
      OTHERDNS04: 'server-h3 h3://8.8.8.8/dns-query -g otherdns'
    network_mode: host
    container_name: smartdns
```
