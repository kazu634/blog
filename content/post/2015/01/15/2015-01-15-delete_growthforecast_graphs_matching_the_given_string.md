---
title: 引数で与えた文字列とservice_nameが一致するGrowthforecastのグラフを一括で削除するスクリプト
author: kazu634
date: 2015-01-15
url: /2015/01/15/delete_growthforecast_graphs_matching_the_given_string/
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:6599;}'
wordtwit_post_info:
  - 'O:8:"stdClass":14:{s:6:"manual";b:1;s:11:"tweet_times";i:1;s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";s:131:"ブログに新しい記事を投稿したよ: 引数で与えた文字列とservice_nameが一致するGrowthforecastの - [link] ";s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:6599;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}s:4:"text";s:150:"ブログに新しい記事を投稿したよ: 引数で与えた文字列とservice_nameが一致するGrowthforecastの - http://tinyurl.com/kjlzno9";}'
tmac_last_id:
  - 579895627653447681
categories:
  - growthforecast
  - インフラ

---
<a href="https://www.flickr.com/photos/42332031@N02/16100539977" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/16100539977', '');" title="growthforecast by Kazuhiro MUSASHI, on Flickr"><img class=" aligncenter" src="https://farm8.staticflickr.com/7468/16100539977_c7bcdcfb8d.jpg" alt="growthforecast" width="500" height="294" /></a>

最近はせっせと<a href="http://kazeburo.github.io/GrowthForecast/index.ja.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://kazeburo.github.io/GrowthForecast/index.ja.html', 'Growthforecast');" title="Growthforecast"  target="_blank">Growthforecast</a>でグラフを作成しています。適度な間隔で性能情報を送信して、パフォーマンスモニタリングしています。

テスト用に作成したグラフを一括で削除したいなって時に便利なスクリプトを作成してみました。引数で与えた文字列とservice_nameが一致する<a href="http://kazeburo.github.io/GrowthForecast/index.ja.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://kazeburo.github.io/GrowthForecast/index.ja.html', 'Growthforecast');" title="Growthforecast"  target="_blank">Growthforecast</a>のグラフを一括で削除するスクリプトです:

```
#!/opt/sensu/embedded/bin/ruby

require 'growthforecast'

# abort unless one argument is given:
abort unless ARGV.length == 1

str = ARGV[0]

# Create `Growthforecast` instance:
gf = GrowthForecast.new('localhost', 5125)

glist = gf.graphs()

glist.each do |graph|
  if /#{str}/ =~ graph.service_name

    # puts "#{graph.service_name}:#{graph.section_name}:#{graph.graph_name} is deleted."
    gf.delete(graph)

  end
end
```
