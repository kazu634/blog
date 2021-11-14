---
title: コンシューマー向けのハイエンドルーターでVPNを利用してみた
date: 2015-01-31T15:04:05Z
author: kazu634
categories:
  - Labs
  - Network
tags:
  - vpn
---
<a href="https://www.flickr.com/photos/pedrik/5553465029" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/pedrik/5553465029', '');" title="Router by pedrik, on Flickr"><img class=" aligncenter" src="https://farm6.staticflickr.com/5251/5553465029_5fc7dbb0d2.jpg" alt="Router" width="500" height="333" /></a>

海外からだと一部のサイトが閲覧できないケースがあります。有名な例をあげれば、中国だとFacebookにアクセスできなかったりします。こうした場合、IT系のエンジニアは考えます。VPNを張ろうって。今回は実家のネットワーク環境の改善をした際に、ハイエンドルーターを導入し、VPNを利用できるようにしてみたので、その時に実施したことをつらつらとまとめてみます。

## VPNとは

VPNは、Virtual Private Networkの略です。

Virtualという言葉を「仮想」としてしまうとわかりづらくなってしまうのですが、一言で言ってしまえば、「細かな違いはあるけれども気にしなくてOK。実質的には同じだから」みたいな意味と捉えるといいかと思っています。

Private Networkというのは、「専用線」というやつです。要するに、糸電話みたいに、通信するときに、特定の二者間だけのために専用に線を引いたものを指しています。こうすると、断線しない限り確実に通信できるし、通信品質も自分達以外に利用している人がいないため、一定の水準が保証されます。

まとめると、VPNというのは、実質的には専用線と同じように機能する仕組みとなります。

## VPNを使うとどうなるのか？

VPNを利用すると、接続先のVPNサーバーからインターネットに接続することができます。つまり、自分がどこにいようとも、VPNサーバーさえ日本にあれば、VPNサーバーを経由することで日本からアクセスしていることにできるのです。海外からアクセスすると、海外のネットワーク上にあるファイアーウォールで接続をブロックされることがあります:

<a href="https://www.flickr.com/photos/42332031@N02/16408614382" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16408614382', '');" title="foreign_network by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7289/16408614382_ff48ab2d51.jpg" alt="foreign_network" width="458" height="390" /></a>

これではアクセス出来ないので、日本にあるVPNサーバーに接続してあげることで、こんな感じで接続できるようになります:

<a href="https://www.flickr.com/photos/42332031@N02/16223315139" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16223315139', '');" title="vpn_connection by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8682/16223315139_686ee7d10c.jpg" alt="vpn_connection" width="500" height="204" /></a>

海外のネットワークでブロックされるところを、うまいこと回避できてしまうわけです。Virtualな部分を強調すると、本当は上の画像の経路で接続しているのですが、こんな風にあたかも接続しているように振る舞います:

<a href="https://www.flickr.com/photos/42332031@N02/16383563386" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16383563386', '');" title="vpn_connection2 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8592/16383563386_680a6432b5.jpg" alt="vpn_connection2" width="500" height="316" /></a>

<!--more-->

## ハイエンドルーターを導入する前の実家のネットワーク環境

ハイエンドルーターを導入する前はこのようなネットワーク図でした。よく考えたら、ADSLルーターだから、ここを普通のルーターに置き換えることはできませんでした。。。:

<a href="https://www.flickr.com/photos/42332031@N02/16222004258" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16222004258', '');" title="before_001 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8639/16222004258_c354ce5e6f.jpg" alt="before_001" width="500" height="401" /></a>

## ハイエンドルーター導入後の実家のネットワーク環境

導入後はこのような形になりました:

<a href="https://www.flickr.com/photos/42332031@N02/16222239930" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16222239930', '');" title="after_001 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8629/16222239930_e521950dff.jpg" alt="after_001" width="493" height="500" /></a>

## 導入に際して実施したこと

基本的にはほとんどやることはありません。<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/', '買ってきたルーター');" target="_blank" name="amazletlink">買ってきたルーター</a>でVPN機能を有効にしてあげました。

考慮しなければいけなかったのは以下の点です:

