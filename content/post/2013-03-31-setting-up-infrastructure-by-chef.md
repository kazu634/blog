---
title: Chefを用いたインフラの自動構築
author: kazu634
date: 2013-03-31
excerpt: Chefをインストールし、レシピを作成できるようになるまでを扱っています。
url: /2013/03/31/setting-up-infrastructure-by-chef/
has_been_twittered:
  - yes
tmac_last_id:
  - 358571152655921155
categories:
  - chef
  - インフラ

---
今年の夏にかけて Windows サーバ 200 台ぐらいと Solaris サーバ 40 台ぐらいのセットアップを控えています。「OSの構築などはスクリプトで自動化！」という方針でこれまで準備を重ねてきているのですが、スクリプトから読み込む設定ファイルのバージョン管理が。。。というありがちな状態です。これなら手動でやったほうが…といういけてない状態だったりします。

前書きはこのへんにして、各所でインフラ自動構築を行う Chef が流行っているので、使ってみました。お仕事でスクリプトを書いて実施していることがかなり簡単に実現できて感激しています。

## 何がそんなにいいわけさ

特にChefの概念で言う「冪等性」が素晴らしい。OSやその上で導入するパッケージの設定項目が同一であることを監視できると言えばいいのでしょうか。何台も同じ設定のサーバを構築していると、手動作業ではミスがありえますが、自動化をすることで同一であること、あるべき姿から外れていないことが、簡単に担保できるようになります。<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/', '入門Chef Solo &#8211; Infrastructure as Code');" target="_blank" name="amazletlink">入門Chef Solo &#8211; Infrastructure as Code</a>には次のように記載されています:

> 「ソフトウェアのインストールやサーバーの設定変更を自動化する」というのがChefの機能のわかりやすい説明ですが、より本質的に捉えるならそれは「サーバーの状態を管理して、それをあるべき状態に収束させるフレームワーク」ということです。

これって、すごいことです！！！

## 前提条件

検証した環境は Ubuntu 12.04 です。Chefのレシピを作成する環境を作るまでを扱います。

<!--more-->

## 使ってみる！

こんな順番で進んでいきます:

  1. Rubyのインストール
  2. knifeのインストール
  3. knife-soloのインストール

### Rubyのインストール

rbenvでRubyを自前で導入してみます。

<pre class="lang:sh decode:true" title="Ruby Installation">aptitude install libreadline-dev libssl-dev zlib1g-dev libssl1.0.0

git clone git://github.com/sstephenson/rbenv.git ~/.rbenv

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' &gt;&gt; ~/.bash_profile

echo 'eval "$(rbenv init -)"' &gt;&gt; ~/.bash_profile

exec $SHELL -l

rbenv install 1.9.3-p392

rbenv rehash

rbenv global 1.9.3-p392</pre>

### chefのインストール

次のコマンドを実行します:

<pre class="lang:sh decode:true" title="Chef installation">gem install chef

rbenv rehash</pre>

### knife-soloのインストール

次のコマンドを実行します:

<pre class="lang:sh decode:true" title="knife-solo installation">gem install knife-solo

rbenv rehash</pre>

以上です。

* * *

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" alt="入門Chef Solo - Infrastructure as Code" src="https://images-na.ssl-images-amazon.com/images/I/31u6VLGX2kL._SL160_.jpg" /></a>
</div>
  
<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<p>
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/', '入門Chef Solo &#8211; Infrastructure as Code');" target="_blank" name="amazletlink">入門Chef Solo &#8211; Infrastructure as Code</a>
</p>
      
<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 13.03.19
</div>
</div>
    
<div class="amazlet-detail">
      伊藤直也 (2013-03-11)<br /> 売り上げランキング: 15
</div>
    
<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>
  
<div class="amazlet-footer" style="clear: left;">
</div>
</div>
