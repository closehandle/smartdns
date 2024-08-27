# smartdns
默认配置
```bash
docker container run \
    --env TZ=Asia/Shanghai \
    --name smartdns \
    --volume smartdns:/var/lib/smartdns \
    --publish 53:53/tcp \
    --publish 53:53/udp \
    --restart always \
    --hostname smartdns \
    closehandle/smartdns:latest
```

如有自定义配置的需求可以手动将配置映射出来
```bash
mkdir /etc/smartdns && cd /etc/smartdns
docker container cp smartdns:/etc/smartdns/smartdns.conf .
docker container cp smartdns:/etc/smartdns/chinadns.conf .
docker container cp smartdns:/etc/smartdns/otherdns.conf .

docker container run \
    --env TZ=Asia/Shanghai \
    --name smartdns \
    --volume smartdns:/var/lib/smartdns \
    --volume /etc/smartdns/smartdns.conf:/etc/smartdns/smartdns.conf \
    --volume /etc/smartdns/chinadns.conf:/etc/smartdns/chinadns.conf \
    --volume /etc/smartdns/otherdns.conf:/etc/smartdns/otherdns.conf \
    --publish 53:53/tcp \
    --publish 53:53/udp \
    --restart always \
    --hostname smartdns \
    closehandle/smartdns:latest
```
