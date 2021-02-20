+++
title = "MetabaseでGeojsonを用いたカスタムマップを利用する"
date = 2020-03-01T09:15:53+08:00
description = "オープンソースのお手軽BIツール・Metabaseで自分で作成した白地図上にデータを可視化できるようになっていたようなので、試してみました"
Tags = []
Categories = ["Tools", "Metabase"]
images = ["images/41603208672_984110305c_z.jpg"]
+++

オープンソースのBIツール・[Metabase](https://github.com/metabase/metabase)をアップグレードしたところ、Geojsonを用いて、自分で用意した地図上にデータの可視化ができるようになっていました。

楽しそうだったので、東南アジアのGeojsonを作成して、データの可視化にチャレンジしてみました。

## Geojsonとは
[GeoJSON - Wikipedia](https://ja.wikipedia.org/wiki/GeoJSON)によると、以下のような説明がなされています:

> **GeoJSON**[1]は [JavaScript Object Notation](https://ja.m.wikipedia.org/wiki/JavaScript_Object_Notation)  (JSON) を用いて空間データをエンコードし非空間属性を関連付ける [ファイルフォーマット](https://ja.m.wikipedia.org/wiki/%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%83%95%E3%82%A9%E3%83%BC%E3%83%9E%E3%83%83%E3%83%88) である。 属性にはポイント（住所や座標）、ライン（各種道路や境界線）、 ポリゴン（国や地域）などが含まれる。

要するに、緯度・経度情報をまとめて、地図上に図形を描画する元データ…みたいなものと思っていただければいいかと思います。この緯度・経度情報に国境の情報を入れてあげれば、任意の地域の白地図を作成できます。

## Geojsonの作成
元となるGeojsonデータはGoogleで検索すると、たくさん出てきます。これをいじくり、作成してみました。[Gist](https://gist.github.com/kazu634/0894e86b52340aa677dd2ebb63acd553)に貼り付けてあります。

工夫した点としては、[Metabase](https://github.com/metabase/metabase)から参照できるように、プロパティとして以下を指定しています:

- name: 国名
- short: 国名の短い名前。こことデータベースのカラムで指定された国名コードが一致してたら、地図上にプロットされる

[Gist](https://gist.github.com/kazu634/0894e86b52340aa677dd2ebb63acd553)にGeojsonを貼り付けると、自動的に地図上に表示してくれます。私の場合はこのようになりました:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49600167212/in/dateposted-public/" title="Screenshot 2020-02-29 at 8.42.47 PM"><img src="https://live.staticflickr.com/65535/49600167212_728597d7f9_z.jpg" width="640" height="357" alt="Screenshot 2020-02-29 at 8.42.47 PM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

個人的な都合で、東南アジア各国だけでなく、インドと台湾も含めております。また、シンガポールは点にしか過ぎなくなるため、ベトナムとフィリピンとマレーシアの間の領域をシンガポールとしました。

## Metabaseでの設定
[Metabase](https://github.com/metabase/metabase)での設定方法を説明します。

### 地図の登録
以下のように指定してあげます。まずは[Metabase](https://github.com/metabase/metabase)の管理画面を表示させます:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49603176822/in/dateposted-public/" title="Untitled"><img src="https://live.staticflickr.com/65535/49603176822_673946f0ee_z.jpg" width="452" height="640" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

以下の画面が表示されるので、左側のメニューから`Maps`をクリックし、表示される画面から`Add a map`をクリックします:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49603176977/in/dateposted-public/" title="Untitled"><img src="https://live.staticflickr.com/65535/49603176977_fc000ed6e7_z.jpg" width="640" height="447" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

そうすると以下のような画面が表示されます:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49602412843/in/dateposted-public/" title="Untitled"><img src="https://live.staticflickr.com/65535/49602412843_bc1f27aa49_z.jpg" width="640" height="447" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

必要事項を入力していきます:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49600117502/in/dateposted-public/" title="Screenshot 2020-02-29 at 8.26.42 PM"><img src="https://live.staticflickr.com/65535/49600117502_26d95cd40f_z.jpg" width="640" height="316" alt="Screenshot 2020-02-29 at 8.26.42 PM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

### 作成した東南アジア地図を用いる
地図を作成する際に、`Region map`を指定し、先程追加した`Region map`である`South East Asia`を指定します。BIツールが参照するデータベースのカラムにはGeojsonで定義した国コード (= short) と同じものが入力されていることを確認した上で、国コードが格納されているカラムを指定してあげます:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49599923081/in/dateposted-public/" title="Screenshot 2020-02-29 at 8.45.26 PM"><img src="https://live.staticflickr.com/65535/49599923081_ef42a23903_z.jpg" width="436" height="640" alt="Screenshot 2020-02-29 at 8.45.26 PM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## 可視化の結果
このような形で可視化できるようになりました:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/49600180132/in/dateposted-public/" title="Screenshot 2020-02-29 at 8.44.42 PM"><img src="https://live.staticflickr.com/65535/49600180132_166fb7941f_z.jpg" width="640" height="349" alt="Screenshot 2020-02-29 at 8.44.42 PM"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## まとめ
地図による可視化はチャレンジしてみたかったのですが、[Metabase](https://github.com/metabase/metabase)による可視化は自分でGeojsonを作成することができるため、カスタマイズが可能で色々と試してみたくなります。

## 参考
- [Metabaseをお試しで使ってみた](https://blog.kazu634.com/labs/linux/2018-07-02-play-with-metabase/)
