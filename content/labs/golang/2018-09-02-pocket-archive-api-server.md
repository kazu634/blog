+++
images = ["images/5691141369_0eb8199f37_z.jpg"]
tags = ["Golang"]
categories = ["Labs", "Program"]
author = "kazu634"
date = "2018-09-02T18:40:47+09:00"
title = "APIサーバを作ってみた: Pocketの記事をアーカイブするよ"
description = "GolangでPocketの記事をアーカイブするAPIサーバを作ってみました。"
+++

`Golang`で[Pocket](https://getpocket.com/)の記事をアーカイブするAPIサーバを作ってみました。

## 困っていたこと
通勤中などにiPhoneで読んでいて気になった記事は、一度[Pocket](https://getpocket.com/)に
ブックマークすることにしています。その後は、[Workflow](https://workflow.is/)を用いて色々と行なっています。

ここで困ったことに気づきました。その色々行なった後に[Pocket](https://getpocket.com/)に登録した記事をアーカイブしたいのですが、[Workflow](https://workflow.is/)からは[Pocket](https://getpocket.com/)の記事をアーカイブできませんでした。。。

ただ、[Workflow](https://workflow.is/)からは任意のHTTPリクエストを送信できることに気づいたので、簡単なAPIサーバを立てて、[Pocket](https://getpocket.com/)の記事をアーカイブすることとしました。

## 検討したこと
色々と検討したことのまとめです。

### 言語選定
お仕事柄色々なOSに触る機会があるので、お手軽に各種OSのバイナリが生成できる`Golang`で作成して、習熟することにしました。

### ライブラリ
ウェブサーバのライブラリには、[gin](https://github.com/gin-gonic/gin)を使って見ることにしました。こちらはお仕事で、HTTPリクエストを受け取るためのモックWebサーバを立てる時にお世話になったので。

また、[Pocket](https://getpocket.com/)用のライブラリは、[go-pocket](https://github.com/motemen/go-pocket)を使うこととしました。

## 書いてみた
とりあえず書いてみます！APIサーバは、2つの部分からなります:

1. HTTPリクエストを受け付ける、ウェブサーバの部分
2. HTTPリクエストに応じて、実際の処理を行う部分

ひとつずつ進めていきます:

### ウェブサーバ部分
ウェブサーバ部分は[gin](https://github.com/gin-gonic/gin)を用いているので、こんな感じで書けるみたいです:

```
package main

import (
    "os"
    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()

    // http://localhost:8080/delete で HTTP POSTリクエストを受け付けるよ
    r.POST("/archive", func(c *gin.Context) {
        // POSTリクエストに付随するフォームデータからデータを取得するよ
        auth := c.PostForm("auth") // authからデータ取得
        url := c.PostForm("url") // urlからデータ取得

        // authで送られてきたデータが”password”だったら
        if auth == "password" {
            // レスポンスとしてステータスコード200とJSONを返す
            c.JSON(200, gin.H{
                "auth": auth,
                "url": url,
            })
        // authが”password”でなければ
        } else {
            // ステータスコード401を返すよ
            c.String(401, "Specify the proper credential!")
        }
    })

    // ウェブサーバを起動するよ。ポートは8080がデフォルト
    r.Run() // listen and serve on 0.0.0.0:8080

    return 0
}
```

ここでは`http://localhost:8080/archive/`でHTTP POST`リクエストを受け付け、フォームのデータに以下2つのデータを受け取ることにしました:

1. 認証用の情報 (= `auth`)
2. URLの情報 (= `url`)

自分しか使う人がいないとは思うのですが、最終的にはインターネット上に公開することを考えて、認証用の情報が`password`でなければ、HTTPステータスコード401を返すことにしました。

### 実際の処理を行う部分
[go-pocket](https://github.com/motemen/go-pocket)の使い方を読み解いていって、以下のような順番で考えていけば良さそうという結論になりました:

1. `Pocket`クライアントの作成
2. URLに一致する記事IDの特定
3. 特定した記事IDの記事をアーカイブスる

最終的にはこうなりました:

```
package main

import (
    "fmt"
    "strings"

    "github.com/motemen/go-pocket/api"
    //    "github.com/motemen/go-pocket/auth"
)

func main() {
    // Pocket用のクライアントを作成
    client := makeClient()

    // 検索したいURLをpocketに問い合わせて、idsに格納する
    // idsはチャネルになっていて、Goroutineで非同期に発見した記事IDが追加される
    ids := searchArticleByURL(client, "検索したいURL")

    // idsから記事IDをひとつずつ取り出して
    for id := range ids {
        fmt.Println(id)
        // 記事をアーカイブする
        archiveArticle(client, id)
    }
}

// クライアントを作成する関数
func makeClient() *api.Client {
    // ここは各自のものに書き換えてね
    consumerKey := "こんしゅーまーきー"
    accessToken := "あくせすとーくん"

    return api.NewClient(consumerKey, accessToken)
}

// 与えられたURLをPocketの記事一覧から検索して、記事IDを返す関数
func searchArticleByURL(client *api.Client, url string) chan int {
    // 結果を格納用
    ids := make(chan int)

    // Goroutineを用いて非同期でPocketにアクセスする
    go func() {
        // 検索オプションを指定するわけじゃないけど、形式上必須みたいなので。。。
        options := &api.RetrieveOption{}

        // 検索を実施します
        res, err := client.Retrieve(options)
        if err != nil {
            panic(err)
        }

        // 取得結果格納用の配列を初期化するよ
        items := []api.Item{}
        // 検索結果をitemsに格納するよ
        for _, item := range res.List {
            items = append(items, item)
        }

        // 検索結果を格納したitemsをひとつずつ確認するよ
        for _, item := range items {
            // 記事のURLが引数で指定された slug と等しかったら
            if strings.Contains(item.URL(), url) {
                // ids に記事IDを格納するよ
                ids <- item.ItemID
            }
        }
        // ここでチャネルをクローズするよ
        close(ids)
    }()

    // 結果を返却するよ
    return ids
}

// Pocketの記事をアーカイブするよ
func archiveArticle(client *api.Client, id int) {
    // まずはアクションというオブジェクト？を生成する必要があるみたい
    action := api.NewArchiveAction(id)
    // アーカイブを実行します
    res, err := client.Modify(action)

    fmt.Println(res, err)
}
```

### まとめてみた
ウェブサーバ側で処理を行うにあたって、複数のリクエストが来た際にひとつずつ順番に実行して処理が遅れることがないように、リクエストを受けつたら即座にステータスコード200をレスポンスとして返すことにしました。

その後、

1. 非同期で[Pocket](https://getpocket.com/)から記事の検索を行う
2. 非同期で[Pocket](https://getpocket.com/)の記事をアーカイブする

といった流れにしました。これで処理がブロックすることはないはず。各々の処理で`Goroutine`と`channel`を使ってみました。その結果、こうなりました:


```
package main

import (
    "log"
    "os"
    "strings"

    "github.com/gin-gonic/gin"
    "github.com/motemen/go-pocket/api"
)

func main() {
    // pocketクライアントの作成:
    client := makeClient()

    // チャネルの作成
    urls := make(chan string, 10) // 検索用URL投入用
    ids := make(chan int, 10)      // 削除対象ID投入用

    //検索URLを受けて、該当記事を検索し、記事IDをチャネルに投入する
    go func(client *api.Client) {
        for url := range urls {
            log.Printf("Search Keyword: %s\n", slug)

            options := &api.RetrieveOption{}

            res, err := client.Retrieve(options)
            if err != nil {
                log.Println(err)
            }

            items := []api.Item{}
            for _, item := range res.List {
                items = append(items, item)
            }

            for _, item := range items {
                if strings.Contains(item.URL(), slug) {
                    log.Printf("Found %s (article ID: %d)", item.URL(), item.ItemID)
                    ids <- item.ItemID
                }
            }
        }
    }(client)

    // 記事IDをもとに、記事をアーカイブする
    go func(client *api.Client) {
        for id := range ids {
            action := api.NewArchiveAction(id)
            _, err := client.Modify(action)

            if err != nil {
                log.Printf("Archive failed [%d]\n", id)
                // アーカイブできなかったらリトライのために、再度記事IDをidsに投入する！
                ids <- id
            } else {
                log.Printf("Successfully archived [%d]\n", id)
            }
        }
    }(client)

    // gin: webサーバの準備
    r := gin.Default()

    r.POST("/delete", func(c *gin.Context) {
        auth := c.PostForm("auth")
        url := c.PostForm("url")

        if auth == "password" {
            urls <- url

            c.JSON(200, gin.H{
                "auth": auth,
                "url":  url,
            })

        } else {
            c.String(401, "Specify the proper credential!")
        }
    })

    r.Run() // listen and serve on 0.0.0.0:8080 by default.

    return 0
}

func makeClient() *api.Client {
    consumerKey := "こんしゅーまーきー"
    accessToken := "あくせすとーくん"

    return api.NewClient(consumerKey, accessToken)
}
```


## まとめ
URLを送信することで、[Pocket](https://getpocket.com/)の記事をアーカイブするAPIサーバを作ることができました。

また、巷で流行っている`FaaS (Function as a Service)`で何をやろうとしているのか、おぼろげながら理解できました。いまのところの理解では、

- APIサーバのエンドポイントへのルーティングとか認証とかは、マネージドでサービスとして提供するよ (= 今回のウェブサーバの部分)
- エンドポイントにアクセスがあった場合の処理を記述してね (= 今回の実際の処理の部分)

といった形で責任を分担して、処理の記述に集中できるというのがメリットなんだろうなぁ…と思ったり思わなかったり。
