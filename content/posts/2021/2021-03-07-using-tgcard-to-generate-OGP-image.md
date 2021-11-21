+++
title = "tcardgenを利用したOGP画像の生成"
date = 2021-03-07T13:47:22+09:00
description = "tcardgenを利用して、OGP画像を生成してみました。"
categories = ["Blog"]
tags = ["hugo"]
author = "kazu634"
+++

「[Go製のtcardgenでHugoで作ったブログのOGPを自動生成してみた](https://qiita.com/BIwashi/items/26cf8a1c9c54f7c38614)」を見ると、hugoをOGP画像を自動生成するまとめ記事があったので、そちらを参照して試してみました。

基本は上の記事をなぞっていきます。

## 成果物
Twitterでの表示例はこちらになります。

{{< tweet 1366036262465900544 >}}

## やったこと
やったことを書き連ねていきますよ。

### tcardgenコマンドのインストール
「[GitHub - Ladicle/tcardgen: Generate a TwitterCard(OGP) image for your Hugo posts.](https://github.com/Ladicle/tcardgen)」を参照しながら、tcardgenコマンドをインストールします。

```bash
% go get github.com/Ladicle/tcardgen
```

### フォントのインストール
私は[HackGen](https://github.com/yuru7/HackGen)フォントを利用することにしました。以下のようにしてみました。

```bash
kazu634@bastion2004% wget https://github.com/yuru7/HackGen/releases/download/v2.3.0/HackGenNerd_v2.3.0.zip
--2021-03-07 14:00:32--  https://github.com/yuru7/HackGen/releases/download/v2.3.0/HackGenNerd_v2.3.0.zip
github.com (github.com) をDNSに問いあわせています... 52.69.186.44
github.com (github.com)|52.69.186.44|:443 に接続しています... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 302 Found
場所: https://github-releases.githubusercontent.com/187742770/307e0680-7e6e-11eb-9458-9a229737eb93?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210307%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210307T050032Z&X-Amz-Expires=300&X-Amz-Signature=2f4e8ae00818f60ffce2eb18eb96ff166e15eec47a6a01653e49e425cf6858b3&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=187742770&response-content-disposition=attachment%3B%20filename%3DHackGenNerd_v2.3.0.zip&response-content-type=application%2Foctet-stream [続く]
--2021-03-07 14:00:32--  https://github-releases.githubusercontent.com/187742770/307e0680-7e6e-11eb-9458-9a229737eb93?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210307%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20210307T050032Z&X-Amz-Expires=300&X-Amz-Signature=2f4e8ae00818f60ffce2eb18eb96ff166e15eec47a6a01653e49e425cf6858b3&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=187742770&response-content-disposition=attachment%3B%20filename%3DHackGenNerd_v2.3.0.zip&response-content-type=application%2Foctet-stream
github-releases.githubusercontent.com (github-releases.githubusercontent.com) をDNSに問いあわせています... 185.199.111.154, 185.199.109.154, 185.199.110.154, ...
github-releases.githubusercontent.com (github-releases.githubusercontent.com)|185.199.111.154|:443 に接続して
います... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 200 OK
長さ: 44009406 (42M) [application/octet-stream]
`HackGenNerd_v2.3.0.zip.3' に保存中

HackGenNerd_v2.3.0.zip.3    100%[========================================>]  41.97M  1.15MB/s    in 33s

2021-03-07 14:01:06 (1.26 MB/s) - `HackGenNerd_v2.3.0.zip.3' へ保存完了 [44009406/44009406]
kazu634@bastion2004% unzip HackGenNerd_v2.3.0.zip                                                     [/tmp]
Archive:  HackGenNerd_v2.3.0.zip
   creating: HackGenNerd_v2.3.0/
  inflating: HackGenNerd_v2.3.0/HackGen35Nerd-Bold.ttf
  inflating: HackGenNerd_v2.3.0/HackGen35Nerd-Regular.ttf
  inflating: HackGenNerd_v2.3.0/HackGen35NerdConsole-Bold.ttf
  inflating: HackGenNerd_v2.3.0/HackGen35NerdConsole-Regular.ttf
  inflating: HackGenNerd_v2.3.0/HackGenNerd-Bold.ttf
  inflating: HackGenNerd_v2.3.0/HackGenNerd-Regular.ttf
  inflating: HackGenNerd_v2.3.0/HackGenNerdConsole-Bold.ttf
  inflating: HackGenNerd_v2.3.0/HackGenNerdConsole-Regular.ttf
kazu634@bastion2004% cp HackGenNerd_v2.3.0/HackGen*.ttf ~/works/mnt/others/blog/assets/font/          [/tmp]
```

### テンプレートとなる背景画像の準備
[Affinity Designer for iPad](https://affinity.serif.com/en-us/designer/ipad/)を利用して、作成しました。tcardgenのレポジトリの`example`ディレクトリからサンプル画像を拝借させていただき、作成しました。

1. サンプル画像をレイヤーとして読み込み
2. その上から背景となる画像を適当に読み込み
3. その上から通知部分を示すボックスを適当に配置
4. その上からTwitterのアイコン画像を別なレイヤーとして配置

結果的に以下のような画像を作成してみました (1200x628):

![Image](https://farm66.staticflickr.com/65535/51010529153_62ac1706c3_c.jpg)

### tcardgenの設定ファイルについて
tcardgenのレポジトリの`example`ディレクトリに格納されているサンプル設定ファイルを参考に以下のように作成してみました:

```
template: assets/base.png
title:
  start:
    px: 113
    pY: 247
  fgHexColor: "#FFFFFF"
  fontSize: 65
  fontStyle: Bold
  maxWidth: 946
  lineSpacing: 10
category:
  start:
    px: 113
    py: 195
  fgHexColor: "#E5B52A"
  fontSize: 42
  fontStyle: Regular
info:
  start:
    px: 223
    py: 120
  fgHexColor: "#A0A0A0"
  fontSize: 38
  fontStyle: Regular
tags:
  start:
    px: 120
    py: 490
  fgHexColor: "#FFFFFF"
  bgHexColor: "#7F7776"
  fontSize: 22
  fontStyle: Regular
  boxAlign: Left
  boxSpacing: 6
  boxPadding:
    top: 6
    right: 10
    bottom: 6
    left: 8

```

### hugo記事の指定について
以下のようにしました:

```
+++
title = "緊急事態宣言が緩和しつつあるバンコクでのお食事をまとめます"
date = 2020-08-01T10:10:34+08:00
description = "緊急事態宣言が緩和されつつあるバンコクで、6/15〜に外でお食事した写真をまとめていますよ。"
categories = ["Misc"]
author = "kazu634"
tags = ["bangkok"]
```

*大文字小文字区別*で、以下の項目が必須でした:

- date
- categories
- author
- tags

`date`については、`2020-08-01T10:10:34+08:00`と言った形式でないと`tcardgen`コマンド実行時にエラーになりました。

既存の記事がたくさんあったので、この辺の訂正が大変でしたが、なんとか終わらせることができました。。

```bash
kazu634@bastion2004% tcardgen -f /home/kazu634/works/mnt/others/blog/assets/font/ -o ~/works/mnt/others/blog/static/ogp/ -c ~/works/mnt/others/blog/assets/tcardgen.yaml content/post/2020/08/01/2020-08-01-Bangkok-Restaurants.md
Load fonts from "/home/kazu634/works/mnt/others/blog/assets/font/"
Load template from "assets/base.png" directory
Success to generate twitter card into /home/kazu634/works/mnt/others/blog/static/ogp/2020-08-01-Bangkok-Restaurants.png
```

上のコマンドを実行すると、以下のような画像が表示されます。

![Image](https://farm66.staticflickr.com/65535/51011791732_410798acc7_c.jpg)

### PNG形式をwebp形式に変換する
tcardgenコマンドで生成したPNG画像は1ファイル1MB程度だったため、ファイルサイズが大きすぎと感じたので、webp形式に変換することにしました。webp形式への変換は`img2webp`コマンドを利用しました。

```
kazu634@bastion2004% img2webp -lossy -q 50 2020-08-01-Bangkok-Restaurants.png -o 2020-08-01-Bangkok-Restaurants.webp
output file: 2020-08-01-Bangkok-Restaurants.webp     [1 frames, 31206 bytes].

kazu634@bastion2004% ll *.png
-rw-rw-r-- 1 kazu634 kazu634 974K  3月  7 14:21 2020-08-01-Bangkok-Restaurants.png

kazu634@bastion2004% ll 2020-08-01-Bangkok-Restaurants.webp
-rw-rw-r-- 1 kazu634 kazu634 31K  3月  7 14:26 2020-08-01-Bangkok-Restaurants.webp
```

### 生成した画像を参照するようhugoのテンプレートを修正
こんな感じでhugoのpartialテンプレートを作成しました。

#### twitter_cards.html
```
<meta name="twitter:card" content="summary_large_image"/>
<meta name="twitter:image" content="{{ .Site.BaseURL }}ogp/{{ .File.BaseFileName }}.webp"/>
<meta name="twitter:title" content="{{ .Title }}"/>
<meta name="twitter:description" content="{{ with .Description }}{{ . }}{{ else }}{{if .IsPage}}{{ .Summary }}{{ else }}{{ with .Site.Params.description }}{{ . }}{{ end }}{{ end }}{{ end -}}"/>
<meta name="twitter:site" content="@MusashiKazuhiro"/>
<meta name="twitter:creator" content="@MusashiKazuhiro"/>
```

#### opengraph.html
```
<meta property="og:title" content="{{ .Title }}" />
<meta property="og:description" content="{{ with .Description }}{{ . }}{{ else }}{{if .IsPage}}{{ .Summary }}{{ else }}{{ with .Site.Params.description }}{{ . }}{{ end }}{{ end }}{{ end }}" />
<meta property="og:url" content="{{ .Permalink }}" />
<meta property="og:image" content="{{ .Site.BaseURL }}ogp/{{ .File.BaseFileName }}.webp"/>
<meta property="article:section" content="{{ .Section }}" />
<meta property="article:author" content="https://www.facebook.com/kazu634" />
<meta property="article:publisher" content="https://www.facebook.com/kazu634" />
```

#### 記事のヘッダーテンプレート
そして、以下のように作成したテンプレートを参照させます:

```
  <!-- OGP Settings
  –––––––––––––––––––––––––––––––––––––––––––––––––– -->
  <meta property="fb:app_id" content="NNNNNNNNNNNNNNNNN" />
  {{partial "opengraph.html" . }}
  {{partial "twitter_cards.html" . }}
```

## まとめ
以上のようにすると、OGP画像が生成されて、hugoの記事から生成されたOGP画像を紐づけることが出来ました。
