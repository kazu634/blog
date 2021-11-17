+++
author = "kazu634"
description = "ゴールデンウィークの暇潰しにGoogle Nestで任意の文章を喋らせるようにしてみました。"
categories = ["プログラミング"]
tags = ["node.js"]
date = "2021-05-05T20:53:36+09:00"
title = "google-home-notifierでGoogle Nestを喋らせてみました。"
+++

google-home-notifierでGoogle Nestを喋らせてみました。これまでの流れをまとめてみました。

## TL;DR
発端はこのような形でした:

{{< tweet 1389508813200396291 >}}

{{< tweet 1389554264310124545 >}}

{{< tweet 1389775994584657922 >}}

{{< tweet 1389862890853650432 >}}

というわけで、以下のようにコマンドを実行すると、

{{< asciinema 411953 >}}

次のようにGoogle Homeを喋らせることができました。

{{< youtube jyTQXF0ogIc >}}

## 事前準備
`Node.js`を利用できるようにしておきましょう。ここでは詳しくは解説しません。また、Ubuntuの場合は、以下のパッケージをインストールしておきます:

- `libnss-mdns`
- `libavahi-compat-libdnssd-dev`

## google-home-notifierのインストール
オフィシャルなGithubリポジトリはメンテナンスがされておらず、うまく動作しなかったため、プルリクが来ていたリポジトリからインストールする必要があるようでした。

