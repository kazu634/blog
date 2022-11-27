+++
title="Yahoo.com Financeから株価のCSVを取得する方法"
date=2021-10-17T14:04:05+09:00
description="アメリカのYahoo.comでは日本企業の株価でもCSVで取得できるということで、どのようにすればダウンロードできるか確認してみました"
categories = ["Visualization", "Finance"]
tags = ["chart.js"]
author = "kazu634"
images = ["ogp/2021-10-17-download-csv-from-yahoo-finance.webp"]
+++

日本のYahoo!では無料では取得できないそうなのですが、アメリカのYahoo.comでは日本企業の株価でもCSVで取得できるということで、どのようにすればダウンロードできるか確認してみました。

最終的には自動で株価データをデータベースに入れて、自動的に毎日グラフを更新できるようにするのが目標だよ。こんな感じね。

{{< tweet user="MusashiKazuhiro" id="1449329281771868167" >}}

## ブラウザから
一番簡単な方法としては、ブラウザからダウンロードします。例えばANAの場合は、[ANA HOLDINGS INC (9202.T) Stock Price, News, Quote & History - Yahoo Finance](https://finance.yahoo.com/quote/9202.T?p=9202.T&.tsrc=fin-srch)にアクセスするとページが表示されます。

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/51597962326/" title="Untitled"><img src="https://live.staticflickr.com/65535/51597962326_66909d2652_b.jpg" width="1024" height="680" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

Historical Dataの部分をクリックすると、

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/51598620109/in/photostream/" title="Untitled"><img src="https://live.staticflickr.com/65535/51598620109_2d8099570f_b.jpg" width="1024" height="680" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

過去の株価一覧が表示され、CSVへのダウンロードリンクもあります。

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/51598620114/in/photostream/" title="Untitled"><img src="https://live.staticflickr.com/65535/51598620114_04ea49674c_b.jpg" width="1024" height="686" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## コマンドラインからCSVをダウンロードする
ダウンロードリンクをそのままコピーすると`https://query1.finance.yahoo.com/v7/finance/download/9202.T?period1=1602852276&period2=1634388276&interval=1d&events=history&includeAdjustedClose=true`となりますが、ここから素直にダウンロードしようとすると、うまくダウンロードできません。

```bash
kazu634@digdag02% wget "https://query1.finance.yahoo.com/v7/finance/download/9202.T?period1=946944000&period2=1634083200&interval=1d&events=history&includeAdjustedClose=true"                                                                                --2021-10-16 21:47:53--  https://query1.finance.yahoo.com/v7/finance/download/9202.T?period1=946944000&period2=1634083200&interval=1d&events=history&includeAdjustedClose=true
query1.finance.yahoo.com (query1.finance.yahoo.com) をDNSに問いあわせています... 119.161.5.251, 119.161.5.252, 2406:6e00:108:fe06::2000, ...
query1.finance.yahoo.com (query1.finance.yahoo.com)|119.161.5.251|:443 に接続しています... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 403 Forbidden
2021-10-16 21:47:54 エラー 403: Forbidden。
```

ユーザーエージェントを指定してあげると、うまくダウンロードできました。

```bash
kazu634@digdag02% wget --user-agent="Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML, like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53" "https://query1.finance.yahoo.com/v7/finance/download/9202.T?period1=946944000&period2=1634083200&in5D"
--2021-10-16 21:46:51--  https://query1.finance.yahoo.com/v7/finance/download/9202.T?period1=946944000&period2=1634083200&in5D
query1.finance.yahoo.com (query1.finance.yahoo.com) をDNSに問いあわせています... 119.161.5.252, 119.161.5.251, 2406:2000:a4:9fe::, ...
query1.finance.yahoo.com (query1.finance.yahoo.com)|119.161.5.252|:443 に接続しています... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 200 OK
長さ: 特定できません [text/csv]
`9202.T?period1=946944000&period2=1634083200&in5D' に保存中

9202.T?period1=946944000&period     [  <=>                                                  ] 417.10K  1.42MB/s    in 0.3s

2021-10-16 21:46:52 (1.42 MB/s) - `9202.T?period1=946944000&period2=1634083200&in5D' へ保存終了 [427112]
```

## ダウンロードを自動化するスクリプトを作成してみました
渡してあげるパラメータは以下のようです:
- `ID`: 会社のID
- `期間 (開始)`:  期間の開始日時 (Unixタイムスタンプ)
- `期間 (終了)`:  期間の終了日時 (Unixタイムスタンプ)

その辺を考慮すると、以下のようにしてあげると自動的にダウンロードできそうです。

```bash
#!/bin/bash

set -e

BASE="https://query1.finance.yahoo.com/v7/finance/download/"
ID="9202.T"
PARAM1="?period1="
PARAM2="&period2="

PAST=`date --date '7 days ago' '+%s'`
CURRENT=`date '+%s'`

UA="Mozilla/5.0 (iPhone; CPU iPhone OS 7_0 like Mac OS X) AppleWebKit/537.51.1 (KHTML,  like Gecko) Version/7.0 Mobile/11A465 Safari/9537.53"

URL="${BASE}${ID}${PARAM1}${PAST}${PARAM2}${CURRENT}"

wget --user-agent="${UA}" -O ${CURRENT}.csv "${URL}"
```

## 次のステップ
ダウンロードまでは自動化できたので、DBに格納するところまで自動化してあげて、BIでお気軽に確認できるようにしようと思います。
