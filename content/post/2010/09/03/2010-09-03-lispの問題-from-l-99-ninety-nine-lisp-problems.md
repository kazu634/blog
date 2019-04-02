---
title: 'Lispの問題 from L-99: Ninety-Nine Lisp Problems'
author: kazu634
date: 2010-09-03
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";i:1;s:5:"delay";i:0;s:7:"enabled";i:1;s:10:"separation";s:2:"60";s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:5335;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - gauche
  - Lisp

---
<div class="section">
<p>
    「<a href="http://d.hatena.ne.jp/sirocco634/20100829#1283083736" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/sirocco634/20100829#1283083736', '前回');" target="_blank">前回</a>」の続きです:
</p>
  
<pre class="syntax-highlight">
<span class="synComment">;; P04 (*) Find the number of elements of a list.</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>my-length l<span class="synSpecial">)</span>
<span class="synSpecial">(</span>letrec <span class="synSpecial">((</span>temp <span class="synSpecial">(</span><span class="synStatement">lambda</span> <span class="synSpecial">(</span><span class="synStatement">count</span> l<span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">cond</span>
[<span class="synSpecial">(</span><span class="synStatement">null</span>? l<span class="synSpecial">)</span> <span class="synStatement">count</span>]
[else <span class="synSpecial">(</span>temp <span class="synSpecial">(</span><span class="synStatement">+</span> <span class="synStatement">count</span> <span class="synConstant">1</span><span class="synSpecial">)</span> <span class="synSpecial">(</span><span class="synStatement">cdr</span> l<span class="synSpecial">))</span>]<span class="synSpecial">))))</span>
<span class="synSpecial">(</span>temp <span class="synConstant"></span> l<span class="synSpecial">)))</span>
<span class="synSpecial">(</span>my-length <span class="synSpecial">'(</span>1 2 3 <span class="synSpecial">(</span>4 5<span class="synSpecial">)</span> 4 5<span class="synSpecial">))</span>
<span class="synComment">;; P05 (*) Reverse a list.</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>my-reverse l<span class="synSpecial">)</span>
<span class="synSpecial">(</span>letrec <span class="synSpecial">((</span>temp <span class="synSpecial">(</span><span class="synStatement">lambda</span> <span class="synSpecial">(</span>result l<span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">cond</span>
[<span class="synSpecial">(</span><span class="synStatement">null</span>? l<span class="synSpecial">)</span> result]
[else <span class="synSpecial">(</span>temp <span class="synSpecial">(</span><span class="synStatement">cons</span> <span class="synSpecial">(</span><span class="synStatement">car</span> l<span class="synSpecial">)</span> result<span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">cdr</span> l<span class="synSpecial">))</span>]<span class="synSpecial">))))</span>
<span class="synSpecial">(</span>temp <span class="synSpecial">'()</span> l<span class="synSpecial">)))</span>
<span class="synSpecial">(</span>my-reverse <span class="synSpecial">'(</span>1 2 3 4 5<span class="synSpecial">))</span>
<span class="synComment">;; P06 (*) Find out whether a list is a palindrome.</span>
<span class="synComment">;;     A palindrome can be read forward or backward; e.g. (x a m a x).</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>palindrome? l<span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">equal</span>? l
<span class="synSpecial">(</span>my-reverse l<span class="synSpecial">)))</span>
<span class="synSpecial">(</span>palindrome? <span class="synSpecial">'(</span>1 2 3 2 1<span class="synSpecial">))</span>
</pre>
</div>
