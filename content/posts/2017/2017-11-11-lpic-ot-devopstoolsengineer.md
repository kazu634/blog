+++
title = "LPIC OT: DevOps Tools Engineerという試験を見つけたよ"
date = 2017-11-11T22:58:38+08:00
description = "LPICについて調べていたら、英語でしか受験できないLPIC OT: DevOps Tools Engineerという試験を見つけたよ。最近のオープンソースを用いたDevOps関係のはやりを抑えた試験になっているみたい"
tags = ["prometheus"]
categories = ["インフラ", "Linux", "監視"]
author = "kazu634"
+++

シンガポールでもLPICを受験できると知り、LPICについて色々と調べていると、英語でしか受験できない[LPIC\-OT 701: DevOps Tools Engineer](http://www.lpi.org/our-certifications/lpic-ot-devops-overview)という資格を見つけました。

<a data-flickr-embed="true"  href="http://www.lpi.org/our-certifications/lpic-ot-devops-overview" title="LPIC OT 701  DevOps Tools Engineer   Linux Professional Institute"><img src="https://farm5.staticflickr.com/4556/38278788676_0cd63ffc01.jpg" width="500" height="273" alt="LPIC OT 701  DevOps Tools Engineer   Linux Professional Institute"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>
以下の部分にどんな試験なのかがまとめられていました:

> In developing the LPIC-Open Technology DevOps Tools Engineer certification, LPI reviewed the DevOps tools landscape and defined a set of essential skills when applying DevOps. As such, the certification exam focuses on the practical skills required to work successfully in a DevOps environment -- focusing on the skills needed to use the most prominent DevOps tools. The result is a certification that covers the intersection between development and operations, making it relevant for all IT professionals working in the field of DevOps.

要するに、DevOpsで必要となるツールを調べて、試験としてまとめてみたということらしいです。

驚きポイントとしては、オープンソースの監視ツール[Prometheus](https://prometheus.io/)が取り上げられていたこと。`Google`に勤務していた人が一時的に他の会社に就職して、`Google`で使われていたのと似たような監視ツールを作成して、オープンソースとして公開したものとのこと。

監視される側にはバイナリひとつはデプロイすると基本的なメトリックスは取得できる仕組みで、かなりお手軽。こうした試験に取り上げられたということは、今後広まっていくものと思います。


