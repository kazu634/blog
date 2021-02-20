+++
categories = ["VyOS","Edgerouter"]
description = "EdgeRouter XとVyOS on AWSでOpenVPNを用いた拠点間VPNをはりました"
tags = []
date = "2016-10-31T21:07:13+08:00"
draft = false
title = "EdgeRouter XとVyOS on AWSで拠点間VPNを構築する"
images = ["images/3100879440_3e9d0ff8dc_b.jpg"]
+++

[EdgeRouter X がすごい \| yabe\.jp](http://yabe.jp/gadgets/edgerouter-x/)に触発されて、EdgeRouter Xを購入しました。手元のハードとしてきちんとしたルーターがあるっていいことだと思います。色々と実験できるので。

さて今回はEdgeRouter XとVyOS on AWSでOpenVPNを用いた拠点間VPNをはりました。

## この記事で扱うこと・扱わないこと
- `EdgeRouter X`と`VyOS`で以下にして拠点間VPNをはるかを扱います
- AWSについては詳しくは扱いません (`Security Group`やネットワークについてなど)

## 概要
EdgeRouter XとVyOS on AWSでOpenVPNを用いた拠点間VPNをはりました。簡単なネットワーク図としては以下のような感じです:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/30688075115/in/dateposted/" title="edgerouter-vyos-on-aws"><img src="https://c4.staticflickr.com/6/5453/30688075115_ecf27d00b3_b.jpg" width="808" height="253" alt="edgerouter-vyos-on-aws"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## 前提条件
構成する`OpenVPN`の情報、およびに利用したVyOSとEdgeRouterの情報です。

### OpenVPNの情報
| Items |   自宅   |   AWS   |
|:-----:|:--------:|:-------:|
|グローバルIP|home.kazu634.com|54.238.253.225|
|WAN側インターフェース|eth0|eth0|
|LAN側ネットワーク|192.168.10.0/24|10.0.10.0/24|
|OpenVPNトンネルIPアドレス|192.168.115.2|192.168.115.1|

### EdgeRouter X
利用したEdgeRouter Xは以下のとおりです:

```
admin@ubnt:~$ show version
Version:      v1.9.0
Build ID:     4901118
Build on:     08/04/16 11:31
Copyright:    2012-2016 Ubiquiti Networks, Inc.
HW model:     EdgeRouter X 5-Port
HW S/N:       802AA85C1DF4
Uptime:       13:38:07 up 1 day,  4:33,  1 user,  load average: 1.16, 1.60, 1.86
```

### VyOS on AWS
利用したVyOSは以下のとおりです:

```
vyos@VyOS-AMI:~$ show version
Version:      VyOS 1.1.7
description:  VyOS 1.1.7 (helium)
Copyright:    2016 VyOS maintainers and contributors
Built by:     maintainers@vyos.net
Built on:     Wed Feb 17 09:57:31 UTC 2016
Build ID:     1602170957-4459750
System type:  x86 64-bit
Boot via:     image
Hypervisor:   Xen hvm
HW model:     HVM domU
HW S/N:       ec24bd54-36b0-acde-7804-900f0a6c0510
HW UUID:      EC24BD54-36B0-ACDE-7804-900F0A6C0510
Uptime:       22:25:54 up 28 min,  1 user,  load average: 0.00, 0.01, 0.02
```

## VyOS on AWS側の作業
AWS側の作業としては以下になります:

### VyOSのインスタンスを作成する
ここでは詳しくは説明しませんが、VyOSのインスタンスを作成します。私は`t2.nano`で作成しました。

今回作成する際はGlobal側のインターフェースを付与し、グローバルIPアドレスを割り当てました。

### ENIを追加する
Private側のインターフェースを追加します。

### ENIのプロミスキャスモードをオンにする
VyOSのインスタンスにアサインしたENIのプロミスキャスモードをオンにします。要するにここです:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/30054543483/in/dateposted/" title="EC2 Management Console"><img src="https://c4.staticflickr.com/6/5501/30054543483_95f2d3e98a_b.jpg" width="970" height="401" alt="EC2 Management Console"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/30056697944/in/dateposted/" title="EC2 Management Console-1"><img src="https://c1.staticflickr.com/6/5785/30056697944_a227492cbf.jpg" width="399" height="260" alt="EC2 Management Console-1"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## ルーティング
Global側のネットワークのルーティングテーブルに、192.168.10.0/24へのルーティングとして、VyOSのGlobal側のNICを指定します。Private側のネットワークのルーティングテーブルに192.168.10.0/24へのルーティングとして、VyOSのPrivate側のNICを指定します。

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/30646346301/in/dateposted/" title="VPC Management Console"><img src="https://c6.staticflickr.com/6/5598/30646346301_1c74b54c99.jpg" width="500" height="158" alt="VPC Management Console"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## VyOS上で実施する設定
各種設定を説明します。

### タイムゾーンの設定
タイムゾーンの設定をしておくと、後で役に立つはずです:

```
configure
set system time-zone Asia/Tokyo
commit
save
```

### 追加したENIにIPアドレスを付与する
追加したENIにIPアドレスを付与します。とりあえずここではDHCPで割り当てます:

```
configure
set interfaces ethernet eth1
set interfaces ethernet eth1 address dhcp
commit
save
```

### デフォルトゲートウェイの設定
NICが2つ以上あるので、デフォルトゲートウェイを明示的に指定してあげます。ここではGlobal側のゲートウェイをデフォルトゲートウェイとして指定します:

```
configure
set system gateway-address 10.0.1.1
commit
save
```

### OpenVPNの設定
最後に`OpenVPN`の設定を実施します。

#### 共通秘密鍵の作成
オペレーションモードで以下のコマンドを実行します:

```
generate openvpn key /config/auth/aws-home
```

#### OpenVPNの設定
```
configure

set interfaces openvpn vtun1
set interfaces openvpn vtun1 mode site-to-site

## OpenVPN のプロトコルを指定
set interfaces openvpn vtun1 protocol udp

## OpenVPN が使うポート番号を設定
set interfaces openvpn vtun1 local-port 51194
set interfaces openvpn vtun1 remote-port 51194

## OpenVPN のトンネルの IP アドレスを設定
set interfaces openvpn vtun1 local-address 192.168.115.1
set interfaces openvpn vtun1 remote-address 192.168.115.2

## EdgeRouter X on 自宅のグローバルIPを設定
set interfaces openvpn vtun1 remote-host home.kazu634.com

## 共通鍵の場所を指定
set interfaces openvpn vtun1 shared-secret-key-file /config/auth/aws-home

## 色々な OpenVPN のオプションを設定
set interfaces openvpn vtun1 openvpn-option "--comp-lzo"
set interfaces openvpn vtun1 openvpn-option "--float"
set interfaces openvpn vtun1 openvpn-option "--ping 10"
set interfaces openvpn vtun1 openvpn-option "--ping-restart 20"
set interfaces openvpn vtun1 openvpn-option "--ping-timer-rem"
set interfaces openvpn vtun1 openvpn-option "--persist-tun"
set interfaces openvpn vtun1 openvpn-option "--persist-key"
set interfaces openvpn vtun1 openvpn-option "--user nobody"
set interfaces openvpn vtun1 openvpn-option "--group nogroup"
set interfaces openvpn vtun1 openvpn-option "--fragment 1280”

## 自宅側のネットワークにアクセスする時に OpenVPN を使うよう Static Route 設定
set protocols static interface-route 192.168.10.0/24 next-hop-interface vtun1

## 設定を保存する
commit
save
```

## EdgeRouter X on 自宅側の設定
以下の設定を実施します:

### 共通秘密鍵のコピペ
VyOS on AWS側で作成した`/config/auth/aws-home`の内容をコピペし、`EdgeRouter X`側に同じパス・ファイル名で秘密鍵ファイルを作成します。

なお、権限を600にしておく必要がありますので、注意ください。おそらくこんな感じで作業したはずです:

```
sudo -s
vi /config/auth/aws-home
chmod 600 /config/auth/aws-home
```

### OpenVPNの設定
以下の設定を実施します:

```
configure

set interfaces openvpn vtun1
set interfaces openvpn vtun1 mode site-to-site

## OpenVPN のプロトコルを指定
set interfaces openvpn vtun1 protocol udp

## OpenVPN が使うポート番号を設定
set interfaces openvpn vtun1 local-port 51194
set interfaces openvpn vtun1 remote-port 51194

## OpenVPN のトンネルの IP アドレスを設定
set interfaces openvpn vtun1 local-address 192.168.115.2
set interfaces openvpn vtun1 remote-address 192.168.115.1

## VyOS on AWSのグローバルIPを設定
set interfaces openvpn vtun1 remote-host 54.238.253.225

## 共通鍵の場所を指定
set interfaces openvpn vtun1 shared-secret-key-file /config/auth/aws-home

## 色々な OpenVPN のオプションを設定
set interfaces openvpn vtun1 openvpn-option "--comp-lzo"
set interfaces openvpn vtun1 openvpn-option "--float"
set interfaces openvpn vtun1 openvpn-option "--ping 10"
set interfaces openvpn vtun1 openvpn-option "--ping-restart 20"
set interfaces openvpn vtun1 openvpn-option "--ping-timer-rem"
set interfaces openvpn vtun1 openvpn-option "--persist-tun"
set interfaces openvpn vtun1 openvpn-option "--persist-key"
set interfaces openvpn vtun1 openvpn-option "--user nobody"
set interfaces openvpn vtun1 openvpn-option "--group nogroup"
set interfaces openvpn vtun1 openvpn-option "--fragment 1280"

## AWS側のネットワークにアクセスする時に OpenVPN を使うよう Static Route 設定
set protocols static interface-route 10.0.10.0/24 next-hop-interface vtun1

## 設定を保存する
commit
save
```

## 動作確認とか
相互に`ping`で疎通が取れればOKです。ステータス確認コマンドとしては、以下のコマンドがあるようです:

### EdgeRouter X on 自宅
動作確認コマンドの実行サンプル:

```
admin@ubnt:~$ show openvpn status site-to-site
OpenVPN client status on vtun1 []

Remote CN       Remote IP       Tunnel IP       TX byte RX byte Connected Since
--------------- --------------- --------------- ------- ------- ------------------------
None (PSK)      54.238.253.225  192.168.115.1      2.2K    1.8K N/A
```

### VyOS on AWS
動作確認コマンドの実行サンプル:

```
vyos@VyOS-AMI:~$ show openvpn site-to-site status

OpenVPN client status on vtun1 []

Remote CN       Remote IP       Tunnel IP       TX byte RX byte Connected Since
---------       ---------       ---------       ------- ------- ---------------
None (PSK)      home.kazu634.com 192.168.115.2     22.3K   23.9K N/A
```
