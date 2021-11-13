---
title: 'Systems Performance: Enterprise and the Cloud を読む'
date: 2014-10-31T15:04:05Z
author: kazu634
categories:
  - Labs
  - Infra
tags:
  - book

---
<a href="http://www.amazon.co.jp/Systems-Performance-Enterprise-Brendan-Gregg-ebook/dp/B00FLYU9T2/ref=sr_1_6?s=english-books&ie=UTF8&qid=1414762573&sr=1-6&keywords=system+performance" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazon.co.jp/Systems-Performance-Enterprise-Brendan-Gregg-ebook/dp/B00FLYU9T2/ref=sr_1_6?s=english-books&ie=UTF8&qid=1414762573&sr=1-6&keywords=system+performance', 'Systems Performance: Enterprise and the Cloud');">Systems Performance: Enterprise and the Cloud</a>を読んでいます。システム管理の分野で顕著な成果として2013年度のLISA Awardというのを受賞した書籍らしいのですが、これがまた面白い。たぶん自分が何を説明しているのかを正確に理解している人が、わかりやすく伝える努力を惜しまずに書くとこんな書籍になるのだと思う。これは最後まで読まねば。

著者の人のスライドを発見したので貼り付け:



<div style="margin-bottom: 5px;">
<strong> <a title="Linux Performance Tools 2014" href="//www.slideshare.net/brendangregg/linux-performance-tools-2014" target="_blank">Linux Performance Tools 2014</a> </strong> from <strong><a href="//www.slideshare.net/brendangregg" target="_blank">Brendan Gregg</a></strong>
</div>

とりあえず気になった部分をまとめていきます。随時更新。

更新履歴:

  * 2014/10/31: Introductionの途中までメモ
  * 2014/11/01: Methodologyの途中までメモ

* * *

<div class="amazlet-box" style="margin-bottom: 0px;">
<div class="amazlet-image" style="float: left; margin: 0px 12px 1px 0px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00FLYU9T2/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00FLYU9T2/simsnes-22/ref=nosim/', '');" target="_blank" name="amazletlink"><img style="border: none;" src="https://images-na.ssl-images-amazon.com/images/I/61d0BC4HCnL._SL160_.jpg" alt="Systems Performance: Enterprise and the Cloud" /></a>
</div>

<div class="amazlet-info" style="line-height: 120%; margin-bottom: 10px;">
<div class="amazlet-name" style="margin-bottom: 10px; line-height: 120%;">
<p>
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00FLYU9T2/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00FLYU9T2/simsnes-22/ref=nosim/', 'Systems Performance: Enterprise and the Cloud');" target="_blank" name="amazletlink">Systems Performance: Enterprise and the Cloud</a>
</p>

<div class="amazlet-powered-date" style="font-size: 80%; margin-top: 5px; line-height: 120%;">
        posted with <a href="http://www.amazlet.com/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazlet.com/', 'amazlet');" title="amazlet"  target="_blank">amazlet</a> at 14.10.31
</div>
</div>

<div class="amazlet-detail">
      Prentice Hall (2013-10-07)
</div>

<div class="amazlet-sub-info" style="float: left;">
<div class="amazlet-link" style="margin-top: 5px;">
<a href="https://www.amazon.co.jp/exec/obidos/ASIN/B00FLYU9T2/simsnes-22/ref=nosim/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.amazon.co.jp/exec/obidos/ASIN/B00FLYU9T2/simsnes-22/ref=nosim/', 'Amazon.co.jpで詳細を見る');" target="_blank" name="amazletlink">Amazon.co.jpで詳細を見る</a>
</div>
</div>
</div>

<div class="amazlet-footer" style="clear: left;">
</div>
</div>

<!--more-->

* * *

## Introduction

冒頭、ドナルド・ラムズフェルドの発言を引用して始まります:

> There are known knowns; there are thing we know we know. We also know there are known unknowns; that is to say we know there are some things we do not know. But there are also unknown unknowns &#8212; there are things we do not know we do not know.
>
> &#8212; U.S. Secretary of Defense Donald Rumsfeld, Feb 12, 2002

この書籍で扱う Performance は、&#8221;unknown unknowns&#8221;、「つまり知らないことすら認識していないこと」だと述べていく。この出だしだけで、この書籍が巧みに読者の興味をくすぐっている事がわかるかと思う。

### Performance is challenging

パフォーマンスに関する問題が難しい理由を３つ挙げて解説している。

#### Performance is subjective

パフォーマンスに関する問題は主観的なものであり、明確なゴールを設定せずには客観的にはなりえない。たとえば、平均レスポンスタイムを設定したり、一定の割合のリクエストが特定のレイテンシの範囲におさまるなどというように。

#### Systems are complex

複雑なパフォーマンス上の問題を解決するためには、ホリスティックなアプローチが必要となることが多い。システム全体、つまりシステム内部と外部間の接続を調査する必要がある。こうした調査を実施するためには、幅広いスキルが必要になる。必要とされるスキルの範囲が広く、一人のエンジニアがこうしたスキルをすべて持つことはあまり無い。また、システム全体を調査する必要があるために、パフォーマンス上の問題解決は多種多様であり、困難な問題となる。

#### There can be multiple performance issue

パフォーマンス上の問題はいたるところにあり、実際にやるべきタスクはボトルネックになっている問題を特定することだ。

## Chapter 2: Methodology

冒頭、シャーロック・ホームズからの引用で始まりました:

> It is capital mistake to theorize before one has data. Insensibly one begins to twist facts to suit theories, instead of theories to suit facts.
>
> &#8212; Sherlock Holmes in &#8220;A Scandal in Bohemia&#8221; by Sir Arthur Conan Doyle

データーを入手する前に理屈付けるのは大きな誤りだ。気付かないうちに、事実に合わせて陸続けるのではなくて、理屈に合わせて事実をねじ曲げることになるから……というこれまた的確な引用といえるかと。

### Termiology

#### IOPS

Input/Output operations per second is a measure of the rate of data transfer operation.

#### Throughput

The rate of work performed. Especially in communications, the term is used to refer to the data rate (byte per second or bit per second).

#### Responsetime

The time for an operation to complete. This includes any time spent waiting and time spent being serviced (service time), including the time to transfer the result.

#### Latency

A measure of time an operation spends waiting to be serviced.

#### Utilization

For resources that service requests, utilization is a measure of how busy a resource is, based on how much time in a given interval it was actively performing work.

#### Saturation

The degree to which a resource has queued work it cannot service.

#### Bottleneck

In system performance, a bottleneck is a resource that limits the performance of the system. Identifying and removing systematic bottlenecks is a key activity of system performance.

#### workload

The input to the system or the load applied is the workload.

### CPU視点でみた場合の各パーツの処理に要する時間とわかりやすい卑近な例に例えたら

こんな感じの表が掲載されていました:

<a href="https://www.flickr.com/photos/42332031@N02/15680611275" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15680611275', '');" title="CPU_cycletime_and_its_scaled_time by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm4.staticflickr.com/3952/15680611275_e9971829fd.jpg" alt="CPU_cycletime_and_its_scaled_time" width="500" height="316" /></a>

CPUからするとSSDすらかなり遅いんですね。。。
