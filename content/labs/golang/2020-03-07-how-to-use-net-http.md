+++
title = "Golangのnet/httpでREST APIをたたくときのメモ"
date = 2020-03-07T21:12:22+08:00
description = "Golangの標準ライブラリnet/httpでREST APIをたたくときのメモです。"
Tags = []
Categories = ["golang", "programming"]
+++

Golang標準ライブラリの`net/http`でREST APIをたたく時に必要となりそうなことをまとめます。

## 基本のお作法
基本はこんな感じになります:

```
package main

import (
    "fmt"
    "io/ioutil"
    "net/http"
    "os"
    "time"
)

func main() {
    os.Exit(run(os.Args))
}

func run(args []string) int {
    // httpのクライアントを作成する
    client := &http.Client{}
    // タイムアウトの設定をしたほうがいいみたい
    client.Timeout = time.Second * 15

    // リクエストを作成
    req, err := http.NewRequest("POST", "ここにエンドポイントのURL",nil)
    if err != nil {
        return 1
    }

    // リクエストを実行
    resp, err := client.Do(req)
    if err != nil {
        return 2
    }
    defer resp.Body.Close()

    // レスポンスの読み込み
    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return 3
    }

    // レスポンスの表示
    fmt.Printf("%s", body)

    return 0
}
```

## その他トピック

### ヘッダーを追加したい
以下のように、生成した`HTTP Requst`オブジェクトにヘッダーを追加します:

```
    header := http.Header{}
    header.Set("Content-Length", "10000")
    header.Add("Content-Type", "application/json")
    header.Add("Authorization", "Basic anAxYWRtaW46anAxYWRtaW4=")

    req.Header = header
```

### HTTPリクエストボディーを指定したい
`http.NewRequest`で`HTTP Request`オブジェクト作成時の3番目の引数に指定します:

```
    req, err := http.NewRequest("POST", "ここにエンドポイントのURL", byte.NewBuffer(“foo”))
```

どうやら`byte`オブジェクトである必要があるみたい。

### HTTPリクエストボディーにJSONを指定したい
`encoding/json`の`json.Marshal`関数で`JSON`オブジェクトを作成し、`byte`オブジェクトに変換します。以下抜粋です:

```
type RequestBody struct {
    EventId string `json:"eventId"`
    Message string `json:"message"`
    Attrs   Attr   `json:"attrs"`
}

// ... snip ...

    attrs := Attr{
        Severity:       "Notice",
        JP1_SourceHost: "Localhost",
    }

    reqBody := RequestBody{
        EventId: "1FFF",
        Message: "test",
    }

    jsonValue, _ := json.Marshal(reqBody)

    req, err := http.NewRequest("POST", "ここにエンドポイントのURL", bytes.NewBuffer(jsonValue))
```

### HTTPレスポンスで受け取ったJSONを扱いたい
受け取るレスポンスに対応する構造体を定義して、`json.Unmarsha()`を利用します。[JSON-to-Go: Convert JSON to Go instantly](https://mholt.github.io/json-to-go/)を使うと幸せになれるよ。

```
type Response struct {
    Timestamp  int64  `json:"timestamp"`
    Status     int    `json:"status"`
    Error      string `json:"error"`
    Exception  string `json:"exception"`
    Message    string `json:"message"`
    Path       string `json:"path"`
    MessageID  string `json:"messageId"`
    ReturnCode int    `json:"returnCode"`
}

// ... snip ...

    body, err := ioutil.ReadAll(resp.Body)
    if err != nil {
        return 3
    }

    bytes := []byte(body)
    var response Response
    json.Unmarshal(bytes, &response)

    fmt.Printf("%d: %s", resp.StatusCode, response.Message)
```

## 参考
- [Go の net/httpでリクエストを投げるまでの足跡 - Qiita](https://qiita.com/takayukioda/items/68c51c5a0e9757a882ee)
- [JSON-to-Go: Convert JSON to Go instantly](https://mholt.github.io/json-to-go/)

