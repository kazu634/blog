---
title: Reading SICP – 2
author: kazu634
date: 2008-11-30
url: /2008/11/30/reading-sicp-2/
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";i:1;s:5:"delay";i:0;s:7:"enabled";i:1;s:10:"separation";s:2:"60";s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:4409;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - Lisp

---
<div class="section">
<p>
<i><a href="http://d.hatena.ne.jp/asin/0262510871" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/asin/0262510871', 'Structure and Interpretation of Computer Programs (MIT Electrical Engineering and Computer Science)');">Structure and Interpretation of Computer Programs (MIT Electrical Engineering and Computer Science)</a></i>を読む、その2です。今回は
</p>
  
<ul>
<li>
      compound procedure（例えば (define (square a) (* a a))しておいてから、(define (sum-of-square a b) (+ (square a) (square b)))と書いた時の「(define (sum-of-square a b) (+ (square a) (square b)))」のこと） <ul>
<li>
          substitution model (インタープリタ内部でどのようにcompound proedureを評価するのか。暫定的な説明として、「手続きを置き換え(substitute)てprimitiveな手続きのみの組み合わせに変換する」というモデルが導入される。でも、これは後で破綻するよ！って書いてあった) <ul>
<li>
              Applicative order（インタープリタが行っている方法。引数を先に評価してから、operandを適用する）
</li>
<li>
              normal order(まずはoperandをどんどんprimitiveな手続きに変換する)
</li>
</ul>
</li>
</ul>
</li>
</ul>
  
<p>
    というようなことが書いてありました（私の理解が間違えていなければ…）。
</p>
  
<h4>
    Excercise (pp 20-21)
</h4>
  
<h5>
    Excercise 1.2
</h5>
  
<blockquote>
<p>
      Translate the following expression into prefix form
</p>
    
<blockquote>
<p>
<img src="http://d.hatena.ne.jp/cgi-bin/mimetex.cgi?\frac{5~+~4~+~&#40;2~-~&#40;3~-~&#40;6~+~\frac{4}{5}&#41;&#41;&#41;}{3&#40;6~-~2&#41;&#40;2~-~7&#41;}" class="tex" alt="￥frac{5 + 4 + &#40;2 - &#40;3 - &#40;6 + ￥frac{4}{5}&#41;&#41;&#41;}{3&#40;6 - 2&#41;&#40;2 - 7&#41;}" />
</p>
</blockquote>
</blockquote>
  
<pre class="syntax-highlight">
<span class="synSpecial">(</span><span class="synStatement">/</span> <span class="synSpecial">(</span><span class="synStatement">+</span> <span class="synConstant">5</span> <span class="synConstant">4</span> <span class="synSpecial">(</span><span class="synStatement">-</span> <span class="synConstant">2</span> <span class="synSpecial">(</span><span class="synStatement">-</span> <span class="synConstant">3</span> <span class="synSpecial">(</span><span class="synStatement">+</span> <span class="synConstant">6</span> <span class="synSpecial">(</span><span class="synStatement">/</span> <span class="synConstant">4</span> <span class="synConstant">5</span><span class="synSpecial">)))))</span> <span class="synSpecial">(</span><span class="synStatement">*</span> <span class="synConstant">3</span> <span class="synSpecial">(</span><span class="synStatement">-</span> <span class="synConstant">6</span> <span class="synConstant">2</span><span class="synSpecial">)</span> <span class="synSpecial">(</span><span class="synStatement">-</span> <span class="synConstant">2</span> <span class="synConstant">7</span><span class="synSpecial">)))</span>
</pre>
  
<h5>
    Excercise 1.3
</h5>
  
<blockquote>
<p>
      Define a procedure that takes 3 numbers as arguments and returns the sum of the squares of the two larger numbers.
</p>
</blockquote>
  
<pre class="syntax-highlight">
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>sum-of-square a b c<span class="synSpecial">)</span>
<span class="synSpecial">(</span>define <span class="synSpecial">(</span>square n<span class="synSpecial">)</span>
<span class="synSpecial">(</span><span class="synStatement">*</span> n n<span class="synSpecial">))</span>
<span class="synSpecial">(</span><span class="synStatement">cond</span> [<span class="synSpecial">(</span><span class="synStatement">and</span> <span class="synSpecial">(</span><span class="synStatement">&#60;</span> a b<span class="synSpecial">)</span> <span class="synSpecial">(</span><span class="synStatement">&#60;</span> a c<span class="synSpecial">))</span> <span class="synSpecial">(</span><span class="synStatement">+</span> <span class="synSpecial">(</span>square b<span class="synSpecial">)</span> <span class="synSpecial">(</span>square c<span class="synSpecial">))</span>]   <span class="synComment">; when a is the smallest</span>
[<span class="synSpecial">(</span><span class="synStatement">and</span> <span class="synSpecial">(</span><span class="synStatement">&#60;</span> b a<span class="synSpecial">)</span> <span class="synSpecial">(</span><span class="synStatement">&#60;</span> b c<span class="synSpecial">))</span> <span class="synSpecial">(</span><span class="synStatement">+</span> <span class="synSpecial">(</span>square a<span class="synSpecial">)</span> <span class="synSpecial">(</span>square c<span class="synSpecial">))</span>]   <span class="synComment">; when b is the smallest</span>
[<span class="synSpecial">(</span><span class="synStatement">and</span> <span class="synSpecial">(</span><span class="synStatement">&#60;</span> c a<span class="synSpecial">)</span> <span class="synSpecial">(</span><span class="synStatement">&#60;</span> c b<span class="synSpecial">))</span> <span class="synSpecial">(</span><span class="synStatement">+</span> <span class="synSpecial">(</span>square a<span class="synSpecial">)</span> <span class="synSpecial">(</span>square b<span class="synSpecial">))</span>]<span class="synSpecial">))</span> <span class="synComment">; when c is the smallest</span>
</pre>
</div>