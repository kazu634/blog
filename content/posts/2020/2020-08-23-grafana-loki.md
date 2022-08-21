+++
title = "Grafana Lokiをお試しで使ってみたよ"
date = 2020-08-23T19:49:43+08:00
description = "Grafana Lokiを試しに使ってみたのでレポートしてみるよ"
tags = ["Loki", "Grafana"]
categories = ["インフラ", "Linux"]
author = "kazu634"
images = ["ogp/2020-08-23-grafana-loki.webp"]
image=""
+++

[Grafana Loki | Grafana Labs](https://grafana.com/oss/loki/)を試しに使ってみました。リソースなどの情報と紐づける形でログの確認ができるようになるのがメリットと聞き、どの程度のものかを確認してみました。

## Loki
[Grafana Loki](https://grafana.com/oss/loki/)は[Releases · grafana/loki · GitHub](https://github.com/grafana/loki/releases)からダウンロードします。

### インストール
以下のようにしてインストールします。

```sh
$ curl -O -L "https://github.com/grafana/loki/releases/download/v1.6.0/loki-linux-amd64.zip"
# extract the binary
$ unzip "loki-linux-amd64.zip"
# make sure it is executable
$ chmod a+x "loki-linux-amd64"
$ sudo mv loki-linux-amd64 /opt/loki/loki
```

ダウンロード後は、`/opt/loki/`配下に格納することとします。

### 設定ファイルについて
以下のような設定ファイルを`/opt/loki/loki-local-config.yaml`として保存します:

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s
  max_transfer_retries: 0

schema_config:
  configs:
    - from: 2018-04-15
      store: boltdb
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 168h

storage_config:
  boltdb:
    directory: /tmp/loki/index

  filesystem:
    directory: /tmp/loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h

chunk_store_config:
  max_look_back_period: 0s

table_manager:
  retention_deletes_enabled: false
  retention_period: 0s
```

### systemdファイル
[とりあえず構築 CentOS7 de Grafana Loki v1.5.0 - Qiita](https://qiita.com/docomodake/items/446cc550e042a0503635)を参考にして、以下のような設定ファイルを`/lib/systemd/system/loki.service`として保存します:

```ini
[Unit]
description=Grafana Loki
Documentation=https://github.com/grafana/loki
After=network-online.target

[Service]
User=root
Restart=always
ExecStart=/opt/loki/loki --config.file=/opt/loki/loki-local-config.yaml

[Install]
WantedBy=multi-user.target
```

格納後、以下のコマンドを実行し、自動実行します:

```sh
$ sudo systemctl daemon-reload
$ sudo systemctl enable loki.service
$ sudo systemctl start loki.service
```

#### syslog設定
Loki関連のログを`/var/log/loki.log`に出力するようrsyslogの設定を行います。以下を`/etc/rsyslog.d/30-loki.conf`として保存します:

```
# Log kernel generated UFW log messages to file
:syslogtag,contains,"loki" /var/log/loki.log

# Uncomment the following to stop logging anything that matches the last rule.
# Doing this will stop logging kernel generated UFW log messages to the file
# normally containing kern.* messages (eg, /var/log/kern.log)
#& stop
```

保存後、以下のコマンドを実行し、設定を反映させます:

```sh
$ sudo systemctl restart rsyslog.service
```

## Promtail
[Promtail](https://grafana.com/docs/loki/latest/clients/promtail/)は`Loki`にログを送信するコンポーネントになります。こちらも試しに利用してみます。対象のログは`/var/log/loki.log`です。

### インストール
以下のような形でインストールします:

```sh
$ wget https://github.com/grafana/loki/releases/download/v1.6.0/promtail-linux-amd64.zip
$ unzip promtail-linux-amd64.zip
$ chmod a+x promtail-linux-amd64
$ sudo mv promtail-linux-amd64 /usr/local/bin/promtail
```

### セットアップ
以下のような設定ファイルを作成して、ひとまず`/opt/loki/promtail-local-config.yaml`として保存することにしてみます:

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://localhost:3100/loki/api/v1/push

scrape_configs:
  - job_name: loki
    static_configs:
    - targets:
        - localhost
      labels:
        job: loki
        __path__: /var/log/loki.log

    pipeline_stages:
    - match:
        selector: '{job="loki"}'
        stages:
        - regex:
            expression: "^[A-Za-z]+ [0-9]+ [0-9]+:[0-9]+:[0-9]+ (?P<hostname>[^ ]+) loki[^:]+: level=(?P<severity>[^ ]+) ts=(?P<timestamp>[^ ]+) (?P<message>.*)$"
        - labels:
            hostname: hostname
            level: severity
        - timestamp:
            source: timestamp
            format: 2006-01-02T15:04:05.999999999Z
            location: Etc/GMT
        - output:
            source: message
```

### 実行してみます
以下のコマンドを実行し、`promtail`を実行します:

```sh
$ promtail --config.file=promtail-local-config.yaml
```

`Grafana`側で`Loki`をデータソースにして試しに、`{job="loki"}`を指定して、以下のように表示されれば問題なく動作しています:

![Image](https://farm66.staticflickr.com/65535/50259462657_1ee9e406cb_c.jpg)

### トラブルシューティング
うまく動かない時は以下を試してみます。

#### dry-runオプション
`Loki`にログを送信せずに、動作確認するためのオプションです:

```sh
$ promtail --config.file=promtail-local-config.yaml --dry-run
```

#### log.levelオプション
Pipeline Stageの設定がうまく動いていない時は、ログレベルを`debug`にすると有益な情報が表示されます:

```sh
$ promtail --config.file=promtail-local-config.yaml --dry-run --log.level=debug
```


## 参考
- [とりあえず構築 CentOS7 de Grafana Loki v1.5.0 - Qiita](https://qiita.com/docomodake/items/446cc550e042a0503635)

