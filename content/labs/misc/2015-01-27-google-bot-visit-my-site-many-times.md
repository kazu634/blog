---
title: 今度はボットが襲来しました
author: kazu634
date: 2015-01-26T15:04:05Z
author:
  - kazu634
categories:
  - Labs
  - Infra
  - Monitoring
tags:
  - troubleshooting

---
<a href="https://www.flickr.com/photos/nukamari/8199540353" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/nukamari/8199540353', '');" title="Long Live Rock 'n' Roll by Nukamari, on Flickr"><img class=" aligncenter" src="https://farm9.staticflickr.com/8057/8199540353_d0ef418eea.jpg" alt="Long Live Rock 'n' Roll" width="500" height="332" /></a>

今度はボットくんが襲来してきました。サーバーのリソース使用状況が異なるので、メモとして貼りつけておきますね。まずはアクセス数から:

<a href="https://www.flickr.com/photos/42332031@N02/16186765529" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16186765529', '');" title="access by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7368/16186765529_5d7160934e.jpg" alt="access" width="465" height="205" /></a>

次はレスポンスタイムです。ブルートフォースアタックの時は、ログインページにのみのアクセスだったため、ほとんど500ms以内のレスポンスタイムでしたが、ボットのアクセスは網羅的で、キャッシュに載っていないページは生成処理が入るため、一部でレスポンスタイムが悪化しているみたいです:

<a href="https://www.flickr.com/photos/42332031@N02/16371262121" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16371262121', '');" title="response_percent by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7414/16371262121_9203d6f21b.jpg" alt="response_percent" width="464" height="329" /></a>

Load Averageはこちら:

<a href="https://www.flickr.com/photos/42332031@N02/16372989905" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16372989905', '');" title="load_avg by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7436/16372989905_90b2fa22c5.jpg" alt="load_avg" width="465" height="218" /></a>

CPU使用率です。やっぱり、キャッシュに載っていないページを生成する際は、瞬間的にUserの割合が高くなってしまうようです。逆にキャッシュに乗っているページを応答する場合は、ほとんどCPUを使用せずに処理できていることもわかります:

<a href="https://www.flickr.com/photos/42332031@N02/16185349948" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16185349948', '');" title="cpu by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7357/16185349948_3900d9de25.jpg" alt="cpu" width="465" height="301" /></a>
