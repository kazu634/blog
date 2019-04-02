---
title: クラスのインスタンスを作成するとき (@shibuyalisp Hackathon)
author: kazu634
date: 2010-10-24
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";i:1;s:5:"delay";i:0;s:7:"enabled";i:1;s:10:"separation";s:2:"60";s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:5369;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - gauche

---
<div class="section">
<p>
    値が束縛されているときだけ、スロットに束縛するにはどうすればいいのかな？やりたいことはこういうことなんだけど、「malformed if」と怒られた:
</p>
  
<pre class="syntax-highlight">
<span class="synSpecial">(</span>define-class &#60;photo-data&#62; <span class="synSpecial">()</span>
<span class="synSpecial">((</span>width :init-keyword :width :init-value <span class="synConstant"></span><span class="synSpecial">)</span>
<span class="synSpecial">(</span>url-with-slug :init-keyword :url-with-slug :init-value <span class="synConstant">&#34;&#34;</span><span class="synSpecial">)))</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>make-photo-data-list sxml<span class="synSpecial">)</span>
<span class="synSpecial">(</span>make &#60;photo-data&#62;
<span class="synComment">;; 与えられたSXMLにwidth要素が存在するとき、スロットに値をセットしたい</span>
<span class="synComment">;; でも、これだとエラーになる</span>
<span class="synSpecial">(</span><span class="synStatement">if</span> <span class="synSpecial">((</span>if-car-sxpath <span class="synSpecial">'(</span><span class="synStatement">//</span> width<span class="synSpecial">))</span> sxml<span class="synSpecial">)</span>
:width <span class="synSpecial">(</span><span class="synStatement">cadr</span> <span class="synSpecial">((</span>car-sxpath <span class="synSpecial">'(</span><span class="synStatement">//</span> width<span class="synSpecial">))</span> sxml<span class="synSpecial">))</span>
:width <span class="synConstant"></span><span class="synSpecial">)</span>
:url-with-slug <span class="synSpecial">(</span><span class="synStatement">cadr</span> <span class="synSpecial">((</span>car-sxpath <span class="synSpecial">'(</span><span class="synStatement">//</span> url-with-slug<span class="synSpecial">))</span>
sxml<span class="synSpecial">))))</span>
</pre>
</div>
