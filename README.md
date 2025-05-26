# SmartDNS
```yml
services:
  smartdns:
    image: closehandle/smartdns:latest
    environment:
      TZ: Asia/Shanghai
    network_mode: host
    container_name: smartdns
```