### リポジトリからのインストール
[Support google-tts-api@2.0.2 by TomPenguin · Pull Request #55 · noelportugal/google-home-notifier · GitHub](https://github.com/noelportugal/google-home-notifier/pull/55)を参考にして、以下のコマンドを実行して、リポジトリからインストールします:

```bash
% git clone https://github.com/TomPenguin/google-home-notifier.git
% cd google-home-notifier
% git checkout origin/feature/support-new-google-tts-api
```

### 必要なライブラリのインストール
以下のコマンドを実行して、必要なライブラリをダウンロードします:

```bash
% npm install
```

### npm install実施後に行うソース修正
修正が必要ということなので、以下を修正します:

|項目  |値                                |
|----|---------------------------------|
|修正対象| `node_modules/mdns/lib/browser.js`|

修正前:

```js
Browser.defaultResolverSequence = [
  rst.DNSServiceResolve(), 'DNSServiceGetAddrInfo' in dns_sd ? rst.DNSServiceGetAddrInfo() : rst.getaddrinfo()
, rst.makeAddressesUnique()
];
```

修正後:

```js
Browser.defaultResolverSequence = [
  rst.DNSServiceResolve(), 'DNSServiceGetAddrInfo' in dns_sd ? rst.DNSServiceGetAddrInfo() : rst.getaddrinfo({families:[4]})
, rst.makeAddressesUnique()
];
```

## google-home-notifierを利用してみる
調べてみた限り、以下の二通りの方法があるようでした:

1. example.jsを利用する
2. 自分でコードを作成する

### example.jsを利用して、APIサーバを動かす

git cloneしたディレクトリにある`example.js`を以下のように修正します。修正前は`ngrok`を利用したり、ポルトガル語前提だったりするため。


```js
var express = require('express');
var googlehome = require('./google-home-notifier');
var ngrok = require('ngrok');
var bodyParser = require('body-parser');
var app = express();
const serverPort = 8091; // default port

var deviceName = 'Google Home Mini';
var ip = '192.168.10.50'; // default IP

var urlencodedParser = bodyParser.urlencoded({ extended: false });

app.post('/google-home-notifier', urlencodedParser, function (req, res) {

  if (!req.body) return res.sendStatus(400)
  console.log(req.body);

  var text = req.body.text;

  if (req.query.ip) {
     ip = req.query.ip;
  }

  var language = 'ja'; // default language code
  if (req.query.language) {
    language;
  }

  googlehome.ip(ip, language);
  googlehome.device(deviceName,language);

  if (text){
    try {
      if (text.startsWith('http')){
        var mp3_url = text;
        googlehome.play(mp3_url, function(notifyRes) {
          console.log(notifyRes);
          res.send(deviceName + ' will play sound from url: ' + mp3_url + '\n');
        });
      } else {
        googlehome.notify(text, function(notifyRes) {
          console.log(notifyRes);
          res.send(deviceName + ' will say: ' + text + '\n');
        });
      }
    } catch(err) {
      console.log(err);
      res.sendStatus(500);
      res.send(err);
    }
  }else{
    res.send('Please GET "text=Hello Google Home"');
  }
})

app.get('/google-home-notifier', function (req, res) {

  console.log(req.query);

  var text = req.query.text;

  if (req.query.ip) {
     ip = req.query.ip;
  }

  var language = 'ja'; // default language code
  if (req.query.language) {
    language;
  }

  googlehome.ip(ip, language);
  googlehome.device(deviceName,language);

  if (text) {
    try {
      if (text.startsWith('http')){
        var mp3_url = text;
        googlehome.play(mp3_url, function(notifyRes) {
          console.log(notifyRes);
          res.send(deviceName + ' will play sound from url: ' + mp3_url + '\n');
        });
      } else {
        googlehome.notify(text, function(notifyRes) {
          console.log(notifyRes);
          res.send(deviceName + ' will say: ' + text + '\n');
        });
      }
    } catch(err) {
      console.log(err);
      res.sendStatus(500);
      res.send(err);
    }
  }else{
    res.send('Please GET "text=Hello+Google+Home"');
  }
})

app.listen(serverPort, function () {
})
```

なお、Google HomeのIPアドレスはアプリから調べることができます:

![Image](https://farm66.staticflickr.com/65535/51160371155_3b1420c44e_c.jpg)

修正後、以下のコマンドを実行します:

```bash
% node example.js
*** WARNING *** The program 'node' uses the Apple Bonjour compatibility layer of Avahi.
*** WARNING *** Please fix your application to use the native API of Avahi!
*** WARNING *** For more information see <http://0pointer.de/blog/projects/avahi-compat.html>
*** WARNING *** The program 'node' called 'DNSServiceRegister()' which is not supported (or only supported partially) in the Apple Bonjour compatibility layer of Avahi.
*** WARNING *** Please fix your application to use the native API of Avahi!
*** WARNING *** For more information see <http://0pointer.de/blog/projects/avahi-compat.html>
```

別なターミナルを立ち上げて、以下のようにするとGoogle Homeを喋らせることができました:

```bash
% curl -X POST -d "text=ゴールデンウィークが終わろうとしていて、サザエさんシンドロームにかかりつつあります。" http://localhost:8091/google-home-notifier
```

もしくは、`GET`リクエストでも大丈夫みたい:

```bash
% curl "http://localhost:8091/google-home-notifier?text=Hello+Google+home"
```

### 自分でコードを作成する
自分でコードを作成する場合は、このようなソースコードを作ればいいみたいです。

```js
var googlehome = require('./google-home-notifier');
var language = 'ja'; // if not set 'us' language will be used

// googlehome.device('Google Home Mini', language); // Change to your Google Home name
// or if you know your Google Home IP
googlehome.ip('192.168.10.50', language);

googlehome.notify('ゴールデンウィークが終わろうとしていて、サザエさんシンドロームにかかりつつあります。', function(res) {
  console.log(res);
});
```

これを`test.js`などとして保存し、以下のようにすると、Google Homeを喋らせることができました:

```bash
% node test.js
*** WARNING *** The program 'node' uses the Apple Bonjour compatibility layer of Avahi.
*** WARNING *** Please fix your application to use the native API of Avahi!
*** WARNING *** For more information see <http://0pointer.de/blog/projects/avahi-compat.html>
*** WARNING *** The program 'node' called 'DNSServiceRegister()' which is not supported (or only supported partially) in the Apple Bonjour compatibility layer of Avahi.
*** WARNING *** Please fix your application to use the native API of Avahi!
*** WARNING *** For more information see <http://0pointer.de/blog/projects/avahi-compat.html>
Device notified
```

## 参考
- [Google Home/Nestを喋らせるgoogle-home-notifierの導入マニュアル [2020年12月版] - RemoteRoom](https://remoteroom.jp/diary/2020-12-31/)
- [GitHub - noelportugal/google-home-notifier: Send notifications to Google Home](https://github.com/noelportugal/google-home-notifier)
- [GitHub - TomPenguin/google-home-notifier at feature/support-new-google-tts-api](https://github.com/TomPenguin/google-home-notifier/tree/feature/support-new-google-tts-api)
