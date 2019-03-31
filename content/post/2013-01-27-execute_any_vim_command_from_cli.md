---
title: Vimで任意のコマンドを実行して終了する方法
author: kazu634
date: 2013-01-27
url: /2013/01/27/execute_any_vim_command_from_cli/
has_been_twittered:
  - yes
tmac_last_id:
  - 307807252444758016
categories:
  - vim

---
CLIからVimを起動して、任意のコマンドを実行する方法がないのかと探していたのですが、どうやらできることに気づきました。こんな感じで実行すればいいみたい:

<pre class="lang:sh decode:true">vim -u ~/.vimrc -c 'NeoBundleInstall' -c 'qall!'</pre>

-uでロードする設定ファイルを指定する。-cで実行するVimのコマンドを指定する。複数指定すると、順番に実行してくれるみたいです。

参考にさせていただいたのはこちら:

  * <a href="http://d.hatena.ne.jp/osyo-manga/20130124/1359026154" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/osyo-manga/20130124/1359026154', '[vim]quickrun.vim で Vim script を非同期で実行');" target="_blank">[vim]quickrun.vim で Vim script を非同期で実行</a>
  * <a href="http://d.hatena.ne.jp/BigFatCat/20080622/1214154725" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/BigFatCat/20080622/1214154725', '[vim] vim の起動オプション(コマンドライン引数)');" target="_blank">[vim] vim の起動オプション(コマンドライン引数)</a>