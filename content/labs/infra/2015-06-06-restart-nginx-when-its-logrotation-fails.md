---
title: nginxのログローテーションがうまく動いていないのでmonitを使って対症療法してみた
author: kazu634
date: 2015-06-06
tmac_last_id:
  - 665467420228890624
author:
  - kazu634
categories:
  - nginx
  - wordpress

---
LinuxなどのOSでは、Cronなどの仕組みを使ってログのローテーションをします。しかし最近`nginx`のログローテーションがうまく動かず、アクセスログが空になっている時があることに気づきました。これは問題です。というのも、`nginx`のログからレスポンスタイムを分析しているため、ログが取得できないとグラフがおかしくなってしまうのです。

そこで<a href="https://mmonit.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://mmonit.com/', 'Monit');">Monit</a>を利用して対症療法を取ることにしました。

## 具体的に何をしたのか

<a href="https://mmonit.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://mmonit.com/', 'Monit');">Monit</a>の機能の一つに、「ファイルが一定時間更新されていなければ、任意のコマンドを実行する」というものがあります。このブログは60秒間隔で正常なレスポンスを返すか確認を受けている状態のため、必ず60秒に一度はアクセスが有ります。そこで、この機能を利用することにしました。

具体的には、monitの設定ファイルに以下を追加しました:

```
check file nginx-blog with path /var/log/nginx/front_proxy.access.log
    if timestamp &gt; 2 minutes for 5 cycles then exec "/etc/init.d/nginx restart"
```

要するに、2分以上更新されないのが5回繰り返されたら、`nginx`を再起動します。

しばらくしていると、ログローテーションのタイミングでまたログにうまく書き込まれない自体が発生しました。このことを<a href="https://mmonit.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://mmonit.com/', 'Monit');">Monit</a>が検知、`nginx`を再起動してくれました。

<a href="https://www.flickr.com/photos/42332031@N02/17899474204" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/17899474204', '');" title="Slack by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://c1.staticflickr.com/9/8831/17899474204_7a19d23d3a.jpg" alt="Slack" width="500" height="168" /></a>

最後でPIDの変更を検知していて、`nginx`が再起動していることがわかります。

これでまた安心して寝ていられます。本格対応に向けた調査はこれから頑張っていこうと思います。
