+++
title = "RaspberryPIで電子工作を始めてみました"
date = 2021-04-04T13:47:22+09:00
description = "なかなか外出できないので、おうちでRaspberryPIをいじってみた結果をまとめました。"
tags = ["電子工作"]
categories = ["RaspberryPI"]
author = "kazu634"
images = ["ogp/2021-04-04-raspberrypi-electronics.webp"]
+++

日本に帰国し、リモートワークが徹底されていることに気がついたため、自宅内でCO2濃度を計測してみたいと思い立って、手を動かしています。そのメモになります。

## RaspberryPIとは
RaspberryPIとは、GPIOと呼ばれる入出力端子を持つLinuxボックス…という言い方ができそうです。GPIOというのを経由して、センサーなどの機器とLinuxボックスであるRaspberryPIがやりとりできる仕組みのようです。

お手軽で安価に、センサーなどの電子機器とやりとりして、電子機器の情報をITの世界に持ってこれるというのが、RaspberryPIのすごいところ…というのが今の理解です。

## ラズパイと繋げてみます
[『ラズパイ4対応 カラー図解 最新 Raspberry Piで学ぶ電子工作 作る、動かす、しくみがわかる! (ブルーバックス)』](https://www.amazon.co.jp/%E3%83%A9%E3%82%BA%E3%83%91%E3%82%A44%E5%AF%BE%E5%BF%9C-Raspberry-Pi%E3%81%A7%E5%AD%A6%E3%81%B6%E9%9B%BB%E5%AD%90%E5%B7%A5%E4%BD%9C-%E4%BD%9C%E3%82%8B%E3%80%81%E5%8B%95%E3%81%8B%E3%81%99%E3%80%81%E3%81%97%E3%81%8F%E3%81%BF%E3%81%8C%E3%82%8F%E3%81%8B%E3%82%8B-%E3%83%96%E3%83%AB%E3%83%BC%E3%83%90%E3%83%83%E3%82%AF%E3%82%B9/dp/4065193397)を参考書籍としてラズパイと繋げていきます。

この書籍のすごいところは、扱われている部品一式もセットで提供されているところです。[ラズパイ４対応　Ｒａｓｐｂｅｒｒｙ　Ｐｉで学ぶ電子工作（書籍＋パーツセット）](https://akizukidenshi.com/catalog/g/gK-15352/)です。このセットを購入しました。

ちなみに、この時点でラズパイは全く触ったことなしでした。。上のパーツセットにはラズパイOSイメージ書き込み済みのSDカードが入っていたので、それを繋げて起動させることができました。ラズパイは起動さえしてしまえば、Linuxが動作するため、すんなり入っていけました。

#### LEDの点灯
まずは第一歩ということで、ラズパイとブレッドボードを単純に繋げて、LEDを光らせてみました:

![Image](https://farm66.staticflickr.com/65535/51058486767_857ab12b88_c.jpg)

GPIOと呼ばれる端子から電源を取って、LEDを点灯させています。ただ、これだと乾電池から電流を流しているのと何も変わらなくて、面白みはないですね。。

学んだこと:

- ラズパイは小さなLinux box + 「`GPIO` (General Purpose Input/Output)」と呼ばれる電子機器とのインターフェースを備えている
- `GPIO`の中には「電源 (3.3 V と 5.0 V)」と「GND」と呼ばれるピンがあって、電源→GNDの方向に繋げると、電流が流れていく

#### GPIOでLEDを制御してみた
上の例だと、乾電池をラズパイに変えただけです。これだけではつまらないので、ラズパイでLEDの制御をしてみます。ラズパイの`GPIO`はプログラム的に制御ができるようです。ソースはこちら:

```python
#!/usr/bin/python3

import RPi.GPIO as GPIO
from time import sleep

GPIO.setmode(GPIO.BCM)
GPIO.setup(25, GPIO.OUT)

try:
        while True:
                GPIO.output(25, GPIO.HIGH)
                sleep(0.5)
                GPIO.output(25, GPIO.LOW)
                sleep (0.5)

except KeyboardInterrupt:
        pass

GPIO.cleanup()
```

こちらは`GPIO`の25番目のピンを0.5秒ごとに電源オン (`GPIO.HIGH`)・オフ (`GPIO.LOW`)しているイメージのようです。動作させるとこうなります:

{{< youtube U0vWhKOWksQ >}}

学んだこと:

- `GPIO`の制御を`Python`を用いてできることがわかりました

#### ボタンスイッチでLEDのオン・オフを制御する
こちらはボタンを押すと、LEDを光らせ、もう一度押すとLEDを消す例です。プログラム的に状態を持たせて制御している感じです。

{{< youtube m8tjJlKoqkk >}}

学んだこと:

- プログラム的に制御できるのだから、状態をプログラムで持たせて制御することも当然ながらできる！

### 電子機器とのインターフェース
これまでの例だと、電流を流す流さないだけを制御していました。これからは、電子機器からの情報を取得していきます。

電子機器の情報はどうやら以下の2つのパターンで提供されているみたいです:

1. 「アナログ」と呼ばれる形式で、ラズパイがそのままだと識別できない
2. 「デジタル」と呼ばれる形式で、ラズパイがそのまま識別できる

1.の場合には、A/Dコンバーターと呼ばれる電子機器を間に挟むことになるようです。

### A/Dコンバーターを利用する (SPI通信を利用する)
A/Dコンバーターというのは、要するに流れてくる電圧を測るもののようで、それをデジタルに変換するようです。A/DコンバーターをSPI通信と呼ばれる方式で利用してみます。

#### 半固定抵抗の電圧をA/Dコンバーターで取得する
最初の例では、「半固定抵抗」というもので、手動で抵抗の値を変えて、流れてくる電圧を変えられるようにして、その値を読み取ります:

![Image](https://farm66.staticflickr.com/65535/51058488412_496ab3a90f_c.jpg)

青のつまみを回すと、抵抗の値が変わっていき、流れてくる電圧を変更できます。それをA/Dコンバーターが読み取って、ラズパイのコンソールに出力します。

#### 照度センサーの値をA/Dコンバーター経由で取得する
同じようにして、照度センサーの値をA/Dコンバーター経由で取得してみます。

![Image](https://farm66.staticflickr.com/65535/51058403726_03e95d6766_c.jpg)

#### 照度センサーの値に応じてLEDを点灯する
発展形として、照度センサーの値に応じてLEDを点灯させます:

{{< youtube 8m0BwBY4jEs >}}

学んだこと:

- A/Dコンバーターがデリケートすぎるようで、何個か壊していたようで、書籍通りにやってもうまく動かないことが多々ありました。トライアンドエラーが必要でした。。

### デジタル値を取得する (I2C通信を利用する)
ここからはデジタル値を取得していきます。取得する例として、I2C通信で温度センサーから値を取得してみます。

#### 温度センサーの値を取得する
このような形で、温度センサーを取り付けて、ラズパイと繋げました。

![Image](https://farm66.staticflickr.com/65535/51057680893_2f634d2f01_c.jpg)

学んだこと:

- A/Dコンバーターが間に挟まらないので、シンプルに値を取得できました

### LEDディスプレイと連動させる
上の例で取得した温度センサーの値をLEDディスプレイに表示されます。このようにLEDディスプレイを接続してみました:

![Image](https://farm66.staticflickr.com/65535/51057679453_f5343ea29e_c.jpg)


実際の動作はこのようになります:

{{< youtube wL9cgpSBSng >}}

学んだこと:

- LEDもI2C接続でやりとりすることで表示していることが理解できました。

## ここまでの振り返り
CO2センサーをRaspberryPIで値を取得するために、まずはRaspberryPIでセンサーの値を取得する方法まで駆け足で学んでみました。細かな原理原則は理解できていないですが、一通り何をすればいいのか、何を準備しとかなきゃいけないのかを、実際に手を動かす中で理解することができました。

<div class="krb-amzlt-box" style="margin-bottom:0px;"><div class="krb-amzlt-image" style="float:left;margin:0px 12px 1px 0px;"><a href="https://www.amazon.co.jp/%E3%83%A9%E3%82%BA%E3%83%91%E3%82%A44%E5%AF%BE%E5%BF%9C-Raspberry-Pi%E3%81%A7%E5%AD%A6%E3%81%B6%E9%9B%BB%E5%AD%90%E5%B7%A5%E4%BD%9C-%E4%BD%9C%E3%82%8B%E3%80%81%E5%8B%95%E3%81%8B%E3%81%99%E3%80%81%E3%81%97%E3%81%8F%E3%81%BF%E3%81%8C%E3%82%8F%E3%81%8B%E3%82%8B-%E3%83%96%E3%83%AB%E3%83%BC%E3%83%90%E3%83%83%E3%82%AF%E3%82%B9/dp/4065193397?&linkCode=li2&tag=simsnes-22&linkId=cb661ca1b13f63a10af0e7c8fc29a61a&language=ja_JP&ref_=as_li_ss_il" target="_blank" rel="nofollow" rel="nofollow"><img border="0" src="//ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=4065193397&Format= _SL250_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=simsnes-22&language=ja_JP" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=simsnes-22&language=ja_JP&l=li2&o=9&a=4065193397" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /></div><div class="krb-amzlt-info" style="line-height:120%; margin-bottom: 10px"><div class="krb-amzlt-name" style="margin-bottom:10px;line-height:120%"><a href="https://www.amazon.co.jp/%E3%83%A9%E3%82%BA%E3%83%91%E3%82%A44%E5%AF%BE%E5%BF%9C-Raspberry-Pi%E3%81%A7%E5%AD%A6%E3%81%B6%E9%9B%BB%E5%AD%90%E5%B7%A5%E4%BD%9C-%E4%BD%9C%E3%82%8B%E3%80%81%E5%8B%95%E3%81%8B%E3%81%99%E3%80%81%E3%81%97%E3%81%8F%E3%81%BF%E3%81%8C%E3%82%8F%E3%81%8B%E3%82%8B-%E3%83%96%E3%83%AB%E3%83%BC%E3%83%90%E3%83%83%E3%82%AF%E3%82%B9/dp/4065193397?&linkCode=li2&tag=simsnes-22&linkId=cb661ca1b13f63a10af0e7c8fc29a61a&language=ja_JP&ref_=as_li_ss_il" name="amazletlink" target="_blank" rel="nofollow" rel="nofollow">ラズパイ4対応 カラー図解 最新 Raspberry Piで学ぶ電子工作 作る、動かす、しくみがわかる! (ブルーバックス) 新書 – 2020/6/18</a><div class="krb-amzlt-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="https://kaereba.com/wind/" title="amazlet" target="_blank" rel="nofollow" rel="nofollow">カエレバ</a></div></div><div class="krb-amzlt-detail"></div><div class="krb-amzlt-sub-info" style="float: left;"><div class="krb-amzlt-link" style="margin-top: 5px"><a href="https://www.amazon.co.jp/%E3%83%A9%E3%82%BA%E3%83%91%E3%82%A44%E5%AF%BE%E5%BF%9C-Raspberry-Pi%E3%81%A7%E5%AD%A6%E3%81%B6%E9%9B%BB%E5%AD%90%E5%B7%A5%E4%BD%9C-%E4%BD%9C%E3%82%8B%E3%80%81%E5%8B%95%E3%81%8B%E3%81%99%E3%80%81%E3%81%97%E3%81%8F%E3%81%BF%E3%81%8C%E3%82%8F%E3%81%8B%E3%82%8B-%E3%83%96%E3%83%AB%E3%83%BC%E3%83%90%E3%83%83%E3%82%AF%E3%82%B9/dp/4065193397?&linkCode=li2&tag=simsnes-22&linkId=cb661ca1b13f63a10af0e7c8fc29a61a&language=ja_JP&ref_=as_li_ss_il" name="amazletlink" target="_blank" rel="nofollow" rel="nofollow">Amazon.co.jpで詳細を見る</a></div></div></div><div class="krb-amzlt-footer" style="clear: left"></div></div>
