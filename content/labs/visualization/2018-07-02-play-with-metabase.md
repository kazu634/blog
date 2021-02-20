+++
title = "Metabaseをお試しで使ってみた"
date = 2018-07-02T21:15:53+08:00
description = "オープンソースのお手軽BIツール・Metabaseをお試しで使ってみました。これ使えば、エンジニアじゃない人にもグラフを作ってもらえそう"
tags = []
categories = ["Tools", "Metabase"]
images = ["images/41603208672_984110305c_z.jpg"]
+++

[Metabase](https://www.metabase.com/)という、オープンソースのお手軽BIツールがあるということで試してみました。これぐらいお手軽だと、エンジニアじゃない人にも「触ってみて」と言えそうです。

## この記事で説明すること・しないこと
この記事で説明するのは、

- [Metabase](https://www.metabase.com/)の使い勝手
- [Metabase](https://www.metabase.com/)の見え方とか

この記事で説明しないのは、

- [Metabase](https://www.metabase.com/)の構築手順など

です。

## 用意した環境
`MariaDB`に[ヒストリカルデータ \| みずほ銀行](https://www.mizuhobank.co.jp/market/historical.html)のページから、[外国為替公示相場ヒストリカルデータ/日次データ (2002年4月1日～)](https://www.mizuhobank.co.jp/market/csv/quote.csv)をダウンロードして、インサートしました。

この`MariaDB`を[Metabase](https://www.metabase.com/)から参照させました。

## Metabaseの使い方・見え方
[Metabase](https://www.metabase.com/)の使い方ですが、とても簡単でした。以下の赤く囲った部分で必要な条件を入れていくと、お手軽に線グラフができます。

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/29279742668/in/dateposted/" title="USD_·_Metabase"><img src="https://farm2.staticflickr.com/1765/29279742668_13bef75ffb_c.jpg" width="800" height="429" alt="USD_·_Metabase"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

上の例では、米ドルのレートを各週平均をとって線グラフにしました。

## 色々とグラフを見てみた
現在住んでいるシンガポールドルのレートを過去5年分、各週平均をとって線グラフにするとこんな感じでした:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/41340031010/in/dateposted/" title="SGD_·_Metabase"><img src="https://farm2.staticflickr.com/1784/41340031010_928ccbdf94_c.jpg" width="800" height="465" alt="SGD_·_Metabase"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

2015年4月にシンガポールに来たので、その時点のレートを仮に`Goal`と置いてみました。シンガポールに来たときは、日本円が弱く、シンガポールドルが強いタイミングだったみたいです。

もう一つのグラフはタイバーツのグラフです。同じように過去5年、各週平均をとって線グラフにすると、こんな感じでした:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/42246633315/in/photostream/" title="Thai_·_Metabase"><img src="https://farm2.staticflickr.com/1784/42246633315_04091bcac5_c.jpg" width="800" height="430" alt="Thai_·_Metabase"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

線の形的にはシンガポールドルと似たようになっていますが、金額がぜんぜん違うので、ここらへんはどのように判断すべきなのかなぁ…といったところです。日本円の価値はあまり変わらずにずっと来ているということなのかな。

## まとめ
元になるデータさえ用意できれば、お手軽に可視化できて良さそうです。

## 参考
-  [Metabase](https://www.metabase.com/)
- [OSSのデータ可視化ツール「Metabase」が超使いやすい](https://qiita.com/acro5piano/items/0920550d297651b04387)

