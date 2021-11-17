---
title: お仕事で覚えたシェルスクリプトの使い方
date: 2013-07-20T15:04:05Z
author: kazu634
categories:
  - インフラ
tags:
  - ShellScript
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
