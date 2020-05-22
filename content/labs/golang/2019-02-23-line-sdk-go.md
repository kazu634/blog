+++
title = "GolangでLine APIをいじくるよ"
date = 2019-03-03T19:12:22+08:00
Description = "GolangでLine APIを利用してみましたよ。"
Tags = []
Categories = ["golang", "programming"]
images = ["https://farm9.staticflickr.com/8462/29581774242_bf25a0a820_z.jpg"]
+++

# GolangでLine APIをいじくる
`Golang`で`Line` APIを用いたボット作成をしてみます。

## 説明すること・しないこと
この記事ではLine Messaging APIを使って、どんなメッセージを送信できるかを説明します。

どうすればボット作成環境を構築するかなどは説明しません。参考リンクなど確認ください。

## 簡単な説明
下の図のLineBotServerの部分を作り込みます:

{{<mermaid align="center">}}
sequenceDiagram
  User->>Line: Some Action(s)
  Line->>LineBotServer: Make HTTP Request
  alt Bad Request
    Note over LineBotServer: Do nothing
  else Proper Request
    LineBotServer->>LineBotServer: Do something
    LineBotServer->>Line: Make HTTP Request, using REST API
    Line->>User: Show some message(s) as Reply
  end
{{< /mermaid >}}

## Line Developerに登録する
[お金をかけずにLINEのMessaging APIの投稿(push)と返信(replay)を試してみる。 | ポンコツエンジニアのごじゃっぺ開発日記。](https://blog.pnkts.net/2018/06/03/line-messaging-api/)に書いてある通りに進めます。

## とりあえず動作させてみます
送信できるメッセージの種類ごとにテストしてみます。

### テキストメッセージ
“text”とメッセージ送信したら、”text”と返信するようにしてみました。

![text message](https://farm8.staticflickr.com/7891/46350633365_4e30224e64.jpg)

### 画像メッセージ
“image”とメッセージ送信したら、画像を投稿するようにしてみました。

![image message](https://farm8.staticflickr.com/7819/33389330058_05399428bd.jpg)

### スタンプメッセージ
“sticker”とメッセージ送信したら、スタンプを投稿するようにしてみました。送信できるステッカーは[Line Botで送信できるSticker一覧 (PDF)](https://developers.line.biz/media/messaging-api/sticker_list.pdf)から確認できます:

![sticker message](https://farm8.staticflickr.com/7807/40300515403_5993c84e2a.jpg)

### 位置情報メッセージ
“location”とメッセージ送信したら、地図情報を投稿するようにしてみました:

![location message](https://farm8.staticflickr.com/7918/46350633335_f2e7ecda53.jpg)

### テンプレートメッセージ
画像やボタンなどを組み合わせたメッセージです。

#### ボタンテンプレート
こんな感じのメッセージになります:

![button-template message](https://farm8.staticflickr.com/7808/33389330098_48880e1512.jpg)

#### 確認テンプレート
確認を行うダイアログ？的なメッセージになります:

![confirm message](https://farm8.staticflickr.com/7880/40300515423_e471e9de20.jpg)

#### カルーセルテンプレート
横方向にテンプレートメッセージを並べたメッセージです。こんな感じになります:

![carousel message](https://farm8.staticflickr.com/7870/47213297182_fab28aa76e.jpg)

### Flexメッセージ
テンプレートメッセージのレイアウトを自由に調整できるみたいなのですが、サンプルしか触っていないため、ちょっとよくわかっていないです。こんな感じになりました:

![flex message](https://farm8.staticflickr.com/7912/40300515343_910467fd1e.jpg)

もっとレイアウトにこったサンプルがあればいいのですが。。。

### クイックレスポンスメッセージ
メッセージ送信と同時に、簡単な選択肢を提示して、選択してもらうことができるようです:

![quick response message](https://farm8.staticflickr.com/7887/46350633325_0398b4f65c.jpg)

位置情報の送信、カメラ起動、カメラロールから画像選択などもできるみたい。上の例だと、右端のリンクをクリックすると、位置情報の送信画面になります。

### その他 (ボタンをクリックするとできること)
テンプレートメッセージやFlexメッセージでボタンを配置してできることは、以下のようです。

#### Postback action
Botのcallback URLに対して、データをPOSTリクエストで送信するようです。

#### Message action
選択したボタンに割り当てたメッセージをLine上で送信するみたいです。

#### URI action
選択したボタンに割り当てたURLをLineのブラウザで開くようです。

#### Datetime picker action
日付選択用の画面が出てきます。

![date and time picker example](https://farm8.staticflickr.com/7897/33389330108_8d940922b1.jpg)

#### Camera action
クイックレスポンスの時にのみ利用できるアクションのようです。カメラが起動します。

#### Camera roll action
クイックレスポンスの時にのみ利用できるアクションのようです。カメラロールが開いて、画像を選択できるようです。

#### Location action
クイックレスポンスの時にのみ利用できるアクションのようです。位置情報の画面が出てくるようです。

## コード
```go
package main

import (
        "log"
        "net/http"
        "os"
        "time"

        "github.com/jinzhu/gorm"
        _ "github.com/jinzhu/gorm/dialects/mysql"
        "github.com/line/line-bot-sdk-go/linebot"
)

const (
        userStatusAvailable    string = "available"
        userStatusNotAvailable string = "not_available"
)

type user struct {
        Id         string `gorm:"primary_key"`
        IdType     string
        Timestamp  time.Time `gorm:"not null;type:datetime"`
        ReplyToken string
        Status     string
}

func gormConnect() *gorm.DB {
        DBMS := "mysql"
        USER := "root"
        PASS := "Holiday88"
        PROTOCOL := "tcp(192.168.10.200:3307)"
        DBNAME := "LineBot"

        CONNECT := USER + ":" + PASS + "@" + PROTOCOL + "/" + DBNAME + "?parseTime=true&loc=Asia%2FTokyo"
        db, err := gorm.Open(DBMS, CONNECT)

        if err != nil {
                log.Fatal(err.Error())
        }
        return db
}

func main() {
        bot, err := linebot.New(
                os.Getenv("CHANNEL_SECRET"),
                os.Getenv("CHANNEL_TOKEN"),
        )
        if err != nil {
                log.Fatal(err)
        }

        // Setup HTTP Server for receiving requests from LINE platform
        http.HandleFunc("/callback", func(w http.ResponseWriter, req *http.Request) {
                events, err := bot.ParseRequest(req)
                if err != nil {
                        if err == linebot.ErrInvalidSignature {
                                w.WriteHeader(400)
                        } else {
                                w.WriteHeader(500)
                        }
                        return
                }

                for _, event := range events {
                        switch event.Type {
                        case linebot.EventTypeFollow:
                                // db instance
                                db := gormConnect()
                                defer db.Close()

                                userData := user{Id: event.Source.UserID,
                                        IdType:     string(event.Source.Type),
                                        Timestamp:  event.Timestamp,
                                        ReplyToken: event.ReplyToken,
                                        Status:     userStatusAvailable,
                                }
                                err := db.Where(user{Id: event.Source.UserID}).Assign(&userData).FirstOrCreate(&user{})
                                log.Println(err)

                        case linebot.EventTypeUnfollow:
                                log.Println("Unfollow Event: " + event.Source.UserID)
                                log.Println(event)

                                // db instance
                                db := gormConnect()
                                defer db.Close()

                                userData := user{Id: event.Source.UserID,
                                        IdType:     string(event.Source.Type),
                                        Timestamp:  event.Timestamp,
                                        ReplyToken: event.ReplyToken,
                                        Status:     userStatusNotAvailable,
                                }

                                err := db.Where(user{Id: event.Source.UserID}).Assign(&userData).FirstOrCreate(&user{})
                                log.Println(err)

                        case linebot.EventTypeMessage:
                                log.Println(event)
                                switch message := event.Message.(type) {
                                case *linebot.TextMessage:
                                        switch message.Text {
                                        case "text":
                                                resp := linebot.NewTextMessage(message.Text)

                                                _, err := bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "sticker":
                                                resp := linebot.NewStickerMessage("3", "230")

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "location":
                                                resp := linebot.NewLocationMessage("現在地", "宮城県多賀城市", 38.297807, 141.031)

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "image":
                                                resp := linebot.NewImageMessage("https://farm5.staticflickr.com/4849/45718165635_328355a940_m.jpg", "https://farm5.staticflickr.com/4849/45718165635_328355a940_m.jpg")

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "buttontemplate":
                                                resp := linebot.NewTemplateMessage(
                                                        "this is a buttons template",
                                                        linebot.NewButtonsTemplate(
                                                                "https://farm5.staticflickr.com/4849/45718165635_328355a940_m.jpg",
                                                                "Menu",
                                                                "Please select",
                                                                linebot.NewPostbackAction("Buy", "action=buy&itemid=123", "", "displayText"),
                                                                linebot.NewPostbackAction("Buy", "action=buy&itemid=123", "text", ""),
                                                                linebot.NewURIAction("View detail", "http://example.com/page/123"),
                                                        ),
                                                )

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "datetimepicker":
                                                resp := linebot.NewTemplateMessage(
                                                        "this is a buttons template",
                                                        linebot.NewButtonsTemplate(
                                                                "https://farm5.staticflickr.com/4849/45718165635_328355a940_m.jpg",
                                                                "Menu",
                                                                "Please select a date,  time or datetime",
                                                                linebot.NewDatetimePickerAction("Date", "action=sel&only=date", "date", "2017-09-01", "2017-09-03", ""),
                                                                linebot.NewDatetimePickerAction("Time", "action=sel&only=time", "time", "", "23:59", "00:00"),
                                                                linebot.NewDatetimePickerAction("DateTime", "action=sel", "datetime", "2017-09-01T12:00", "", ""),
                                                        ),
                                                )

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "confirm":
                                                resp := linebot.NewTemplateMessage(
                                                        "this is a confirm template",
                                                        linebot.NewConfirmTemplate(
                                                                "Are you sure?",
                                                                linebot.NewMessageAction("Yes", "yes"),
                                                                linebot.NewMessageAction("No", "no"),
                                                        ),
                                                )

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "carousel":
                                                resp := linebot.NewTemplateMessage(
                                                        "this is a carousel template with imageAspectRatio,  imageSize and imageBackgroundColor",
                                                        linebot.NewCarouselTemplate(
                                                                linebot.NewCarouselColumn(
                                                                        "https://farm5.staticflickr.com/4849/45718165635_328355a940_m.jpg",
                                                                        "this is menu",
                                                                        "description",
                                                                        linebot.NewPostbackAction("Buy", "action=buy&itemid=111", "", ""),
                                                                        linebot.NewPostbackAction("Add to cart", "action=add&itemid=111", "", ""),
                                                                        linebot.NewURIAction("View detail", "http://example.com/page/111"),
                                                                ).WithImageOptions("#FFFFFF"),
                                                                linebot.NewCarouselColumn(
                                                                        "https://farm5.staticflickr.com/4849/45718165635_328355a940_m.jpg",
                                                                        "this is menu",
                                                                        "description",
                                                                        linebot.NewPostbackAction("Buy", "action=buy&itemid=111", "", ""),
                                                                        linebot.NewPostbackAction("Add to cart", "action=add&itemid=111", "", ""),
                                                                        linebot.NewURIAction("View detail", "http://example.com/page/111"),
                                                                ).WithImageOptions("#FFFFFF"),
                                                        ).WithImageOptions("rectangle", "cover"),
                                                )
                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "flex":
                                                resp := linebot.NewFlexMessage(
                                                        "this is a flex message",
                                                        &linebot.BubbleContainer{
                                                                Type: linebot.FlexContainerTypeBubble,
                                                                Body: &linebot.BoxComponent{
                                                                        Type:   linebot.FlexComponentTypeBox,
                                                                        Layout: linebot.FlexBoxLayoutTypeVertical,
                                                                        Contents: []linebot.FlexComponent{
                                                                                &linebot.TextComponent{
                                                                                        Type: linebot.FlexComponentTypeText,
                                                                                        Text: "hello",
                                                                                },
                                                                                &linebot.TextComponent{
                                                                                        Type: linebot.FlexComponentTypeText,
                                                                                        Text: "world",
                                                                                },
                                                                        },
                                                                },
                                                        },
                                                )

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        case "quickresponse":
                                                resp := linebot.NewTextMessage(
                                                        "Select your favorite food category or send me your location!",
                                                ).WithQuickReplies(
                                                        linebot.NewQuickReplyItems(
                                                                linebot.NewQuickReplyButton("https://example.com/sushi.png", linebot.NewMessageAction("Sushi", "Sushi")),
                                                                linebot.NewQuickReplyButton("https://example.com/tempura.png", linebot.NewMessageAction("Tempura", "Tempura")),
                                                                linebot.NewQuickReplyButton("", linebot.NewLocationAction("Send location")),
                                                        ),
                                                )

                                                _, err = bot.ReplyMessage(event.ReplyToken, resp).Do()
                                                if err != nil {
                                                        log.Print(err)
                                                }
                                        }
                                }
                        }
                }
        })

        if err := http.ListenAndServe(":"+os.Getenv("PORT"), nil); err != nil {
                log.Fatal(err)
        }
}
```

## 参考
- [お金をかけずにLINEのMessaging APIの投稿(push)と返信(replay)を試してみる。 | ポンコツエンジニアのごじゃっぺ開発日記。](https://blog.pnkts.net/2018/06/03/line-messaging-api/)
- [Line Botで送信できるSticker一覧 (PDF)](https://developers.line.biz/media/messaging-api/sticker_list.pdf)
- [LINE Messaging APIのテンプレートメッセージをまとめてみる ｜ DevelopersIO](https://dev.classmethod.jp/etc/line-messaging-api/)
- [LINE Messaging APIのテンプレートメッセージをまとめてみる（アクションオブジェクト編） ｜ DevelopersIO](https://dev.classmethod.jp/etc/line-messaging-api-action-object/)
- [LINE Messaging APIとは？～Flex Messageやクイックリプライ等の新機能追加でより柔軟なメッセージ配信が可能に - Feedmatic Blog](https://blog.feedmatic.net/entry/LINE/20180809/about-Messaging-API)
- [Using quick replies](https://developers.line.biz/en/docs/messaging-api/using-quick-reply/)
- [毎朝 天気を通知する LINE Bot を作ってみました。 - hawk, camphora, avocado and so on..](http://takagusu.hateblo.jp/entry/2017/01/24/200453)
- [【LINE Botの作り方】Python × Messaging APIでプッシュ通知を行うボットを作ろう | TAKEIHO](https://www.takeiho.com/line-bot-push)
- [LINE Messaging API を使ってLINEにメッセージ送信／メッセージ返信する - Qiita](https://qiita.com/fkooo/items/d07a7b717e120e661093)


