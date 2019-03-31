---
title: RTX810と無線LANアクセスポイントを組み合わせてみた
author: kazu634
date: 2014-10-20
url: /2014/10/21/rtx810_with_wifi_access_point/
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1879;}'
wordtwit_post_info:
  - 'O:8:"stdClass":14:{s:6:"manual";b:1;s:11:"tweet_times";i:1;s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";s:126:"ブログに新しい記事を投稿したよ: RTX810と無線LANアクセスポイントを組み合わせてみた - [link] ";s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1879;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}s:4:"text";s:145:"ブログに新しい記事を投稿したよ: RTX810と無線LANアクセスポイントを組み合わせてみた - http://tinyurl.com/k74pluf";}'
tmac_last_id:
  - 529629725275090944
categories:
  - network
  - インフラ

---
<a href="https://www.flickr.com/photos/sacabezas/5829340509" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/sacabezas/5829340509', '');" title="Router by Santiago Cabezas, on Flickr"><img class="aligncenter" src="https://farm6.staticflickr.com/5277/5829340509_df496661e0.jpg" alt="Router" width="500" height="375" /></a>

RTX810を以前購入し導入していたのですが、無線LANと併用するためにこれまではプロバイダが支給する無線LANルーターにぶら下げて使用していました。ネットワーク図としては以下の様な感じです:

<a href="https://www.flickr.com/photos/42332031@N02/14952993624" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/14952993624', '');" title="home_network_before by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm4.staticflickr.com/3947/14952993624_a1388b489e.jpg" alt="home_network_before" width="500" height="331" /></a>

無線LANルーターの配下にPPPoEパススルーではありましたが、RTX810がぶら下がるという構成。これはなんとももったいない構成で、できればWAN側に直接接続する構成を取りたい。ということで、無線LANアクセスポイントを購入して、以下の構成に変更しました:

<a href="https://www.flickr.com/photos/42332031@N02/15574587282" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15574587282', '');" title="home_network_after by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm4.staticflickr.com/3945/15574587282_73a878fd49.jpg" alt="home_network_after" width="500" height="317" /></a>

注目して欲しいのは、無線LANアクセスポイントはブリッジとして機能していて、WiFiネットワークと家庭内LANが同一のネットワークに所属していること。こうすることで、nasneくんがiPadから見えるようになりました。地味に嬉しい。

ネットワーク構成の変更とRTX810でVPNを駆使することで、外部からのアクセスが格段に便利にできるようになりました。nasneに録画した映像をリモートで視聴ということもできるようになりました。これはすごいなぁ。

* * *

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B005TC9B7M/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B005TC9B7M/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/31gklO2eUWL._SL160_.jpg" alt="ヤマハ ギガアクセスVPNルーター RTX810" /></a>
</div>
  
<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<p>
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B005TC9B7M/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B005TC9B7M/simsnes-22/ref=nosim/', 'ヤマハ ギガアクセスVPNルーター RTX810');" target="_blank" name="amazletlink">ヤマハ ギガアクセスVPNルーター RTX810</a>
</p>
      
<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 14.10.20
</div>
</div>
    
<div class="amazlet-detail">
      ヤマハ (2011-11-05)<br /> 売り上げランキング: 2,526
</div>
    
<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B005TC9B7M/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B005TC9B7M/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>
  
<div class="amazlet-footer" style="clear: left;">
</div>
</div>

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00KWV66DW/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00KWV66DW/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/41FcLDv4PDL._SL160_.jpg" alt="PLANEX 無線LANアクセスポイント 11ac/n/a 866Mbps 5GHz専用 5ギガでGO! MZK-UPG900HPA AppleTV・iPhone・Android対応" /></a>
</div>
  
<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<p>
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00KWV66DW/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00KWV66DW/simsnes-22/ref=nosim/', 'PLANEX 無線LANアクセスポイント 11ac/n/a 866Mbps 5GHz専用 5ギガでGO! MZK-UPG900HPA AppleTV・iPhone・Android対応');" target="_blank" name="amazletlink">PLANEX 無線LANアクセスポイント 11ac/n/a 866Mbps 5GHz専用 5ギガでGO! MZK-UPG900HPA AppleTV・iPhone・Android対応</a>
</p>
      
<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 14.10.20
</div>
</div>
    
<div class="amazlet-detail">
      PLANEX<br /> 売り上げランキング: 28,274
</div>
    
<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00KWV66DW/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00KWV66DW/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>
  
<div class="amazlet-footer" style="clear: left;">
</div>
</div>

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00F27JGT2/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00F27JGT2/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/41hXi6o3VQL._SL160_.jpg" alt="nasne 1TBモデル (CECH-ZNR2J)" /></a>
</div>
  
<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00F27JGT2/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00F27JGT2/simsnes-22/ref=nosim/', 'nasne 1TBモデル (CECH-ZNR2J)');" target="_blank" name="amazletlink">nasne 1TBモデル (CECH-ZNR2J)</a></p> 
      
<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 14.10.20
</div>
</div>
    
<div class="amazlet-detail">
      ソニー・コンピュータエンタテインメント (2013-10-10)<br /> 売り上げランキング: 85
</div>
    
<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00F27JGT2/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00F27JGT2/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>
  
<div class="amazlet-footer" style="clear: left;">
</div>
</div>
