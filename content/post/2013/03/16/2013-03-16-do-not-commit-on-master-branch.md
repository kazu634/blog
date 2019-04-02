---
title: マスターブランチでのコミットを禁止するpre-commitスクリプト
author: kazu634
date: 2013-03-16
has_been_twittered:
  - yes
tmac_last_id:
  - 331192087183753216
categories:
  - git

---
Gitを使っていてマスターブランチでのコミットを禁止したい場合の pre-commit スクリプトのサンプルです:

<pre class="lang:default decode:true" title="${GIT_DIR}/.git/hooks/pre-commit">#!/bin/sh

# if the branch is master, then fail.

branch="$(git symbolic-ref HEAD 2&gt;/dev/null)" || \
       "$(git describe --contains --all HEAD)"

if [ "${branch##refs/heads/}" = "master" ]; then
  echo "Do not commit on the master branch!"
  exit 1
fi</pre>

git initを実行した際には、/usr/share/git-core/templates/hooks/ 配下から${GIT_DIR}/.git/hooksにコピーされるそうです。共通のスクリプトとして /usr/share/git-core/templates/hooks/ に格納してしまうのもありかもしれないと思いました。

## 参考

  * <a href="https://github.com/bleis-tift/Git-Hooks/blob/master/common.sh" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://github.com/bleis-tift/Git-Hooks/blob/master/common.sh', '参考にさせていただいたスクリプト');" target="_blank"><span style="line-height: 15px;">参考にさせていただいたスクリプト</span></a>
  * <a href="http://labs.gree.jp/blog/2011/03/2885/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://labs.gree.jp/blog/2011/03/2885/', '多人数開発で Git を使う場合の環境構築');" target="_blank">多人数開発で Git を使う場合の環境構築</a>
