---
title: Chef Clientの12.0.0で後方互換性が失われていたようだ (12.0.0-1で修正済み)
author: kazu634
date: 2014-12-09
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:5553;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:5553;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
tmac_last_id:
  - 559360310189236224
categories:
  - chef

---
<a href="https://www.flickr.com/photos/juldavs/14974515901" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/juldavs/14974515901', '');" title="Chef Danbo by Júlia Vazquez, on Flickr"><img class="aligncenter" src="https://farm4.staticflickr.com/3916/14974515901_f4d3df901a.jpg" alt="Chef Danbo" width="500" height="322" /></a>
  
Chefを使ってノードの構築を実施していたら、なぜか``NoMethodError: undefined method `path' for Chef::Resource::Execute``というエラーが…なぜ起きているのかを調べていくと、Chef Clientのバージョンアップによって、後方互換性が失われたのが原因と判明。まとめると:

## 事象

``NoMethodError: undefined method `path' for Chef::Resource::Execute``が表示され、Chefによるノード構築が実施できない。

## 原因

Chef Clientの最新バージョンで後方互換性が失われるようなバグが混入したため

## 対策

対策を施した Chef Client 12.0.0-1 をインストールする。knife solo でバージョン指定するには、以下のように指定すればいいみたい:

<pre class="lang:sh decode:true ">bundle ex knife solo bootstrap ユーザー名@ホスト名 --bootstrap-version 12.0.0-1</pre>

## 参考

  * <a href="https://github.com/opscode/chef/issues/2545" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://github.com/opscode/chef/issues/2545', 'NoMethodError: undefined method `path&#8217; for Chef::Resource::Execute · Issue #2545 · opscode/chef');">NoMethodError: undefined method `path&#8217; for Chef::Resource::Execute · Issue #2545 · opscode/chef</a>
  * <a href="http://blog.yucchiy.com/2014/10/28/chef-solo-mysql/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://blog.yucchiy.com/2014/10/28/chef-solo-mysql/', 'ChefのMySQLクックブックでNoMethodError: undefined method `sensitive&apos; for Chef::Resource::Executeの対処 | Yucchiy&apos;s blog');">ChefのMySQLクックブックでNoMethodError: undefined method `sensitive&apos; for Chef::Resource::Executeの対処 | Yucchiy&apos;s blog</a>
