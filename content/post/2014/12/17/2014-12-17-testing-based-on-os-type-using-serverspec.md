---
title: ServerspecでOS種別に応じてテストを実行する
author: kazu634
date: 2014-12-17
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:5561;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:1;s:11:"tweet_times";i:1;s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";s:114:"ブログに新しい記事を投稿したよ: ServerspecでOS種別に応じてテストを実行する - [link] ";s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:5561;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
tmac_last_id:
  - 561519535103434752
categories:
  - serverspec

---
テスト対象のサーバーで`ohai`が導入されていることが前提ですが、以下のようにして実現できましたのでメモ:

```
require 'serverspec'
require 'json'

set :backend,  :exec

# Ubuntu 12.04 only.
# Check whether `Rabbitmq` allows ssl poodle attack:

platform_version = JSON.load(`ohai`)['platform_version']

if platform_version == "12.04"
  describe file('/etc/rabbitmq/rabbitmq.config') do
    its(:content) { should match /ssl_allow_poodle_attack/ }
  end
end
```

`ohai`は`Chef`を導入している環境であれば、まず間違いなく利用できるはず。パスも通っているはずです。

* * *

[2014/12/20追記]

mizzyさんのコメントにある通り、`serverspec`が提供するハッシュを利用して同じことが出来ました。このような感じです:

```
require 'serverspec'

set :backend, :exec

# Ubuntu 12.04 only.
# Check whether `Rabbitmq` allows ssl poodle attack:

if os[:release] == '12.04' and os[:family] == 'ubuntu'
  describe file('/etc/rabbitmq/rabbitmq.config') do
    its(:content) { should match /ssl_allow_poodle_attack/ }
  end
end
```

* * *

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/477416500X/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/477416500X/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/514bjG3dt9L._SL160_.jpg" alt="Chef実践入門 ~コードによるインフラ構成の自動化 (WEB+DB PRESS plus)" /></a>
</div>

<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<p>
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/477416500X/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/477416500X/simsnes-22/ref=nosim/', 'Chef実践入門 ~コードによるインフラ構成の自動化 (WEB+DB PRESS plus)');" target="_blank" name="amazletlink">Chef実践入門 ~コードによるインフラ構成の自動化 (WEB+DB PRESS plus)</a>
</p>

<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 14.12.17
</div>
</div>

<div class="amazlet-detail">
      吉羽 龍太郎 安藤 祐介 伊藤 直也 菅井 祐太朗 並河 祐貴<br /> 技術評論社<br /> 売り上げランキング: 30,889
</div>

<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/477416500X/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/477416500X/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>

<div class="amazlet-footer" style="clear: left;">
</div>
</div>
