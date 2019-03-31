---
title: Nginxでサーバ名未定義のリクエスト処理を防ぐ
author: kazu634
date: 2014-09-11
url: /2014/09/11/how_to_prevent_nginx_from_not_handling_the_request_without_virtual_hostname/
geo_latitude:
  - 38.306195
geo_longitude:
  - 141.022785
geo_public:
  - 1
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1802;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1802;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
tmac_last_id:
  - 521294484202479616
categories:
  - growthforecast

---
`Growthforecast`で`Nginx`のアクセスログを可視化していると、なぜか設定していない Virtual Host からのアクセスがログに残っていることに気づきました。というわけでちょっと調査してみたのでした。

## 原因

`Ngixn`は特に指定しないと、設定ファイルの先頭の`server`設定をデフォルト設定にして、アクセス処理をしてしまうため。

## 回避策

<a href="http://nginx.org/ja/docs/http/request_processing.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://nginx.org/ja/docs/http/request_processing.html', 'nginx はどのようにリクエストを処理するか');">nginx はどのようにリクエストを処理するか</a>に書いていました:

> `Host` ヘッダが未定義のリクエストを処理させたくない場合は、リクエストを単にドロップさせるデフォルトサーバを設定できます:
> 
> <pre class="lang:default decode:true ">server {
    listen       80  default&lt;em&gt;server;
    servername  _;
    return       444;
}</pre>