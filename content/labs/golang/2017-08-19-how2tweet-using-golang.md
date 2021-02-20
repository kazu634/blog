+++
title = "GolangでTwitterに投稿する方法"
date = 2017-08-19T23:02:35+08:00
description = "Golangを利用してTwitterにツイートする方法を調べました。"
Tags = []
Categories = ["Golang"]
draft = false
images = ["https://farm5.staticflickr.com/4441/36623773886_ef58e32e8e.jpg"]
+++

簡単なWeb APIサーバを`golang`で作ることをもくろんでいて、その一環で現在`golang`で`Twitter`に投稿する方法を調べています。調べた結果をシェアします:

## 利用するライブラリ
[TwitterはGoでゴー。 \- Qiita](http://qiita.com/konojunya/items/d51672f900f4912a5563)を参考にすると、`github.com/ChimeraCoder/anaconda`というのがいいみたい。

## ソース
上記の参考サイトを参照しながら作ったのがこちらになります:

```
package main

import (
        "fmt"
        "github.com/ChimeraCoder/anaconda"
        "os"
)

func GetTwitterApi() *anaconda.TwitterApi {
        anaconda.SetConsumerKey(os.Getenv("TWITTER_CONSUMER_KEY"))
        anaconda.SetConsumerSecret(os.Getenv("TWITTER_CONSUMER_SECRET"))
        api := anaconda.NewTwitterApi(os.Getenv("TWITTER_ACCESS_TOKEN"), os.Getenv("TWITTER_ACCESS_TOKEN_SECRET"))
        return api
}
func main() {
        api := GetTwitterApi()

        text := "Hellow World"

        tweet, err := api.PostTweet(text, nil)
        if err != nil {
                panic(err)

                fmt.Print(tweet.Text)
        }
}
```

## 結果
![Kazuhiro MUSASHI  kazu634 さん   Twitte](https://farm5.staticflickr.com/4441/36623773886_ef58e32e8e.jpg)
