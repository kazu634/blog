---
title: Google Calendarと連携して最近更新した予定を表示するWebサービス作ったよ
author: kazu634
date: 2014-06-07
geo_latitude:
  - 38.306186
geo_longitude:
  - 141.022643
geo_public:
  - 1
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1871;}'
wordtwit_post_info:
  - 'O:8:"stdClass":14:{s:6:"manual";b:1;s:11:"tweet_times";i:1;s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";s:142:"ブログに新しい記事を投稿したよ: Google Calendarと連携して最近更新した予定を表示するWebサービ…  - [link] ";s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1871;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}s:4:"text";s:161:"ブログに新しい記事を投稿したよ: Google Calendarと連携して最近更新した予定を表示するWebサービ…  - http://tinyurl.com/q2ycbw6";}'
categories:
  - ruby

---
# はじめに

Google Calendarと連携して最近更新した予定を表示するWebサービスを作成しました。

<a href="https://www.flickr.com/photos/42332031@N02/14179337267" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/14179337267', '');" title="http://calendar.kazu634.com/ by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm3.staticflickr.com/2909/14179337267_b60fe80314.jpg" alt="http://calendar.kazu634.com/" width="500" height="415" /></a>

# なぜ作ったの？

Google Calendarと<a href="http://www.1101.com/store/techo/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.1101.com/store/techo/', 'ほぼ日手帳');">ほぼ日手帳</a>を普段使っているのですが、忙しくなってくるとGoogle Calendarしか更新しなくなってしまいました。それでも、手帳を使い続けたいと考えました。手帳の怠ってしまう理由がなにかと考えた時に、Google Calendarと手帳を同期させるときに、どこまで同期させたのかがわからなくなってしまうのが原因と考えました。

そこで、Google Calendarで予定を追加or更新した順番で表示できたらなー、というのが開発の動機です。

# こんな風に表示します

予定を更新した順番に表示します。便利でしょ？

<a href="https://www.flickr.com/photos/42332031@N02/14104108240" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/14104108240', '');" title="GoogleCanendar2DailyPlanner by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm3.staticflickr.com/2904/14104108240_51b4725de2.jpg" alt="GoogleCanendar2DailyPlanner" width="500" height="242" /></a>

# 構成ってどうなっているの？

別記事で詳しく書きます。
