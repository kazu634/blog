+++
images = ["images/9592407287_1bb4d50e78_z.jpg"]
tags = []
categories = ["Linux", "インフラ"]
date = "2018-08-26T23:06:30+08:00"
title = "Linuxサーバでディスクキャッシュを説明する"
description = ""
+++

なぜメモリ使用量などを意識する必要があるのかについて説明するとした場合の簡単な案です。ディスクへのアクセスという観点でメモリがどのように利用されているかを考えて見る内容で説明してみます。[Software Design 2018年1月号｜技術評論社](http://gihyo.jp/magazine/SD/archive/2018/201801)を参考にさせていただきました。

最近は自分で手を動かしながら、実際の挙動を見ることができるような書籍・記事が増えてきたので、実際にやってみることができて嬉しいです。

## はじめに
一般的なOSでは、物理的なディスクにアクセスする際、以下のようなフローでアクセスする:

1. メモリ上にファイルが読み込まれている場合、メモリからファイルを読み込む
2. メモリ上に存在しない場合、直接ディスクにアクセスする

当然ながら、`ディスクへのアクセス速度 <<<<< メモリへのアクセス速度`のため、基本的な戦略としては「メモリにファイルを読み込ませる」こととなる。

ここではディスクキャッシュの有り無しでどのようにディスクへのアクセス速度が変化するかを見てみます。

## メモリについて
まずはLinux上でのメモリ管理について簡単におさらいします。

### ディスクキャッシュに関する情報を参照する
`free`コマンドを実行することで、メモリ上にキャッシュされているファイルサイズを確認できます。`free`コマンドを実行した際の、`buff/cache`列を参照します:

```
kazu634@bastion% free -m
                total        used        free      shared  buff/cache   availableMem:
                488         130          27           5         330         324
Swap:          1023          58         965
```

### メモリに格納されているディスクキャッシュを削除する
`/proc/sys/vim/drop_caches`に`3`を書き込むことで、メモリ上に格納されているキャッシュをドロップできます:

```
kazu634@bastion% echo 3 | sudo tee /proc/sys/vm/drop_caches
[sudo] kazu634 のパスワード:
3
kazu634@bastion% free -m
              total        used        free      shared  buff/cache   available
Mem:            488         131         275           5          81         322
Swap:          1023          58         965
kazu634@bastion%
```


## ファイルへのアクセス速度を計測する
すでに説明してきたように、OSがファイルにアクセスする際は、メモリ上のキャッシュ経由のアクセスと、直接ディスクにアクセスする場合の2つのパターンがあります。

いずれの場合も`hdparam`コマンドを利用することで計測できます。

### メモリ上のキャッシュ経由のアクセス速度を計測する
`hdparam`コマンドに`-T`オプションを指定することで、メモリ上のキャッシュを経由した場合のアクセス速度を計測できます。実行例は以下になります:

```
kazu634@bastion% sudo hdparm -T /dev/sda1
/dev/sda1:
 Timing cached reads:   11364 MB in  2.00 seconds = 5684.50 MB/sec
```

### 直接ディスクにアクセスする場合のアクセス速度を計測する
`hdparam`コマンドに`-t`オプションを指定することで、直接ディスクにアクセスする場合のアクセス速度を計測できます。実行例は以下になります:

```
kazu634@bastion% sudo hdparm -t /dev/sda1
/dev/sda1:
 Timing buffered disk reads: 124 MB in  3.07 seconds =  40.43 MB/sec
```

## 実際に計測してみる
まずはキャッシュをドロップします:

```
kazu634@bastion% free -m
              total        used        free      shared  buff/cache   availableMem:
               488         130          27           5         330         324
Swap:          1023          58         965
kazu634@bastion%
kazu634@bastion% echo 3 | sudo tee /proc/sys/vm/drop_caches
[sudo] kazu634 のパスワード:
3
kazu634@bastion% free -m
              total        used        free      shared  buff/cache   available
Mem:            488         131         275           5          81         322
Swap:          1023          58         965
kazu634@bastion%
```

### 直接ディスクにアクセスした場合
直接ディスクにアクセスした場合はこのような結果でした:


```
kazu634@bastion% sudo hdparm -t /dev/sda1
/dev/sda1:
 Timing buffered disk reads: 124 MB in  3.07 seconds =  40.43 MB/sec
```

### ディスクキャッシュ経由でアクセスした場合
ディスクキャッシュ経由でアクセスした場合は、このような結果でした:

```
kazu634@bastion% sudo hdparm -T /dev/sda1
/dev/sda1:
 Timing cached reads:   11364 MB in  2.00 seconds = 5684.50 MB/sec
```

### まとめ
ディスクキャッシュを経由したほうが、すごく早いです！少なくとも読み込みは！

## 参考
<div class="amazlet-box" style="margin-bottom:0px;"><div class="amazlet-image" style="float:left;margin:0px 12px 1px 0px;"><a href="https://www.amazon.co.jp/exec/obidos/ASIN/B076M9MGDL/simsnes-22/ref=nosim/" name="amazletlink" target="_blank"><img src="https://images-fe.ssl-images-amazon.com/images/I/61xVgsnyrIL._SL160_.jpg" alt="ソフトウェアデザイン 2018年 01 月号 [雑誌]" style="border: none;" /></a></div><div class="amazlet-info" style="line-height:120%; margin-bottom: 10px"><div class="amazlet-name" style="margin-bottom:10px;line-height:120%"><a href="https://www.amazon.co.jp/exec/obidos/ASIN/B076M9MGDL/simsnes-22/ref=nosim/" name="amazletlink" target="_blank">ソフトウェアデザイン 2018年 01 月号 [雑誌]</a><div class="amazlet-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="http://www.amazlet.com/" title="amazlet" target="_blank">amazlet</a> at 18.08.26</div></div><div class="amazlet-detail"><br />技術評論社 (2017-12-18)<br /></div><div class="amazlet-sub-info" style="float: left;"><div class="amazlet-link" style="margin-top: 5px"><a href="https://www.amazon.co.jp/exec/obidos/ASIN/B076M9MGDL/simsnes-22/ref=nosim/" name="amazletlink" target="_blank">Amazon.co.jpで詳細を見る</a></div></div></div><div class="amazlet-footer" style="clear: left"></div></div>

