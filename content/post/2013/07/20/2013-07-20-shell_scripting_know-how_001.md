---
title: お仕事で覚えたシェルスクリプトの使い方
author: kazu634
date: 2013-07-20
geo_latitude:
  - 38.306231
geo_longitude:
  - 141.022696
geo_public:
  - 1
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1851;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1851;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - シェルスクリプト

---
## sedコマンドでA行目からB行目を切り出す

以下のように実行してあげるよ:

`sed -n 'A,Bp' /path/to/file`

実行例はこんな感じです:

```
kazu634@macbook% cat -n /etc/hosts
1  ##
2  # Host Database
3  #
4  # localhost is used to configure the loopback interface
5  # when the system is booting.  Do not change this entry.
6  ##
7  127.0.0.1   localhost
8    255.255.255.255 broadcasthost
9    ::1             localhost
10    fe80::1%lo0 localhost
11
12    59.106.177.26   sakura-vps
13    133.242.151.82  sakura-vps2
14
15    192.168.3.4     esxi
16    192.168.3.5     freenas
17    192.168.3.100   vyatta

kazu634@macbook% sed -n '1,8p' /etc/hosts
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
127.0.0.1 localhost
255.255.255.255   broadcasthost
```

## sedコマンドでA行目から最終行までを切り出す

以下のように実行してあげるよ:

`sed -n 'A,$p' /path/to/file`

実行例はこんな感じです:

```
kazu634@macbook% sed -n '7,$p' /etc/hosts
127.0.0.1 localhost
255.255.255.255 broadcasthost
::1 localhost
fe80::1%lo0 localhost

59.106.177.26 sakura-vps
133.242.151.82 sakura-vps2

192.168.3.4 esxi
192.168.3.5 freenas
192.168.3.100 vyatta
```

## 空ファイルの削除

以下のように実行してあげるよ:

`find /path/to/root-dir -type f -empty | xargs rm`

## 空ディレクトリの削除

以下のように実行してあげるよ:

`find /path/to/root-dir -type d | xargs rmdir`

もしかすると`sort`を間に挟めるともっといいのかも。

## grepコマンドでPerl互換の正規表現をつかう

-P オプションを指定する！

## grepコマンドでパターンにマッチするファイル名のみを表示する

-l オプションを指定する！

## sedで空行を削除

`sed '/^$/d' /path/to/file`

実行例はこんな感じです:

```
kazu634@macbook% sed '/^$/d' /etc/hosts
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting. Do not change this entry.
##
127.0.0.1 localhost
255.255.255.255 broadcasthost
::1 localhost
fe80::1%lo0 localhost
59.106.177.26 sakura-vps
133.242.151.82 sakura-vps2
192.168.3.4 esxi
192.168.3.5 freenas
192.168.3.100 vyatta
```
