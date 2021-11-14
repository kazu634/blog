---
title: Fluentd X GrowthForecastの組み合わせで可視化してみた
date: 2014-04-27T15:04:05Z
author: kazu634
categories:
  - Infra
  - Labs
  - Monitoring
tags:
  - growthforecast
  - fluentd

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
