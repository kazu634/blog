---
title: apt-mirrorを使ってネットワークインストール可能なレポジトリを作成する
author: kazu634
date: 2013-02-09
url: /2013/02/09/make_network-installable_repository_by_apt-mirror/
has_been_twittered:
  - yes
tmac_last_id:
  - 314310983340421120
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:3;s:6:"result";a:0:{}s:13:"tweet_counter";i:1;s:13:"tweet_log_ids";a:0:{}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - apt
  - インフラ

---
apt-mirrorを使用してネットワークインストール可能なレポジトリを作成しようとしたら、うまくいかずにハマったのでここにまとめておきます。

## 前提条件

Ubuntu Preciseのミラーレポジトリを作成します。レポジトリを構築するサーバがrepository.kazu634.lanで名前解決できることが前提です。

## 何がしたかったの？

例えば仮想マシン上に Ubuntu をインストールするとします。普通にインストールを行うと、jp.archive.ubuntu.org などのレポジトリにアクセスしに行くため、ネットワーク的な負荷がかかります。仮にこれがローカルネットワーク内部で完結すれば、ネットワーク的な負荷がかなり軽減することになります。後、インストールに必要となる時間も短縮出来ます。

Windowsでいうところの、WSUSサーバをイントラネット内部に設置するイメージですかねー

## どうすればレポジトリを作成できるの？

apt-mirrorを使います。

<pre class="lang:sh decode:true" title="aptitudeによるインストール方法">aptitude install apt-mirror</pre>

設定ファイルは /etc/apt/mirror.list です。debian-installの設定を追加する必要があります。私の設定はこのようになりました:

<pre class="lang:default decode:true" title="/etc/apt/mirror.list">############# config ##################
#
set base_path    /share/apt-mirror
#
# set mirror_path  $base_path/mirror
# set skel_path    $base_path/skel
# set var_path     $base_path/var
# set cleanscript $var_path/clean.sh
# set defaultarch  &lt;running host architecture&gt;
# set postmirror_script $var_path/postmirror.sh
# set run_postmirror 0
set nthreads     20
set _tilde 0
#
############# end config ##############

deb http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu precise-security main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu precise-proposed main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse

# debian installer here
deb http://archive.ubuntu.com/ubuntu precise main/debian-installer restricted/debian-installer

deb-src http://archive.ubuntu.com/ubuntu precise main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu precise-security main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu precise-updates main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu precise-proposed main restricted universe multiverse
deb-src http://archive.ubuntu.com/ubuntu precise-backports main restricted universe multiverse

clean http://archive.ubuntu.com/ubuntu</pre>

私の場合デフォルトのミラー作成先 (/var/spool/apt-mirror) から変更 (/share/apt-mirror)したかったため、以下のコマンドを実行しています。

<pre class="lang:sh decode:true" title="/var/spool/apt-mirror をコピー">sudo cp -pr /var/spool/apt-mirror/ /share/</pre>

## Nginxの設定

レポジトリを公開するためには、HTTPでインデックスを表示できなければいけません。私は以下の設定を実施しています:

<pre class="lang:default decode:true" title="/etc/nginx/sites-available/repository">server {
    listen   80;

    root /share/apt-mirror/mirror/archive.ubuntu.com;
    index index.html index.htm;

    server_name repository.kazu634.lan;

    access_log  /var/log/nginx/repository.kazu634.lan.access.log;
    error_log   /var/log/nginx/repository.kazu634.lan.error.log;

    autoindex on;
    gzip on;
}</pre>

autoindexをonにするのがポイントです。

## レポジトリの内容を定期的に更新する

以下の設定ファイルを更新します。コメントアウトを外して、cronの書式で好きな頻度で実行できるようにしてください。

<pre class="lang:default decode:true" title="/etc/cron.d/apt-mirror">#
# Regular cron jobs for the apt-mirror package
#
0 4	* * *	apt-mirror	/usr/bin/apt-mirror &gt; /var/spool/apt-mirror/var/cron.log</pre>

&nbsp;