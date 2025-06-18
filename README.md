# SmartDNS
```yml
services:
  smartdns:
    image: closehandle/smartdns:latest
    cap_add:
      - NET_BIND_SERVICE
      - NET_RAW
    environment:
      - TZ=Asia/Shanghai
    network_mode: host
    container_name: smartdns
```

```
$ add container image closehandle/smartdns:latest
$ configure
# set container name smartdns capability net-bind-service
# set container name smartdns capability net-raw
# set container name smartdns image closehandle/smartdns:latest
# set container name smartdns restart always
# commit && save
# exit
$ show container
$ show container log smartdns
```
