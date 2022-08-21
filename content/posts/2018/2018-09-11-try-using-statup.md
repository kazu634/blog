+++
tags = ["statup"]
categories = ["インフラ", "監視"]
author = "kazu634"
images = ["ogp/2018-09-11-try-using-statup.webp"]
date = "2018-09-11T01:25:05+09:00"
title = "お手軽にステータスページを作成できるStatupを触ってみた"
description = "お手軽にステータスページを作成できるStatupを試しに使ってみました"
+++

# Statupを使ってみる
Statusページをお手軽に作成するツール[Statup](https://github.com/hunterlong/statup)を触ってみました。自分参照用にお試しに設置してみた動作例のサイトは[こちら](https://status.kazu634.com/)です。

## できること
`http`と`TCP`のConnectivityを確認できます。

`http`の場合は、`GET`リクエストだけでなく、`POST`リクエストなどにも対応しており、REST APIのエンドポイントの応答確認にも対応できるようになっています。

`TCP`の場合は、IPアドレスとポート番号を指定して、応答の確認をします。

### HTTPの場合
`http`の場合、以下のようにレスポンスタイムの情報と一緒に表示されます。

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/43806262985/in/dateposted/" title="Blog"><img src="https://farm2.staticflickr.com/1892/43806262985_22aca620eb_z.jpg" width="640" height="396" alt="Blog"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

### TCPの場合
`tcp`の場合、同じような感じで以下のように表示されます:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/44715041271/in/photostream/" title="MySQL"><img src="https://farm2.staticflickr.com/1860/44715041271_6927bba1bc_z.jpg" width="640" height="387" alt="MySQL"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## 設定について
基本的には起動させて、所定の設定ファイルが存在しなければ設定画面が表示されます。その画面に必要事項を指定していけばOK。

私の使用用途だと`SQLite`があっているため、`SQLite`を利用するように設定しました。設定ファイルの中身をのぞいてみると、こんな感じになっていました:

```
kazu634@itamae-test% cat config.yml
connection: sqlite
host: ""
user: ""
password: ""
database: ""
port: 3306
location: .
```

## Prometheusとの連携
この`Statup`ですが、`Prometheus`と連携ができます。`Prometheus`を`Grafana`に連携させることで、お手軽に各サイト・APIエンドポイントのステータスを時系列で確認できるようになります。こんな感じになります:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/44715067701/in/photostream/" title="grafana"><img src="https://farm2.staticflickr.com/1892/44715067701_93d0dee140_z.jpg" width="640" height="401" alt="grafana"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## まとめ
お手軽にウェブのエンドポイントやポート監視ができるので、色々と活用できそうです。

## 参考
- [GitHub - hunterlong/statup: Status Page for monitoring your websites and applications with beautiful graphs, analytics, and plugins. Run on any type of environment.](https://github.com/hunterlong/statup)

