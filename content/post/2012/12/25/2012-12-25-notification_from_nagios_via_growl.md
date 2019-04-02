---
title: Nagiosからの通知を Growl 経由で受け取る
author: kazu634
date: 2012-12-25
has_been_twittered:
  - yes
tmac_last_id:
  - 303816632113983489
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:3;s:6:"result";a:0:{}s:13:"tweet_counter";i:1;s:13:"tweet_log_ids";a:0:{}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - Mac
  - nagios
  - tools

---
ESXiサーバを自宅内に設置していて、ゲストOSの一つに Nagios を導入しています。 Nagios 経由のアラームは Twitter に飛ばすようにしているのですが、頻繁に起動・停止を繰り返すようなゲスト OS に関しては Twitter に飛ばされると邪魔なことに気づきました。

そこで Growl に飛ばすこととしました。

## 環境

構成はこんなかんじです:

  * MacBookPro: OS X 10.6.8
  * Nagios: Ubuntu 12.04
  * Guest1: Windows 7
  * Guest2: Ubuntu 12.04

ネットワーク図はこんな感じです:

<a href="http://www.flickr.com/photos/42332031@N02/8306909380/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/8306909380/', '');" title="Network by kazu634, on Flickr"><img class="aligncenter" src="http://farm9.staticflickr.com/8493/8306909380_04d18d89ab.jpg" alt="Network" width="500" height="251" /></a>

<!--more-->

## やりたいこと

NagiosがGuest1,Guest2を監視した結果の通知をMacBookProで受け取りたい！Growlで！

## MacBookPro側

MacBookPro側では Growl をインストールします。10.6.8では App Store からはダウンロードできないようなので、ホームページから直接ダウンロードします。

まずはトップページにアクセスして、丸で囲んだ部分をクリックします:

<a href="http://www.flickr.com/photos/42332031@N02/8305744099/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/8305744099/', '');" title="growl_top by kazu634, on Flickr"><img class="aligncenter" src="http://farm9.staticflickr.com/8499/8305744099_81ce7a99ca.jpg" alt="growl_top" width="500" height="440" /></a>

表示されたページの丸で囲んだ部分をクリックしてダウンロードします:

<a href="http://www.flickr.com/photos/42332031@N02/8305747491/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/8305747491/', '');" title="growl_downloads by kazu634, on Flickr"><img class="aligncenter" src="http://farm9.staticflickr.com/8354/8305747491_315753669b.jpg" alt="growl_downloads" width="458" height="500" /></a>

後はインストーラーをキックするだけ！

## Nagios側

Nagios側では色々とやることがあります。

  1. Rubyのインストール
  2. Ruby-growlのインストール
  3. Nagiosの設定

### Rubyのインストール

Rubyがインストールされていなかったので、インストールします:

<pre>$ sudo aptitude install ruby
$ sudo aptitude install rubygems</pre>

### Ruby-growlのインストール

<a href="https://rubygems.org/gems/ruby-growl" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://rubygems.org/gems/ruby-growl', 'RubyからGrowlに通知するためのライブラリ');">RubyからGrowlに通知するためのライブラリ</a>をインストールします:

<pre>$ sudo gem install ruby-growl -v 3.0</pre>

Ubuntu 12.04で標準でインストールされる Ruby は 1.8 系みたいなので、バージョン指定でインストールします。

### Nagiosの設定

Nagiosの設定は、次の二つを指定します:

#### コマンドの定義

commands.cfgを編集します:
  
[crayon]
  
+### Growl ###

+define command{
  
+ command_name host-notify-by-growl
  
+ command_line /usr/local/bin/growl -h 192.168.3.7 -s -t &#8220;Nagios Notification&#8221; -m &#8220;$HOSTALIAS$ is $HOSTSTATE$. $HO
  
+ }
  
+
  
+define command{
  
+ command_name notify-by-growl
  
+ command_line /usr/local/bin/growl -h 192.168.3.7 -s -t &#8220;Nagios Notification&#8221; -m &#8220;$SERVICEDESC$ @ $HOSTNAME$ is $
  
+ }
  
[/crayon]
  
Ruby-growlをインストールすると、growlコマンドも一緒にインストールされます。それを使用します。

#### コンタクトの定義

contacts.cfgを編集します:
  
[crayon]
  
@@ -35,7 +35,13 @@ define contact{
  
email nagios@localhost ; < <**\*\\*\* CHANGE THIS TO YOUR EMAIL ADDRESS \*\*\****
  
}

&#8211;
  
+define contact{
  
+ contact_name localadmin
  
+ use generic-contact
  
+ alias Local Host Admin
  
+ service\_notification\_commands notify-by-growl
  
+ host\_notification\_commands host-notify-by-growl
  
+ }

###############################################################################
  
###############################################################################
  
@@ -53,3 +59,9 @@ define contactgroup{
  
alias Nagios Administrators
  
members nagiosadmin
  
}
  
+
  
+define contactgroup{
  
+ contactgroup_name localadmins
  
+ alias Local Admins
  
+ members localadmin
  
+ }
  
[/crayon]
  
通知先にはとりあえず「localadmins」という名称をつけました。

## 動作確認

ホストをダウンさせると、Growlに通知が来ます:

&nbsp;

<a href="http://www.flickr.com/photos/42332031@N02/8305905275/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/8305905275/', '');" title="GrowlHelperApp by kazu634, on Flickr"><img class="aligncenter" src="http://farm9.staticflickr.com/8084/8305905275_40398e6e29.jpg" alt="GrowlHelperApp" width="310" height="103" /></a>
