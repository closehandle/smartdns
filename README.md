# smartdns
```
docker container run \
    --env TZ=Asia/Shanghai \
    --name smartdns \
    --publish 53:53/tcp \
    --publish 53:53/udp \
    --restart always \
    --hostname smartdns \
    closehandle/smartdns:latest
```
