# docker-xray
Deploy xray into docker. For personal usage.

Github: https://github.com/shamitum/docker-xray/

Docker: https://hub.docker.com/r/22ee0277/docker-xray/


##  Environment variables:  
If you want to completely custom a config file, just copy the content of the config file and set it to a variable:  
CONFIG : the content of the config file.    
For example:
```
{
    "inbounds": [{
        "port": 443,
        "protocol": "vless",
        "settings": {
            "clients": [{
                "id": "d42e30bc-f02c-40c1-92b9-883739bf0dcf"
            }],
            "decryption":"none"
        },
        "streamSettings": {
            "network": "quic",
            "quicSettings": {}
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
```

If you want to use the vmess+websocket solution, you can set only 1 variable. Default port for vmess+websocket is 8080. 

ID : vmess ID, default d42e30bc-f02c-40c1-92b9-883739bf0dcf 

Install vmess+websocket solution on your server using docker command below.
```
docker run -d --restart always \
     --name xray \
     -e "ID=YOUR_ID" \
     -p 8080:8080 \
     22ee0277/docker-xray
```

The config.json template:  
```
{
      "listen": null,
      "port": 8080,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "email": "",
            "id": "${ID}"
          }
        ]
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls",
          "quic",
          "fakedns"
        ],
        "enabled": true
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "acceptProxyProtocol": false,
          "headers": {},
          "path": "/"
        }
      },
      "tag": "inbound-8080"
    }
```
Config URL for vmess+ws soluton,
```
vmess://eyJhZGQiOiJZT1VSX0lQIiwiYWlkIjoiMCIsImFscG4iOiIiLCJmcCI6IiIsImhvc3QiOiIiLCJpZCI6IllPVVJfSUQiLCJuZXQiOiJ3cyIsInBhdGgiOiIvIiwicG9ydCI6IjgwODAiLCJwcyI6IlZNRVNTIFdTIiwic2N5IjoiYXV0byIsInNuaSI6IiIsInRscyI6IiIsInR5cGUiOiIiLCJ2IjoiMiJ9
```



If you want to use the vless+gRPC+Reality solution, you can set 2 variables. Default port for vless+gRPC+Reality is 2083.

ID : vless ID, default d42e30bc-f02c-40c1-92b9-883739bf0dcf
SNI : Your SNI, default twitter.com

Install vless+gRPC+Reality solution on your server using docker command below.
```
docker run -d --restart always \
     --name xray \
     -e "ID=YOUR_ID" \
     -e "SNI=YOUR_SNI" \
     -p 8080:8080 \
     -p 2083:2083 \
     22ee0277/docker-xray
```

The config.json template:
```
{
      "listen": null,
      "port": 2083,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "email": "",
            "flow": "",
            "id": "${ID}"
          }
        ],
        "decryption": "none",
        "fallbacks": []
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls",
          "quic",
          "fakedns"
        ],
        "enabled": true
      },
      "streamSettings": {
        "grpcSettings": {
          "multiMode": true,
          "serviceName": ""
        },
        "network": "grpc",
        "realitySettings": {
          "dest": "${SNI}:443",
          "maxClient": "",
          "maxTimediff": 0,
          "minClient": "",
          "privateKey": "yDhrleT3qqAjN1a85pE3vv7EAytGIjIlMRyAsN8skF8",
          "serverNames": [
            "${SNI}"
          ],
          "settings": {
            "fingerprint": "chrome",
            "publicKey": "7SeUnjm4sDSlop0CwJO1el8VswduF0hO1GlAyYaIgE0",
            "serverName": "",
            "spiderX": "/"
          },
          "shortIds": [
            "90ae3e6a"
          ],
          "show": false,
          "xver": 0
        },
        "security": "reality"
      },
      "tag": "inbound-2083"
    }
```
Config URL for vmess+ws soluton,
```
vless://YOUR_ID@YOUR_IP:2083?mode=multi&security=reality&encryption=none&pbk=7SeUnjm4sDSlop0CwJO1el8VswduF0hO1GlAyYaIgE0&fp=chrome&spx=%2F&type=grpc&serviceName=&sni=YOUR_SNI&sid=90ae3e6a#VLESS+gRPC+REALITY
```
Tested in Azure container.
