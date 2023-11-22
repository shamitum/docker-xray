#!/bin/sh

cd /xray

apk update
apk add --no-cache wget unzip
wget https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip
unzip ./Xray-linux-64.zip
rm ./Xray-linux-64.zip

if test -z "$CONFIG"
then
    PORT=${PORT:-"2083"}
    ID=${ID:-"d42e30bc-f02c-40c1-92b9-883739bf0dcf"}
    SNI=${SNI:-"twitter.com"}

    cat > ./config.json <<EOF
{
  "api": {
    "services": [
      "HandlerService",
      "LoggerService",
      "StatsService"
    ],
    "tag": "api"
  },
  "dns": null,
  "fakeDns": null,
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 62789,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "sniffing": null,
      "streamSettings": null,
      "tag": "api"
    },
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
    },
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
  ],
  "log": {
    "error": "./error.log",
    "loglevel": "warning"
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundDownlink": true,
      "statsInboundUplink": true
    }
  },
  "reverse": null,
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "ip": [
          "geoip:private"
        ],
        "outboundTag": "blocked",
        "type": "field"
      },
      {
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ],
        "type": "field"
      }
    ]
  },
  "stats": {},
  "transport": null
}
EOF
else
    echo "$CONFIG" > ./config.json
fi

 ./xray -c ./config.json
