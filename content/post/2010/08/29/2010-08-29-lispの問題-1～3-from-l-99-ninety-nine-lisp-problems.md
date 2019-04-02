---
title: 'Lispの問題 1～3 from L-99: Ninety-Nine Lisp Problems'
author: kazu634
date: 2010-08-29
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";i:1;s:5:"delay";i:0;s:7:"enabled";i:1;s:10:"separation";s:2:"60";s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:5333;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - gauche
  - Lisp

---
<div class="section">
<p>
    「<a href="http://www.ic.unicamp.br/~meidanis/courses/mc336/2006s2/funcional/L-99_Ninety-Nine_Lisp_Problems.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.ic.unicamp.br/~meidanis/courses/mc336/2006s2/funcional/L-99_Ninety-Nine_Lisp_Problems.html', 'L-99: Ninety-Nine Lisp Problems');" target="_blank">L-99: Ninety-Nine Lisp Problems</a>」で掲載されている問題を解いてみました。この辺なら問題なさそう。
</p>
  
<p>
    番号が増えていくと、手に負えなくなりそうだなぁ。。。
</p>
  
<pre class="syntax-highlight">
<span class="synComment">;; P01 (*) Find the last box of a list.</span>
<span class="synComment">;;     Example:</span>
<span class="synComment">;;     * (my-last '(a b c d))</span>
<span class="synComment">;;     (D)</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>my-last l<span class="synSpecial">)</span>
<span class="synSpecial">(</span>letrec <span class="synSpecial">((</span>temporary <span class="synSpecial">(</span><span class="synStatement">lambda</span> <span class="synSpecial">(</span>a l<span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">cond</span>
[<span class="synSpecial">(</span><span class="synStatement">null</span>? l<span class="synSpecial">)</span> a]
[else <span class="synSpecial">(</span>temporary <span class="synSpecial">(</span><span class="synStatement">car</span> l<span class="synSpecial">)</span> <span class="synSpecial">(</span><span class="synStatement">cdr</span> l<span class="synSpecial">))</span>]<span class="synSpecial">))))</span>
<span class="synSpecial">(</span>temporary <span class="synSpecial">'()</span> l<span class="synSpecial">)))</span>
<span class="synSpecial">(</span>my-last <span class="synSpecial">'(</span>a b c d<span class="synSpecial">))</span>
<span class="synComment">;; P02 (*) Find the last but one box of a list.</span>
<span class="synComment">;;     Example:</span>
<span class="synComment">;;     * (my-but-last '(a b c d))</span>
<span class="synComment">;;     (C D)</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>my-but-last l<span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">cond</span>
[<span class="synSpecial">(</span><span class="synStatement">null</span>? l<span class="synSpecial">)</span> <span class="synSpecial">'()</span>]
[<span class="synSpecial">(</span><span class="synStatement">and</span> <span class="synSpecial">(</span><span class="synStatement">not</span> <span class="synSpecial">(</span><span class="synStatement">null</span>? <span class="synSpecial">(</span><span class="synStatement">cdr</span> l<span class="synSpecial">)))</span>
<span class="synSpecial">(</span><span class="synStatement">null</span>? <span class="synSpecial">(</span><span class="synStatement">cdr</span> <span class="synSpecial">(</span><span class="synStatement">cdr</span> l<span class="synSpecial">))))</span> l]
[else <span class="synSpecial">(</span>my-but-last <span class="synSpecial">(</span><span class="synStatement">cdr</span> l<span class="synSpecial">))</span>]<span class="synSpecial">))</span>
<span class="synSpecial">(</span>my-but-last <span class="synSpecial">'(</span>a b c d e f g<span class="synSpecial">))</span>
<span class="synComment">;; P03 (*) Find the K'th element of a list.</span>
<span class="synComment">;;     The first element in the list is number 1.</span>
<span class="synComment">;;     Example:</span>
<span class="synComment">;;     * (element-at '(a b c d e) 3)</span>
<span class="synComment">;;     C</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>element-at l index<span class="synSpecial">)</span>
<span class="synSpecial">(</span>letrec <span class="synSpecial">((</span>temporary <span class="synSpecial">(</span><span class="synStatement">lambda</span> <span class="synSpecial">(</span>l index <span class="synStatement">count</span><span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">cond</span>
[<span class="synSpecial">(</span><span class="synStatement">null</span>? l<span class="synSpecial">)</span> <span class="synSpecial">'()</span>]
[<span class="synSpecial">(</span><span class="synStatement">eq</span>? index <span class="synStatement">count</span><span class="synSpecial">)</span> <span class="synSpecial">(</span><span class="synStatement">car</span> l<span class="synSpecial">)</span>]
[else <span class="synSpecial">(</span>temporary <span class="synSpecial">(</span><span class="synStatement">cdr</span> l<span class="synSpecial">)</span>
index
<span class="synSpecial">(</span><span class="synStatement">+</span> <span class="synStatement">count</span> <span class="synConstant">1</span><span class="synSpecial">))</span>]<span class="synSpecial">))))</span>
<span class="synSpecial">(</span>temporary l index <span class="synConstant">1</span><span class="synSpecial">)))</span>
<span class="synSpecial">(</span>element-at <span class="synSpecial">'(</span>a b c d e<span class="synSpecial">)</span> <span class="synConstant">-1</span><span class="synSpecial">)</span>
</pre>
</div>
