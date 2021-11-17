+++
title = "nexmo APIの使い方"
date = 2020-02-09T03:12:22+08:00
description = "nexmo APIの使い方のメモ書きです"
tags = ["Golang"]
categories = ["プログラミング"]
author = "kazu634"
+++

SMS送信などができるWebサービス、nexmo APIの使い方をまとめます。基本は参考URLからのコピペです。。

## API利用例
利用例はこんな感じです。

### Golangの場合

```
package main

import (
    "net/http"
    "net/url"
    "log"
    "fmt"
)

func main(){
    value := url.Values{}
    value.Set("from", "Nexmo")
    value.Add("text", "Hello from Nexmo dayoneeee")
    value.Add("to", "6692346nnnn")
    value.Add("api_key", "APIKEY")
    value.Add("api_secret", "APISecret")

    resp, err := http.PostForm("https://rest.nexmo.com/sms/json",value)
    if err != nil{
        log.Fatal(err)
    }

    buffer := make([]byte,1024)
    respLen,_ := resp.Body.Read(buffer)

    body := string(buffer[:respLen])

    fmt.Println(body)
    fmt.Println(resp.Status)

    defer resp.Body.Close()
}
```

#### 実行例
実行すると以下のように表示されるはずです:

```
kazu634@bastion% go run main.go
{
    "message-count": "1",
    "messages": [{
        "to": "6692346nnnn",
        "message-id": "1B00000052CEFF69",
        "status": "0",
        "remaining-balance": "1.88400000",
        "message-price": "0.02300000",
        "network": "52001"
    }]
}
200 OK
```

受信した様子がこちら:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49473392312/" title="Nexmo"><img src="https://live.staticflickr.com/65535/49473392312_dc327e0937_z.jpg" width="296" height="640" alt="Nexmo"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## curlの場合
`curl`コマンドで実行する場合は、こんな感じになります:

```
curl -X "POST" "https://rest.nexmo.com/sms/json" \
     -d "from=Nexmo" \
     -d "text=Hello from Nexmo" \
     -d "to=81906490nnnn" \
     -d "api_key=APIKEY" \
     -d "api_secret=APISECRET"
```

## 参考
- [GolangでAPI使ってSMS送信 - Qiita](https://qiita.com/KokiAsano/items/fffa3c64a1599ffc53ed)