<a href="https://www.flickr.com/photos/42332031@N02/16383668446" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16383668446', '');" title="problems by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7331/16383668446_18e9542a14.jpg" alt="problems" width="500" height="453" /></a>

①については、プロバイダーと契約するときに固定IPアドレスを取得していなければ、不定期に外部からアクセスするときのIPアドレスが変更されてしまいます。勝手に変更されてしまうと、外部からアクセスできなくなってしまうので、DDNSという仕組みを利用してあげます。DDNSというのは簡単に言うと、IPアドレスに名前をつけてあげて(例えば www.google.com とかね)、IPアドレスの変更を検知したら、名前に紐づくIPアドレスを変更してあげる仕組みです。名前は常に同じだけれども、紐づくIPアドレスは常に更新されるため、一見固定IPアドレスにしているように見せる仕組みです。PCが起動した時に更新するようにしておきました。詳細はDDNSとか、DiCEでググってください。

②については、ADSLルーターのDHCPサーバーの設定を変更してあげて、購入したルーターに常に同じIPアドレスを割り振るようにしました。

最後に、ADSLルーターのインターネット側からVPN関連のアクセスが有った際に、購入したルーターにNAT(=転送)する設定を入れてあげて、設定を終えました。

<a href="https://www.flickr.com/photos/42332031@N02/16223524009" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16223524009', '');" title="problems_002 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7396/16223524009_aaa4c3bb81.jpg" alt="problems_002" width="493" height="500" /></a>

## 接続確認

手元のiPhoneで接続確認してみました。まずはVPN接続する前のグローバルIPアドレスを確認します:

<a href="https://www.flickr.com/photos/42332031@N02/16223559419" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16223559419', '');" title="Recently Added-28 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7416/16223559419_a08dd205da.jpg" alt="Recently Added-28" width="282" height="500" /></a>

この状態でVPN接続してみます:

<a href="https://www.flickr.com/photos/42332031@N02/15789731493" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15789731493', '');" title="All Photos-56 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8565/15789731493_dafa01aba5.jpg" alt="All Photos-56" width="282" height="500" /></a>

つながりました。小さく「VPN」と表示されてることに注目:

<a href="https://www.flickr.com/photos/42332031@N02/16408007341" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16408007341', '');" title="All Photos-58 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7395/16408007341_7b0137646d.jpg" alt="All Photos-58" width="282" height="500" /></a>

この状態でグローバルIPアドレスを確認します:

<a href="https://www.flickr.com/photos/42332031@N02/16223558309" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16223558309', '');" title="Recently Added-27 by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8567/16223558309_5c41dbc783.jpg" alt="Recently Added-27" width="282" height="500" /></a>

実家から接続している状態になっているわけですから、当然ながらグローバルIPアドレスが変わっています！

* * *

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/31dPi7oqS6L._SL160_.jpg" alt="BUFFALO【iphone6 対応】11ac/n/a/b/g 無線LAN親機(Wi-Fiルーター)エアステーション AOSS2 ハイパワー Giga 1GHzデュアルコアCPU搭載 1300+600Mbps WXR-1900DHP (利用推奨環境6人・4LDK・3階建)" /></a>
</div>

<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<p>
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/', 'BUFFALO【iphone6 対応】11ac/n/a/b/g 無線LAN親機(Wi-Fiルーター)エアステーション AOSS2 ハイパワー Giga 1GHzデュアルコアCPU搭載 1300+600Mbps WXR-1900DHP (利用推奨環境6人・4LDK・3階建)');" target="_blank" name="amazletlink">BUFFALO【iphone6 対応】11ac/n/a/b/g 無線LAN親機(Wi-Fiルーター)エアステーション AOSS2 ハイパワー Giga 1GHzデュアルコアCPU搭載 1300+600Mbps WXR-1900DHP (利用推奨環境6人・4LDK・3階建)</a>
</p>

<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 15.01.31
</div>
</div>

<div class="amazlet-detail">
      バッファロー (2014-10-27)<br /> 売り上げランキング: 90
</div>

<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00O3OEQEA/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>

<div class="amazlet-footer" style="clear: left;">
</div>
</div>
