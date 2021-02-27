---
title: 'Japan Vyatta Users Meeting Spring 2013 in Tokyo #jvum2013s'
author: kazu634
date: 2013-04-05
author:
  - kazu634
categories:
  - Labs
  - Infra
tags:
  - vyatta
  
---
<a href="http://atnd.org/event/jvum2013s" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://atnd.org/event/jvum2013s', 'Japan Vyatta Users Meeting Spring 2013 in Tokyo');">Japan Vyatta Users Meeting Spring 2013 in Tokyo</a>に参加して来ました。Vyatta、インフラ系のエンジニアにとっては「仮想環境で複数ネットワーク環境にするために導入するソフトウェアルータ」というイメージしかありません。SDN(Software Defined Network)という言葉がこれから来そうな中で、どのように使われているのかユースケースを知りたくて参加してみました。

<img class="aligncenter" alt="" src="http://www.vyatta-users.jp/390786964421033_547dc903.png" />
  
<!--more-->

## Vyatta Update

はじめのセッションがこちら。存じ上げなかったのですが、VyattaはBrocadeという会社に買収されていたのですね！！！というわけで、Brocade社の方がこれからVyattaがどうなるかを発表してました。

### Brocade Acquires Vyatta!で何が変わった？

子会社の形で継続するそうです。

> Vyatta will continue to support the open source community. Without its support, the company would not have grown to be a leader in the software-based networking movement.

要するにVyattaの日本法人ができたイメージだとか。

### Vyattaのターゲット

Vyattaの中の人達は Japan をターゲットにもっと展開して行きたいということなんだそうです。日本のコミュニティが熱いからなんだって。日本ってすごい。

  * AWS
  * US Federal
  * Japan!!!

### ロードマップ

これからのバージョンアップによる機能追加について。自分のネットワーク力が弱すぎてよくわからずorz

  * Multicast routing
  * DMVPN
  * SNMPv3

## VTIの中身

2つ目のセッショは、version 6.5の新機能 VTI の紹介。OSのiptablesレベルにどのように落としこんで実現しているかを解説してくれていた…のだと思う。基本に立ち返るの大事。ただ、自分のネットワーク力が弱すぎてよくわからず。。。

## VyattaでつくるプライベートVPS

ここからユースケースになって、自分でも何とか理解できる内容に。AWSのユーザーを代表するという建前で <a href="http://d.hatena.ne.jp/j3tm0t0/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/j3tm0t0/', '@jstm0t0');" target="_blank">@jstm0t0</a>さんが、VyattaでVPNを活用するケースを紹介して頂きました。

## Azure de Vyatta

Vyattaを活用して、AzureとSakuraインターネットをVPNで相互接続するデモをして頂きました。ネットワーク力が弱すぎて時々技術的な内容がよくわからなかったけれど、ネットワークエンジニアの方々が普段どんなことを考えているのかが理解できた気がする。スライドは<a href="http://www.slideshare.net/kazumihirose/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.slideshare.net/kazumihirose/', 'こちら');" target="_blank">こちら</a>

とりあえず学んだのは MSS 値について:

> TCPで通信を行う際に指定する、データの送信単位(セグメント)の最大値。
> 
> TCPではセグメントと呼ばれる大きさごとにデータを区切って送受信を行う。セグメントの大きさは16ビットの値で表現され、最大で64KBまで設定できる。通信を行うときは受信側が最初にMSSオプションで自らが受信できるセグメントの最大値を送信側に通知し、送信側はこれを超えないようデータを細かいセグメントに分割して送信する。

送信する時のTCP/IPヘッダを含んだ最大サイズがMTUで、TCP/IPヘッダを含まないのが MSS ということなのかな？たぶん。

## Nifty Cloud

こちらも Vyatta を利用して、Nifty Cloud と Sakura インターネットをVPNで相互接続するデモをなさっていました。すごい。

## さくらのクラウド

Vyattaを使った利用ケースの紹介。

  * L2TP/IPSecがおすすめ
  * プライベートクラウドとつなぐ場合は IPSec がおすすめ

## VyattaCore Tips 2013

なんか聞いていて夢が膨らむユースケースの紹介。こんなことができるようになるのかースライドは<a href="http://www.slideshare.net/naotomatsumoto/vyattacore-tips2013" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.slideshare.net/naotomatsumoto/vyattacore-tips2013', 'こちら');" target="_blank">こちら</a>です。

## 懇親会

Amazonの中の @j3tm0t0 さんや @kazumihirose さんとお話させて頂きました。@naoto_matsumotoさんともお話できた。

今回のセミナーと懇親会で、個人的にクラウドサービスを利用してみようと決意。とりあえず AWS！
