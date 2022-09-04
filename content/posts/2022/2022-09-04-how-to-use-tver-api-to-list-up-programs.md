+++
title = "TVerのAPIを利用してダウンロードできる番組を取得する"
date = 2022-09-04T21:27:43+09:00
description = "非公開のTVer APIを利用して公開されている番組リストを取得する方法をまとめてみました"
tags = ["tver"]
categories = ["プログラミング"]
author = "kazu634"
images = ["ogp/2022-09-04-how-to-use-tver-api-to-list-up-programs.webp"]
+++

「[TVerの新着番組をRSSで見る](https://blog.srytk.com/aquei/763.html)」を参考に粛々と`curl`で動作するか試してみました。これを利用すると、公開されている番組を1000件取得するみたいです。基本的には公開されていない方法のようなので、これを使ってマッシュアップサイトを作ったりするのはNGに見えます。。

<!--more-->

## トークン的なものを作成する
`https://platform-api.tver.jp/v2/api/platform_users/browser/create`にアクセスして、トークンを作成するようです:

```shell
% curl -w '\n' -H 'Accept: */*' -H 'Referer: https://s.tver.jp/' -H 'Origin: https://s.tver.jp' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Connection: keep-alive' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-site' 'https://platform-api.tver.jp/v2/api/platform_users/browser/create' --data 'device_type=pc' -XPOST | jq .
{
  "api_version": "v2",
  "code": 0,
  "message": "",
  "type": "hash",
  "result": {
    "platform_uid": "secret-secret-secret",
    "platform_ad_uuid": "secret-secret-secret",
    "platform_token": "secret-secret-secret",
    "browser_id": "r0xclt0f4bfo2t6e7pfcey08277hhw6reap9",
    "device_type": "pc",
    "agreement_version": ""
  }
}
```

返却されるのは、下の`json`形式のようです:

```json
{
  "api_version": "v2",
  "code": 0,
  "message": "",
  "type": "hash",
  "result": {
    "platform_uid": "secret-secret-secret",
    "platform_ad_uuid": "secret-secret-secret",
    "platform_token": "secret-secret-secret",
    "browser_id": "r0xclt0f4bfo2t6e7pfcey08277hhw6reap9",
    "device_type": "pc",
    "agreement_version": ""
  }
}
```

## 番組情報を取得する
一つ前で取得した以下の情報を利用します:

- `platform_uid`
- `platform_token`

こんなコマンドを実行するといいです:

```shell
% curl -w '\n' 'https://platform-api.tver.jp/service/api/v1/callSearch?platform_uid=secret-secret-secret&platform_token=secret-secret-secret&require_data=later' -H 'x-tver-platform-type: web' | jq .
```

結果はこんな`json`で返ってきます:

```json
{
        "type": "episode",
        "content": {
          "id": "epp7y4r9mc",
          "version": 5,
          "title": "【コント傑作選】初登場３組が参戦！後藤と濱家が慕う“ねえさん”なるみが厳しく後輩たちのネタをジャッジ！",
          "endAt": 1662303540,
          "broadcastDateLabel": "5月21日(土)放送分",
          "isNHKContent": false,
          "isSubtitle": false,
          "ribbonID": 0,
          "seriesTitle": "防犯カメラが捉えた！衝撃コント映像",
          "isAvailable": true,
          "broadcasterName": "ABCテレビ",
          "productionProviderName": "ABCテレビ"
        },
        "isLater": false,
        "favoriteCount": 26081,
        "endAt": 1662303540,
        "tags": [
          {
            "id": "abc",
            "name": "ABCテレビ"
          },
          {
            "id": "exnetwork",
            "name": "テレビ朝日系"
          },
          {
            "id": "owarai",
            "name": "お笑い・漫才・コント"
          },
          {
            "id": "sat",
            "name": "土"
          },
          {
            "id": "talk",
            "name": "トーク・スタジオバラエティ"
          },
          {
            "id": "variety",
            "name": "バラエティ"
          },
          {
            "id": "vtr",
            "name": "VTR・ロケ番組"
          }
        ]
}
```

具体的な検索キーワードがある場合には、「&keyword=ワンピース」みたいな形でURLに追加してあげるとOKのようです。

## 最後に
これと[yt-dlp: A youtube-dl fork with additional features and fixes](https://github.com/yt-dlp/yt-dlp)を組み合わせると、[TVer](https://tver.jp/)で公開されている番組をさくっとダウンロードできる仕組み作りできるのでは。。

## 参考
- [TVerの新着番組をRSSで見る – 阿Qさんと一緒](https://blog.srytk.com/aquei/763.html)
- [GitHub \- yt\-dlp/yt\-dlp: A youtube\-dl fork with additional features and fixes](https://github.com/yt-dlp/yt-dlp)
- [TVer \- 無料で動画見放題](https://tver.jp/)
