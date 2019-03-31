---
title: Fluentd X GrowthForecastの組み合わせで可視化してみた
author: kazu634
date: 2014-04-27
url: /2014/04/27/visualize_the_bottleneck_using_fluentd_x_growthforecast/
geo_latitude:
  - 38.306184
geo_longitude:
  - 141.022638
geo_public:
  - 1
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1859;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1859;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - growthforecast

---
`Fluentd`と`GrowthForecast`を組み合わせてレスポンスタイムの可視化を実施しました。

## 構成について

今回は`Nginx`のログからアプリケーションサーバとの通信に要した時間(=①)と、ブラウザとの通信に要した時間(=②)を可視化してみました。

<center>
<br /> <a href="https://www.flickr.com/photos/42332031@N02/14006819636" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/14006819636', '');" title="GrowthForecast_Diagram by Kazuhiro MUSASHI, on Flickr"><img src="https://farm3.staticflickr.com/2922/14006819636_9a3e8b9b5e.jpg" alt="GrowthForecast_Diagram" width="500" height="488" /></a>
</center>①と②を比較することで、何がボトルネックになりうるのかを把握することが目的です。

仮説としては、`Nginx`はフロントで配信を担当しているだけだから、①と②はほぼ同じ値になるはずです。

## 出来上がったグラフ

まずは①と②を可視化したグラフがこちらになります:

<center>
<br /> <a href="https://www.flickr.com/photos/42332031@N02/14004111506" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/14004111506', '');" title="growthforecast_example003 by Kazuhiro MUSASHI, on Flickr"><img src="https://farm8.staticflickr.com/7215/14004111506_54c2d630b7.jpg" alt="growthforecast_example003" width="500" height="252" /></a>
</center>この二つのグラフを見ただけだと、似たような傾向になっていることはわかりますが、問題の有無がよくわかりません。二つのグラフを重ねて見ます:

<center>
<br /> <a href="https://www.flickr.com/photos/42332031@N02/14027625574" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/14027625574', '');" title="growthforecast_example002 by Kazuhiro MUSASHI, on Flickr"><img src="https://farm8.staticflickr.com/7021/14027625574_bb4a226111.jpg" alt="growthforecast_example002" width="500" height="446" /></a>
</center>これではっきりわかります。配信のみを担当しているはずの

`Nginx`が特定のタイミングでだけ明らかにパフォーマンスが落ちています。じゃあ、このタイミングで何が起こっていたのか？それが気になってきます。