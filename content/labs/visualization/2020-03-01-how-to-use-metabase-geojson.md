+++
title = "MetabaseでGeojsonを用いたカスタムマップを利用する"
date = 2020-03-01T09:15:53+08:00
Description = "オープンソースのお手軽BIツール・Metabaseで自分で作成した白地図上にデータを可視化できるようになっていたようなので、試してみました"
Tags = []
Categories = ["Tools", "Metabase"]
thumbnail = "images/41603208672_984110305c_z.jpg"
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

[image:C79A56A3-CC64-46E0-BFF5-2106626F3C99-4557-00003011AF9D165C/Screenshot 2020-02-29 at 8.42.47 PM.png]

個人的な都合で、東南アジア各国だけでなく、インドと台湾も含めております。また、シンガポールは点にしか過ぎなくなるため、ベトナムとフィリピンの間の領域をシンガポールとしました。

## Metabaseでの設定
[Metabase](https://github.com/metabase/metabase)での設定方法を説明します。

### 地図の登録
以下のように指定してあげます。まずは[Metabase](https://github.com/metabase/metabase)の管理画面を表示させます:

[image:D620279F-5D1A-46ED-A839-0340C80F7266-10438-00000769D27D3D24/Photo Mar 1, 2020 115309.jpg]

以下の画面が表示されるので、左側のメニューから`Maps`をクリックし、表示される画面から`Add a map`をクリックします:

[image:BFFC4028-D97E-49EC-B487-C2283CABC885-10438-0000076A0F43407A/Photo Mar 1, 2020 115351.jpg]

そうすると以下のような画面が表示されます:

[image:8DF8C01F-5EEB-41A6-B5FA-7B87E310EEBC-10438-0000076A60BA0827/Photo Mar 1, 2020 115448.jpg]

必要事項を入力していきます:

[image:DABE1F04-F594-4D96-9924-ECA4C73C3E4F-4557-00002F51AF4372B3/Screenshot 2020-02-29 at 8.26.42 PM.png]


### 作成した東南アジア地図を用いる
地図を作成する際に、`Region map`を指定し、先程追加した`Region map`である`South East Asia`を指定します。BIツールが参照するデータベースのカラムにはGeojsonで定義した国コード (= short) と同じものが入力されていることを確認した上で、国コードが格納されているカラムを指定してあげます:

[image:97C6AC6B-C03C-4DF1-9BF7-5229AFBEDC56-4557-00003036C87E5F84/Screenshot 2020-02-29 at 8.45.26 PM.png]


## 可視化の結果
このような形で可視化できるようになりました:

[image:C1AAAEC9-7930-4E2D-AF20-4CAA26AA9DF2-4557-000030431B8ED689/Screenshot 2020-02-29 at 8.44.42 PM.png]

## まとめ
地図による可視化はチャレンジしてみたかったのですが、[Metabase](https://github.com/metabase/metabase)による可視化は自分でGeojsonを作成することができるため、カスタマイズが可能で色々と試してみたくなります。
