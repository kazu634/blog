---
title: ベイズの定理(Bayes’ Theorem)
author: kazu634
date: 2007-11-24
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";i:1;s:5:"delay";i:0;s:7:"enabled";i:1;s:10:"separation";s:2:"60";s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:3315;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - つれづれ

---
<div class="section">
<p>
<a href="http://www.asahi.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.asahi.com/', '朝日新聞');" target="_blank">朝日新聞</a>のBEを見ていたら、<a href="http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%A4%E3%82%BA%E3%81%AE%E5%AE%9A%E7%90%86" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%A4%E3%82%BA%E3%81%AE%E5%AE%9A%E7%90%86', 'ベイズの定理');" target="_blank">ベイズの定理</a>の解説がされていた。なんでこんなのを特集しているのかと思ったら、迷惑メールのフィルタリングに話を持って行きたかったようだ。納得。
</p>
  
<p>
    ちなみに<a href="http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%A4%E3%82%BA%E3%81%AE%E5%AE%9A%E7%90%86" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%A4%E3%82%BA%E3%81%AE%E5%AE%9A%E7%90%86', 'ベイズの定理');" target="_blank">ベイズの定理</a>というのは、
</p>
  
<ul>
<li>
<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?P&#40;B&#41;" class="tex" alt="P&#40;B&#41;" /> : 事象Bが発生する確率
</li>
<li>
<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?P&#40;B|A&#41;" class="tex" alt="P&#40;B|A&#41;" /> : 事象Aが起きた後での、事象Bの確率
</li>
</ul>
  
<p>
    としたときに、<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?P&#40;A&#41;&#62;0" class="tex" alt="P&#40;A&#41;&#62;0" />ならば
</p>
  
<p>
<center>
</center>
</p>
  
<p>
<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?P&#40;B|A&#41;=P&#40;A|B&#41;~*~P&#40;B&#41;~/~P&#40;A&#41;" class="tex" alt="P&#40;B|A&#41;=P&#40;A|B&#41; * P&#40;B&#41; / P&#40;A&#41;" />
</p></p> 
  
<p>
    というやつです。
</p>
  
<p>
    数学的にこれがなぜ重要かと言えば、
</p>
  
<blockquote title="ベイズの定理:title - Wikipedia" cite="http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%A4%E3%82%BA%E3%81%AE%E5%AE%9A%E7%90%86">
<p>
      ベイズの定理は、ある結果（データ）が得られた時、その結果を反映した下での事後確率を求めるのに使われている。定理はイギリスの牧師トーマス・ベイズ（1702年(?) &#8211; 1761年）によって発見され、のちにピエール＝シモン・ラプラスによってその存在が広く認識されるようになった。
</p>
    
<p>
<cite><a href="http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%A4%E3%82%BA%E3%81%AE%E5%AE%9A%E7%90%86" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://ja.wikipedia.org/wiki/%E3%83%99%E3%82%A4%E3%82%BA%E3%81%AE%E5%AE%9A%E7%90%86', 'ベイズの定理 &#8211; Wikipedia');" target="_blank">ベイズの定理 &#8211; Wikipedia</a></cite>
</p>
</blockquote>
  
<p>
    という感じ。
</p>
  
<p>
    これを迷惑メールのフィルタリングに当てはめて考えてみると、「あるメールが迷惑メールであり、その迷惑メールの中に存在するキーワードが別なメールにも存在すれば、その別なメールが迷惑メールである可能性が高くなる」というように適応できます。まず人間が迷惑メールであることを教えてあげて、教えれば教えるほど賢くなっていくフィルターです。
</p>
  
<ul>
<li>
      参考 <ul>
<li>
<a href="http://practical-scheme.net/trans/spam-j.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://practical-scheme.net/trans/spam-j.html', 'A Plan for Spam');" target="_blank">A Plan for Spam</a>
</li>
<li>
<a href="http://practical-scheme.net/trans/better-j.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://practical-scheme.net/trans/better-j.html', 'Better Bayesian Filtering');" target="_blank">Better Bayesian Filtering</a>
</li>
<li>
<a href="http://practical-scheme.net/trans/ffb-j.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://practical-scheme.net/trans/ffb-j.html', 'Filters That Fight Back');" target="_blank">Filters That Fight Back</a>
</li>
</ul>
</li>
</ul>
  
<p>
    ごめんなさい。はてなのtex記法試したかっただけです。。。
</p>
</div>
