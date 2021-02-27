---
title: Nagiosでドメイン有効期限を監視する
author: kazu634
date: 2013-01-27
has_been_twittered:
  - yes
tmac_last_id:
  - 307653283424636929
author:
  - kazu634
categories:
  - Labs
  - Infra
  - Monitoring
tags:
  - nagios
---
「<a href="http://blog.kazu634.com/2013/01/14/check_domain_expiration/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://blog.kazu634.com/2013/01/14/check_domain_expiration/', 'ドメインの残り有効期限を取得するシェルスクリプト');" title="ドメインの残り有効期限を取得するシェルスクリプト"  target="_blank">ドメインの残り有効期限を取得するシェルスクリプト</a>」で紹介したスクリプトを Nagios から使用できるようにしてみました。

## これは何をするもの？

Nagios からドメインの有効期限を監視します。今のところ .com にしか対応していません。作業完了後のイメージはこんな感じです:

<a href="http://www.flickr.com/photos/42332031@N02/8397684471/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/8397684471/', '');" title="Nagios Core by kazu634, on Flickr"><img class="aligncenter" src="http://farm9.staticflickr.com/8506/8397684471_e5f82ba38f.jpg" alt="Nagios Core" width="500" height="76" /></a>

<!--more-->

## Nagiosプラグインの仕様

<a href="http://heartbeats.jp/hbblog/2009/10/nagios-1.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://heartbeats.jp/hbblog/2009/10/nagios-1.html', 'ここ');" target="_blank">ここ</a>でNagiosプラグインの仕様がまとめられています。簡単にまとめると次のようになります:

  * リターンコード 0: OK
  * リターンコード 1: Warning
  * リターンコード 2: Critical
  * リターンコード 3: Unknown
  * 最低1行は標準出力に何か出力すること

## スクリプト

「<a href="http://blog.kazu634.com/2013/01/14/check_domain_expiration/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://blog.kazu634.com/2013/01/14/check_domain_expiration/', 'ドメインの残り有効期限を取得するシェルスクリプト');" title="ドメインの残り有効期限を取得するシェルスクリプト"  target="_blank">ドメインの残り有効期限を取得するシェルスクリプト</a>」で作成したスクリプトを修正して、適切なリターンコードを返すように修正しました:

<pre class="height-set:true height:250 wrap:true lang:sh decode:true">#!/bin/bash

########################################
# Name: Kazuhiro MUSASHI
#
# about:
#
# Usage:
#
# Author:
# Date:
########################################

set -e

# Constants
WHOIS='/usr/bin/whois'

# Thresholds
WARNINGS=60
CRITICAL=30

# Return Codes
OK=0
WARN=1
CRIT=2
UNKNOWN=3

# Check the number of the arguments
if [ $# -ne 1 ]; then
  exit ${UNKNOWN}
fi

DOMAIN=$1

# Check the specified domain name
if [ ! ${DOMAIN##*.} == "com" ]; then

  echo "Specify the .com domain name."
  exit ${UNKNOWN}

fi

# Check whether the whois command exists or not
if [ ! -x ${WHOIS} ]; then

  echo "${WHOIS} command does not exist."
  exit ${UNKNOWN}

fi

# Execute the whois command
EXPIRE=`${WHOIS} ${DOMAIN} | grep Expiration | tail -n 1 | cut -f 3 -d " "`

# Convert the expiration date into seconds
EXPIRE_SECS=`date +%s --date=${EXPIRE}`

# Acquire the now seconds
CURRENTDATE_SEC=`date +%s`

# Calculate the remaining days
((DIFF_SEC=EXPIRE_SECS-CURRENTDATE_SEC))

REMAIN_DAYS=$((DIFF_SEC/86400))

# OK case
if [ ${REMAIN_DAYS} -ge ${WARNINGS} ]; then
  echo "The domain will be expired in ${REMAIN_DAYS} days."
  exit ${OK}

# Warning case
elif [ ${REMAIN_DAYS} -ge ${CRITICAL} ]; then
  echo "The domain will be expired in ${REMAIN_DAYS} days."
  exit ${WARN}

# Critical case
elif [ ${REMAIN_DAYS} -lt ${CRITICAL} ]; then
  echo "The domain will be expired in ${REMAIN_DAYS} days."
  exit ${CRIT}
fi

echo "The script should not end at this point."
exit ${UNKNOWN}</pre>

私は作成したスクリプトを /usr/loca/bin/ 配下に配置しました。

## commnds.cfgの編集

Nagiosのcommands.cfgに以下の行を追加します:

<pre class="width-set:true height:250 wrap:true  lang:diff decode:true">+# 'check_domain' command definition	
+define command{
+    command_name    check_domain
+    command_line    /usr/local/bin/check_domain $ARG1$
+    }</pre>

## 監視サービスの追加

監視設定を記述している設定ファイルに例えば以下の行を追加します:

<pre class="width-set:true height:250 wrap:true  lang:diff decode:true">+define service{
+        use                             generic-service
+        host_name                       sakura-vps
+        service_description             domain
+        check_command                   check_domain!kazu634.com
+        check_interval                  1440
+    }</pre>

後は「sudo service nagios reload」などのコマンドを実行し、Nagios設定ファイルをリロードしてください。

## 参考

  * <a href="http://junrei.dip.jp/wordpress/nagios/nagios%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E9%96%8B%E7%99%BA%E3%82%AC%E3%82%A4%E3%83%89%E3%83%A9%E3%82%A4%E3%83%B3/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://junrei.dip.jp/wordpress/nagios/nagios%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3%E9%96%8B%E7%99%BA%E3%82%AC%E3%82%A4%E3%83%89%E3%83%A9%E3%82%A4%E3%83%B3/', 'Nagiosプラグイン開発ガイドライン');" target="_blank">Nagiosプラグイン開発ガイドライン</a>
  * <a href="http://heartbeats.jp/hbblog/2009/10/nagios-1.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://heartbeats.jp/hbblog/2009/10/nagios-1.html', 'Nagiosプラグイン自作方法の紹介');" target="_blank">Nagiosプラグイン自作方法の紹介</a>

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/4774145823/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/4774145823/simsnes-22/ref=nosim/', '');" name="amazletlink"  target="_blank"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/51H7Wq1BVDL._SL160_.jpg" alt="Nagios統合監視[実践]リファレンス (Software Design ｐlus)" /></a>
</div>

<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/4774145823/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/4774145823/simsnes-22/ref=nosim/', 'Nagios統合監視[実践]リファレンス (Software Design ｐlus)');" name="amazletlink"  target="_blank">Nagios統合監視[実践]リファレンス (Software Design ｐlus)</a></p>

<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 13.01.27
</div>
</div>

<div class="amazlet-detail">
      株式会社エクストランス 佐藤 省吾 Team-Nagios<br /> 技術評論社<br /> 売り上げランキング: 53,459
</div>

<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/4774145823/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/4774145823/simsnes-22/ref=nosim/', '');" name="amazletlink"  target="_blank"></a>Amazon.co.jp で詳細を見る
</div>
</div>
</div>

<div class="amazlet-footer" style="clear: left;">
</div>
</div>
