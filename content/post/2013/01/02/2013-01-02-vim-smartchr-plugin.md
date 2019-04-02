---
title: 半角スペースを入力する手間を省く
author: kazu634
date: 2013-01-02
has_been_twittered:
  - yes
tmac_last_id:
  - 303816626850119680
categories:
  - vim

---
## はじめに

ただいま Ruby 勉強中です。 Chef などのデプロイ用のツールを活用するためには Ruby が読めないといけないと難しそうなので、勉強しているところです。

Rubyを勉強していて不便に思ったところは、ソースを綺麗にできないところでした。

Perlには<a href="http://perltidy.sourceforge.net/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://perltidy.sourceforge.net/', 'perltidy');">perltidy</a>というコマンドがあって、ソースファイルをキレイにしてくれます。キレイにしてくれるといっても、「=」の部分でアラインを整えてくれるとかそういった役割しか求めていないのですが。。。ところが Ruby の場合には、perltidy相当のことをするコマンドがないみたい。

ちょっと別な方法が無いかを調べてみました。

## smartchrプラグイン

Vimのsmartchrプラグインというのを使うと、例えば「=」を入力した時に自動的に両端に半角スペースを入力できるようでした。ということで、ちょっとインストールしてみます。

私は NeoBundle でプラグインを管理しているので、こんな感じで .vimrc に追記しました:

<pre>NeoBundle 'kana/vim-smartchr'</pre>

こうしておいて、「:NeoBundleInstall」しました。

設定はこんなかんじです:

<pre>inoremap  = smartchr#loop(' = ', ' == ', ' === ', "=")
inoremap  + smartchr#loop(' + ', '++')
inoremap  - smartchr#loop(' - ', '--')
inoremap  / smartchr#loop(' / ', '// ', '/')
inoremap  * smartchr#loop(' * ', '*')
inoremap  &lt; smartchr#loop(' &lt; ', ' &lt;&lt; ', '&lt;')
inoremap  &gt; smartchr#loop(' &gt; ', ' &gt;&gt; ', '&gt;')</pre>
