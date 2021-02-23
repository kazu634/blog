---
title: ドメインの残り有効期限を取得するシェルスクリプト
author: kazu634
date: 2013-01-14
has_been_twittered:
  - yes
tmac_last_id:
  - 303816623784083456
author:
  - kazu634
categories:
  - Programming
  - シェルスクリプト

---
とあるところで独自ドメインの更新忘れが起きていて、名前解決できていない状態になっていました。。。独自ドメインの更新忘れはかなり致命的な状況に陥ることに気づいたので、監視できる仕組みを構築せねばということで、調べて作成してみました。

## 前提条件

whoisコマンドが使用出来ることが前提です。debian系なら、「aptitude install whois」してください。また、「.com」しか対象にしていません。

## 作成したシェルスクリプト

作成したシェルスクリプトは<a href="https://gist.github.com/4527473" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://gist.github.com/4527473', 'Gist');" title="Gist"  target="_blank">Gist</a>でも公開しています。以下の通りです:

<pre class="lang:default decode:true" title="check_domain_expiration">#!/bin/bash

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

# Check the number of the arguments
if [ $# -ne 1 ]; then
  exit 1
fi

DOMAIN=$1

# Check the specified domain name
if [ ! ${DOMAIN##*.} == "com" ]; then

  echo "Specify the .com domain name."
  exit 1

fi

# Check whether the whois command exists or not
if [ ! -x ${WHOIS} ]; then

  echo "${WHOIS} command does not exist."
  exit 1

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

echo ${REMAIN_DAYS}

exit 0</pre>

## 参考にしたサイト

ここがとても参考になりました。dateコマンドって色々と使えるんですね。

  * <a href="http://d.hatena.ne.jp/tmatsuu/20070928/1190940248" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/tmatsuu/20070928/1190940248', 'Nagiosでドメイン失効を監視する');" target="_blank">Nagiosでドメイン失効を監視する</a>

このシェルスクリプトを Nagios に組み込んであげれば、監視の仕組み構築が完了ということになるかな。
