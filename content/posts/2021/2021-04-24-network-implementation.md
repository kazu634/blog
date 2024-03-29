+++
author = "kazu634"
images = ["ogp/2021-04-24-network-implementation.webp"]
description = "インターネット開通したので、ネットワーク環境を構築しました。そのメモです"
categories = ["ネットワーク"]
tags = ["vyOS","edgerouter"]
date = "2021-04-24T12:07:13+08:00"
title = "自宅のネットワーク環境の構築メモ"
+++

1月に日本に帰国し、2月にお引っ越し、そしてこの4月頭にお引っ越しに伴うインターネット開通が終わりました。色々とネットワーク関連の設定を終えましたので、こちらにまとめておきます。

## 環境
- プロバイダ: Yahoo!BB! (ホームタイプ)
- ルーター: EdgeRouter (VyOSベースのルーターです)

## ネットワーク図
最終的なネットワーク図はこちらになります:

![Network Diagram](https://farm66.staticflickr.com/65535/51106908638_e7e5f03c05_c.jpg)

AWS上のネットワークと家の間に拠点間VPNを張っています。

## 事前に検討したこととか
検討したこととかをまとめていきます。

### プロバイダについて
ヨドバシカメラにいったところ、冷蔵庫が無料になるということで、Yahoo!BB!にしました。

### WiFiについて
WiFI6が使いたかったので、WiFi6対応ルーターをアクセスポイントとして活用しています。

## ネットワーク構築
Yahoo!BB!は専用のルーターを提供してくれているのですが、IPv6通信をしない場合には、直接ルーターからpppoe接続しても大丈夫なようです。間にYahoo!BB!のルータを挟めたくないのと、IPv6通信をしてしまうと、IPv4のVPN通信に差し障りが出て来るようなので、Yahoo!BB!から提供されるルーターは利用しないことにしました。というわけで、EdgeRouterを直接にONUに接続することにしました。

今回契約したのはホームタイプなので、グローバルIPアドレスが動的ですが割り当てられます。そこで`Dynamic DNS`を利用して、インターネット側から家のルーターを名前解決できるようにしました。

その上で、家とAWSのVPC間を拠点間VPNを構築し、AWS側と通信できるようにしました。AWSにはブログとかをホストしているサーバを1台飼っているのです。

## ネットワーク構築中に気にしたこと
ネットワーク構築している際に気にしたことどもをまとめます。

### 使っていたnasneのIPアドレスがわからなくなっていた問題
6年前に日本にいたときに利用していたnasneのIPアドレスがわからなくなっていました。どうやら過去の自分はnasne側で静的にIPアドレスを割り振っていたみたいで、そのアドレスがどうしてもわからなくなってしまいました。

昔のブログ記事にnasneのIPアドレスを記載していることに気づいて、ことなきを得たのでした。

教訓としては、IPアドレスを固定したい場合には、ルーターのDHCPサーバの設定で、MACアドレス指定で固定のIPアドレスを割り当てるようにしました。これなら機器側の設定はDHCPだけど、利用者視点では固定IPになるのでトラブルシュートしやすいはず。

### ウェブブラウザで一部表示できないページが出てきた問題
ウェブブラウザでインターネットを表示させていると、一部表示できないページがあることに気づきました。色々と調べていくと、mtuの値などが原因のようでした。

この問題については、「[EdgeRouterLiteを使ってiijmioひかりでインターネット接続する方法メモ - /home/tnishinaga/TechMEMO](https://tnishinaga.hatenablog.com/entry/2015/05/07/035448)」を参照して解決することができました。

## ネットワーク構築後に出てきた問題とか
構築後に気づいた問題点などをまとめます。

### VPN接続した際に Windows PC にリモート接続できない
「0x4」というエラーコードが出て、うまく接続できませんでした。。なぜだ。。

### VPN接続した際に、VMWareのWebUIにアクセスするとうまく表示できない
これもなぜだろう。。HTTPs通信がうまいこと動作していない気がします。VMWare側の問題な気がしています。。

### 会社のPCを家のネットワークに接続するな問題
コンプライアンスとかあるからね。vLANを切って、対応したよ。[EdgeRouter - VLAN-Aware Switch &ndash; Ubiquiti Support and Help Center](https://help.ui.com/hc/en-us/articles/115012700967-EdgeRouter-VLAN-Aware-Switch)を参考にしました。

## 参考
- [EdgeRouter X - 6. 自宅にどこからでもアクセスできるようにする ( リモートアクセス VPN ) | yabe.jp](https://yabe.jp/gadgets/edgerouter-x-06-l2tp/)
- [EdgeRouter X - 7. 自宅と実家の２つの LAN を拠点間 VPN でつなぐ ( OpenVPN ) | yabe.jp](https://yabe.jp/gadgets/edgerouter-x-07-site-to-site-openvpn/)
- [VyOSで安物ルータを置き換える - ザキンコのブログ](https://zakinco.hatenablog.com/entry/2018/11/20/171717)
- [EdgeRouter X をなるべくCLIで設定する - Qiita](https://qiita.com/maiani/items/08dbfbd9e6663da86079#firewall%E3%81%AE%E8%A8%AD%E5%AE%9A)
- [EdgeRouterLiteを使ってiijmioひかりでインターネット接続する方法メモ - /home/tnishinaga/TechMEMO](https://tnishinaga.hatenablog.com/entry/2015/05/07/035448)
- [EdgeRouter - VLAN-Aware Switch &ndash; Ubiquiti Support and Help Center](https://help.ui.com/hc/en-us/articles/115012700967-EdgeRouter-VLAN-Aware-Switch)
