---
title: Packerを使ってVirtual Boxのイメージを作成する
author: kazu634
date: 2014-10-29
tmac_last_id:
  - 530867855634747392
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1892;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:1;s:11:"tweet_times";i:1;s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";s:116:"ブログに新しい記事を投稿したよ: Packerを使ってVirtual Boxのイメージを作成する - [link] ";s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:3;s:13:"tweet_log_ids";a:2:{i:0;i:1889;i:1;i:1892;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - packer
  - インフラ

---
<a href="https://www.flickr.com/photos/42332031@N02/15635729076" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15635729076', '');" title="packer by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm8.staticflickr.com/7582/15635729076_06a87c8eaa.jpg" alt="packer" width="500" height="298" /></a>

Packerを利用してVirtual Boxのイメージを作成したので、その方法をメモ書きしておきます。環境はMacのYosemiteです。

## 前提条件

これらをインストールしておいてください。

  * Homebrew
  * Virtual Box

## Packerのインストール方法

以下のコマンドを実行します:

<pre class="lang:sh decode:true " title="How to install packer using Homebrew">brew tap homebrew/binary
brew install packer</pre>

## Packerを利用してVirtual Boxのイメージを作成する

時雨堂さんが提供しているconfigを利用させていただきます。とりあえず以下のコマンドを実行します:

<pre class="lang:sh decode:true" title="How to make Virtual Box Image, using packer">git clone git@github.com:shiguredo/packer-templates.git</pre>

その上でこんなパッチをあてました:

    diff --git a/ubuntu-12.04/http/preseed.cfg b/ubuntu-12.04/http/preseed.cfg
    index 6816597..a6d0044 100644
    --- a/ubuntu-12.04/http/preseed.cfg
    +++ b/ubuntu-12.04/http/preseed.cfg
    @@ -1,3 +1,4 @@
    +d-i mirror/country string JP
     choose-mirror-bin mirror/http/proxy string
     d-i base-installer/kernel/override-image string linux-server
     d-i clock-setup/utc boolean true
    diff --git a/ubuntu-12.04/template.json b/ubuntu-12.04/template.json
    index cd088e7..f7d783d 100644
    --- a/ubuntu-12.04/template.json
    +++ b/ubuntu-12.04/template.json
    @@ -9,16 +9,14 @@
                 "scripts/base.sh",
                 "scripts/vagrant.sh",
                 "scripts/virtualbox.sh",
    -            "scripts/cleanup.sh",
    -            "scripts/zerodisk.sh"
    +            "scripts/cleanup.sh"
               ]
             },
             "vmware-iso": {
               "scripts": [
                 "scripts/base.sh",
                 "scripts/vagrant.sh",
    -            "scripts/cleanup.sh",
    -            "scripts/zerodisk.sh"
    +            "scripts/cleanup.sh"
               ]
             }
           }
    

`preseed.cfg`の方は、アメリカにあるレポジトリにアクセスしにいっていたため、日本にあるレポジトリにアクセスするようにするため変更しました。`template.json`の方は、`zerodisk.sh`を実行するとタイムアウトエラーになるため、実行しないようにしています。

その上で以下のコマンドを実行して、作成完了です！

    packer build -only=virtualbox-iso template.json
    

* * *

## 参考

  * <a href="http://qiita.com/seizans/items/ef220c98fde6dbfbee32" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://qiita.com/seizans/items/ef220c98fde6dbfbee32', 'packer &#8211; Ubuntu 14.04 を Vagrant に準備する &#8211; Qiita');">packer &#8211; Ubuntu 14.04 を Vagrant に準備する &#8211; Qiita</a>
  * <a href="https://github.com/shiguredo/packer-templates" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://github.com/shiguredo/packer-templates', 'shiguredo/packer-templates');">shiguredo/packer-templates</a>
