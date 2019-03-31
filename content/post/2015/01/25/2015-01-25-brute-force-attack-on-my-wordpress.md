---
title: ブルートフォースアタックの形跡があったんだけど。。。
author: kazu634
date: 2015-01-25
url: /2015/01/25/brute-force-attack-on-my-wordpress/
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:6634;}'
wordtwit_post_info:
  - 'O:8:"stdClass":14:{s:6:"manual";b:1;s:11:"tweet_times";i:1;s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";s:135:"ブログに新しい記事を投稿したよ: ブルートフォースアタックの形跡があったんだけど。。。 - [link] ";s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:6634;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}s:4:"text";s:154:"ブログに新しい記事を投稿したよ: ブルートフォースアタックの形跡があったんだけど。。。 - http://tinyurl.com/obbuoek";}'
tmac_last_id:
  - 584003938069962752
categories:
  - インフラ

---
<a href="https://www.flickr.com/photos/sonickphotographie/14381819697" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/sonickphotographie/14381819697', '');" title="Impossible is not AP Tune's by Yannick Soler, on Flickr"><img class=" aligncenter" src="https://farm3.staticflickr.com/2901/14381819697_287de5e033.jpg" alt="Impossible is not AP Tune's" width="500" height="333" /></a>

ふとウェブサーバーのアクセスログをグラフ化したものを確認していたら、突発的なアクセス数の増加がありました:

<a href="https://www.flickr.com/photos/42332031@N02/16361831681" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16361831681', '');" title="access by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7373/16361831681_48204328e0.jpg" alt="access" width="466" height="207" /></a>

普段は10アクセス/分もないのに、15:00〜17:00付近でだけ突発的に、200アクセス/分ほどになっています。こういう時は、Googleなどのボットくんがせっせとアクセスしていることが多いので、今回もおそらくそうなのだろうと、レスポンスタイムを確認しました:

<a href="https://www.flickr.com/photos/42332031@N02/16363566745" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16363566745', '');" title="response by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8661/16363566745_3c35ef6b58.jpg" alt="response" width="465" height="331" /></a>

ボットくんたちがアクセスするときは、だいたいこんなグラフになります。たいていは500ms以内でレスポンスを返している感じ。ここまでは問題なしでした。念のためサーバーのリソースも確認してみました。Load Averageはこんな感じ。まぁ、アクセスが多くなれば、それなりに負荷もかかるからここは特に問題なさそう:

<a href="https://www.flickr.com/photos/42332031@N02/16362674042" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16362674042', '');" title="load_average by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8612/16362674042_10b1eb2d1f.jpg" alt="load_average" width="466" height="219" /></a>

次にCPU使用率を見てみました。ここでおかしな点が…:

<a href="https://www.flickr.com/photos/42332031@N02/16337601976" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16337601976', '');" title="cpu by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7374/16337601976_5218815e91.jpg" alt="cpu" width="467" height="308" /></a>

うちのWordpressサーバーくんは、動的にコンテンツ生成をしていません。基本はキャッシュに乗せているはずなので、Userの割合がこんなに高くなるわけがない。キャッシュ上のファイルを配信するだけだから、Systemやiowait、もしくはsoftirqなんかが高くなるのならわかるんだけど。

と思って、RAMディスクとしてマウントしているキャッシュ領域の使用率を見てみました:

<a href="https://www.flickr.com/photos/42332031@N02/15743595963" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15743595963', '');" title="disk_usage by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7400/15743595963_4503398e12.jpg" alt="disk_usage" width="468" height="205" /></a>

ボットくんのアクセスだと、ここの使用率が50%を超えてくるんだけど、今回はほぼヨコバイです。何かがおかしい。ちょっとおかしいなと思って、ウェブサーバーのログを確認してみました:

<pre class="lang:sh decode:true " title="とりあえずheadしてみた">% grep "25/Jan/2015:1[567]" front_proxy.access.log | cut -f 2,5 | head
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php
host:37.187.29.175      path:/wp-login.php</pre>

あれ、なんかログインページへのアクセスが多い気がする。。。きちんと見てみます:

<pre class="lang:sh decode:true " title="カウントしてみました">% grep "25/Jan/2015:1[567]" front_proxy.access.log | cut -f 2,5 | sort | uniq -c | sort | tail
      2 host:91.200.12.29       path:/wp-comments-post.php
      3 host:157.55.39.46       path:/2010/09/10/hello-world/
      3 host:199.59.148.209     path:/robots.txt
      3 host:91.200.12.56       path:/2013/12/22/fibre_flare_light_lpt04602/
      3 host:91.200.12.56       path:/wp-comments-post.php
      4 host:195.211.154.44     path:/2013/05/06/chef_package_installation_with_preseedings/
      4 host:211.138.144.18     path:/
    180 host:126.114.163.124    path:/
    180 host:133.242.151.82     path:/
  15276 host:37.187.29.175      path:/wp-login.php</pre>

やっぱりです。これはブルートフォースアタックというやつですね。ログインページに攻撃を受けていたみたいです。ログイン履歴を確認する限り、自分以外はログインに成功していないようなので、とりあえず放置しておこうと思います。