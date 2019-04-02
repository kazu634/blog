---
title: Sinatraを初めて使ってみた
author: kazu634
date: 2013-11-10
geo_latitude:
  - 38.306436
geo_longitude:
  - 141.023255
geo_public:
  - 1
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1856;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1856;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - ruby

---
<div class="entry-content">
<p>
<a href="http://www.sinatrarb.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.sinatrarb.com/', '');" title="Sinatra by kazu634, on Flickr"><img class="aligncenter" src="http://farm4.staticflickr.com/3800/10798811434_dd7e84970e.jpg" alt="Sinatra" width="500" height="345" /></a>
</p>
  
<p>
    個人的なプロジェクトで使うために、 Ruby 製の Web アプリケーションフレームワーク Sinatra を初めて使ってみました。これ、簡単に使えてすごいですね。
</p>
  
<h2>
    Gemfile
</h2>
  
<p>
<code>Gemfile</code>には次のように書きます:
</p>
  
<div class="highlight">
<pre><code class="text">source 'https://rubygems.org'

gem "sinatra"
gem "thin"
</code></pre>
</div>
  
<ul>
<li>
      sinatra: Sinatra 本体です
</li>
<li>
      thin: Ruby 用のWebサーバです
</li>
<li>
      shotgun: Sinatra のファイルを更新すると、自動的にWebサーバをリロードしてくれるライブラリ
</li>
</ul>
  
<p>
    保存したら、<code>bundle install</code>します。私は<code>bundle install --path vendor/bundle</code>としています。
</p>
  
<h2>
    server.rb
</h2>
  
<p>
    名前は任意なのですが、今回は<code>server.rb</code>としました。とりあえずこんな感じで書いてみました:
</p>
  
<pre class="lang:ruby decode:true " title="server.rb">#!/usr/bin/env ruby

require "rubygems"
require "bundler/setup"

require "sinatra"

get '/' do
  "Hello, Game."
end
</pre>
  
<h2>
    実行してみる
</h2>
  
<p>
    それでは実行してみます。実行するには<code>ruby server.rb</code>をします。こんな感じです:
</p>
  
<pre class="lang:sh decode:true ">% ruby server.rb
== Sinatra/1.4.4 has taken the stage on 4567 for development with backup from Thin
Thin web server (v1.6.1 codename Death Proof)
Maximum connections set to 1024
Listening on localhost:4567, CTRL+C to stop</pre>
  
<p>
    ブラウザでアクセスしてみます:
</p>
  
<p>
<a href="http://www.flickr.com/photos/42332031@N02/10778040563/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/10778040563/', '');" title="localhost:4567 by kazu634, on Flickr"><img src="http://farm6.staticflickr.com/5515/10778040563_b0c76fd135_z.jpg" alt="localhost:4567" width="640" height="152" /></a>
</p>
  
<h2>
    最後に
</h2>
  
<p>
    get だけでなく、post などにも簡単に対応できるので、すごい簡単に使えて驚きました。個人的なプロジェクトで活用してみようと思います。参考にした/これから参考にするサイトはここらへんです:
</p>
  
<ul>
<li>
<a href="http://d.hatena.ne.jp/meganii/20120229/1330467948" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/meganii/20120229/1330467948', 'SinatraでTwitterBootstrapを使ってTODOアプリを作ってみよう &#8211; ギークを夢見るじょーぶん男子');">SinatraでTwitterBootstrapを使ってTODOアプリを作ってみよう &#8211; ギークを夢見るじょーぶん男子</a>
</li>
<li>
<a href="http://qiita.com/futoase/items/9c76b2a50ba31f866f16" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://qiita.com/futoase/items/9c76b2a50ba31f866f16', 'Ruby &#8211; 既存のテーブル用のマイグレーションファイルをSequelで作成する &#8211; Qiita');">Ruby &#8211; 既存のテーブル用のマイグレーションファイルをSequelで作成する &#8211; Qiita</a>
</li>
<li>
<a href="http://kozo002.blogspot.jp/2012/04/rubybundler-sinatra.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://kozo002.blogspot.jp/2012/04/rubybundler-sinatra.html', '[ruby]最初に知っておけば良かったbundlerの使い方 sinatra編 | Into my web');">[ruby]最初に知っておけば良かったbundlerの使い方 sinatra編 | Into my web</a>
</li>
<li>
<a href="http://d.hatena.ne.jp/satrex/20120304/1330831922" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/satrex/20120304/1330831922', 'sinatra+shotgunの使い方（解答編） &#8211; 電気羊の執務室');">sinatra+shotgunの使い方（解答編） &#8211; 電気羊の執務室</a>
</li>
<li>
<a href="http://qiita.com/rhzk/items/606c1d58afcfb06f14c4" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://qiita.com/rhzk/items/606c1d58afcfb06f14c4', 'sinatraで一からwebアプリケーションを構築する &#8211; Qiita');">sinatraで一からwebアプリケーションを構築する &#8211; Qiita</a>
</li>
</ul>
  
<hr />
  
<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B006C3HPS4/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B006C3HPS4/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/51P7j5N0GgL._SL160_.jpg" alt="Sinatra: Up and Running" /></a>
</div>
    
<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<p>
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B006C3HPS4/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B006C3HPS4/simsnes-22/ref=nosim/', 'Sinatra: Up and Running');" target="_blank" name="amazletlink">Sinatra: Up and Running</a>
</p>
        
<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
          posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 13.11.10
</div>
</div>
      
<div class="amazlet-detail">
        O’Reilly Media (2011-11-21)
</div>
      
<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B006C3HPS4/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B006C3HPS4/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>
    
<div class="amazlet-footer" style="clear: left;">
</div>
</div>
</div>
