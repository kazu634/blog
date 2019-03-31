---
title: Chefで事前応答ファイルを準備してパッケージをインストールする
author: kazu634
date: 2013-05-06
url: /2013/05/06/chef_package_installation_with_preseedings/
has_been_twittered:
  - yes
tmac_last_id:
  - 368535674695479296
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.0";s:14:"tweet_template";b:0;s:6:"status";i:3;s:6:"result";a:0:{}s:13:"tweet_counter";i:1;s:13:"tweet_log_ids";a:0:{}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - chef
  - インフラ

---
普段手動でパッケージをインストールする際に対話的にパスワードなどを聞かれることがあります。例えばmysql-serverをインストールする場合には、次のような画面が表示されます:

<a href="http://www.flickr.com/photos/42332031@N02/8711350975/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/8711350975/', '');" title="1. Default (ssh) by kazu634, on Flickr"><img class="aligncenter" alt="1. Default (ssh)" src="http://farm9.staticflickr.com/8273/8711350975_64d7bcf3e2.jpg" width="453" height="500" /></a>

こうした対話的な問い合わせに対して、事前に応答する内容を記述したファイルを用意することで対話的なインターフェースをバイパスできます。今回は Debian/Ubuntu 系の場合に事前応答ファイルを準備してインストールする方法をまとめます。

<!--more-->

## 検証した環境

Ubuntu 12.04で検証しています。

## レシピの書き方

<a href="http://docs.opscode.com/resource_package.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://docs.opscode.com/resource_package.html', 'Chefのマニュアル');" title="Chefのマニュアル"  target="_blank">Chefのマニュアル</a>には次のように記載されています:

> Use of a response\_file is only supported on Debian and Ubuntu at this time. Providers need to be written to support the use of a response\_file, which contains debconf answers to questions normally asked by the package manager on installation. Put the file in files/default of the cookbook where the package is specified and Chef will use the cookbook_file resource to retrieve it.
> 
> To install a package with a response_file:
> 
> <pre class="lang:ruby decode:true" title="Chef sample">package "sun-java6-jdk" do
  response_file "java.seed"
end</pre>

現時点では Debian/Ubuntu 系の preseeding しかサポートしておらず、また、response_file で指定すればよさそうです。

## response_fileの内容

response_fileの内容はここを参考にすると幸せになれます:

  * <a href="http://www.debian.org/releases/stable/s390/apbs03.html.ja" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.debian.org/releases/stable/s390/apbs03.html.ja', 'B.3. 事前設定ファイルの作成');" target="_blank">B.3. 事前設定ファイルの作成</a>
  * <a href="http://ebisawa.org/archives/197" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://ebisawa.org/archives/197', 'Debian/Ubuntu 系 OS でパッケージを全自動インストールする方法');" target="_blank">Debian/Ubuntu 系 OS でパッケージを全自動インストールする方法</a>

mysql-serverのインストール時に root のパスワードを指定しますが、その際に「123qweASD」を指定した場合のresponse_fileの内容は次のようになります:

<pre class="lang:default decode:true" title="mysql.seed">mysql-server-5.5 mysql-server/root_password_again password 123qweASD
mysql-server-5.5 mysql-server/root_password password 123qweASD</pre>

Ubuntuデフォルトでインストールされるmysqlのバージョンが5.6になったら修正する必要が出てきそうですが、とりあえず上記の内容で mysql.seed という名前で保存をし、 files/default/ 配下に格納します。

## 実際にレシピを書いてみる

結果的に次のようになります:

<pre class="lang:default decode:true" title="mysql-server recipe sample">package "mysql-server" do
  action :install

  response_file "mysql.seed"
end</pre>

* * *

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px; text-align: left;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" alt="入門Chef Solo - Infrastructure as Code" src="https://images-na.ssl-images-amazon.com/images/I/31u6VLGX2kL._SL160_.jpg" /></a>
</div>
  
<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px; text-align: left;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/', '入門Chef Solo &#8211; Infrastructure as Code');" target="_blank" name="amazletlink">入門Chef Solo &#8211; Infrastructure as Code</a>&nbsp;</p> 
      
<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 13.05.06
</div>
</div>
    
<div class="amazlet-detail">
      伊藤直也 (2013-03-11)<br /> 売り上げランキング: 252
</div>
    
<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00BSPH158/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>
  
<div class="amazlet-footer" style="clear: left; text-align: left;">
</div>
</div>
