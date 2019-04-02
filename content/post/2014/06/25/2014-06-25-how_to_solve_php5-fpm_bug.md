---
title: Ubuntu Precise で Php5-fpm のソケットファイルのオーナー・グループが気づかぬうちに変わってた
author: kazu634
date: 2014-06-25
geo_latitude:
  - 38.306223
geo_longitude:
  - 141.022694
geo_public:
  - 1
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1862;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1862;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - wordpress

---
気づいたら`WordPress`サイトが`Internal Server Error`を出すようになっていたので、トラブルシュートしてました。結論を言うと、Ubuntuで提供している`php5-fpm`パッケージのセキュリティアップデートを適用すると、問答無用でオーナー・グループが`root:root`になってしまうようです。

## 事象

`WordPress`サイトが`Internal Server Error`を出してアクセスできなくなった。

## 直接的な原因

以下のログが`nginx`のログに出力されていることから、`php5-fpm`のソケットファイルにアクセスできなかったことが原因と思われる。

<pre class="lang:default decode:true " title="ログファイル">[crit] 1131#0: *304 connect() to unix:/var/run/php5-fpm.sock failed (13: Permission denied) while connecting to upstream,  client: xxx.xxx.xxx.xxx,  server: _,  request: "GET / HTTP/1.0",  upstream: "fastcgi://unix:/var/run/php5-fpm.sock:"</pre>

実際に`/var/run/php5-fpm.sock`のオーナー・グループを確認すると、`root:root`でありパーミッションが`660`であった(`nginx`は`www-data`で`php5-fpm`にアクセスする)

## 真因

`php5-fpm`のセキュリティアップデート(= `php5-fpm:amd64 5.3.10-1ubuntu3.12`) を適用すると、ソケットファイルのオーナー・グループのデフォルト設定値が`root:root`に変更となった。詳細は以下を参考:

  * <a href="http://www.ubuntuupdates.org/package/core/trusty/universe/updates/php5-fpm" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.ubuntuupdates.org/package/core/trusty/universe/updates/php5-fpm', 'UbuntuUpdates &#8211; Package &#8220;php5-fpm&#8221; (trusty 14.04)');">UbuntuUpdates &#8211; Package &#8220;php5-fpm&#8221; (trusty 14.04)</a>
  * <a href="https://bugs.launchpad.net/ubuntu/+source/php5/+bug/1307027" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://bugs.launchpad.net/ubuntu/+source/php5/+bug/1307027', 'Bug #1307027 “php5-fpm: Possible privilege escalation due to ins…” : Bugs : “php5” package : Ubuntu');">Bug #1307027 “php5-fpm: Possible privilege escalation due to ins…” : Bugs : “php5” package : Ubuntu</a>

## 対応策

`/etc/php5/fpm/pool.d/www.conf`でソケットファイルのユーザ・グループ・パーミッションを明示的に指定する (= 我々ユーザからは`listen.owner`, `listen.group`, `listen.mode`のデフォルト値が変更されたように見えるのが今回のバグのようだ):

<pre class="lang:default decode:true " title="www.conf">; Set permissions for unix socket, if one is used. In Linux, read/write
; permissions must be set in order to allow connections from a web server. Many
; BSD-derived systems allow connections regardless of permissions.
; Default Values: user and group are set as the running user
;                 mode is set to 0666
listen.owner = www-data
listen.group = www-data
listen.mode = 0660</pre>
