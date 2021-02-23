---
title: 'じゆうけんきゅう: シンガポールのhaze情報のページからPSI情報を取得してアニメーションGIFにしてみた'
author: kazu634
date: 2015-10-04
tmac_last_id:
  - 665467418412756993
author:
  - kazu634
categories:
  - cron
  - linux
  - ruby

---
組み合わせたらいい感じにできそうなことは知っているんだけど、実際にやったこと無いからやってみたシリーズです。

今回は

  * Ruby
  * ImageMagick
  * RMagick
  * PhantomJS
  * Capybara

を組み合わせて、<a href="http://www.haze.gov.sg/home" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.haze.gov.sg/home', 'シンガポールのhaze情報のページ');" target="_blank">シンガポールのhaze情報のページ</a>からPSI情報を取得してみました。自由研究の成果はこんな感じです(11:00くらいからウェブページのレイアウトが変更されたみたいで日時が表示されなくなりました。。。):

<img class="aligncenter" src="https://c1.staticflickr.com/1/621/21913428746_b1e30ec751_o_d.gif" alt="PSI 2015/10/04" />

<!--more-->

* * *

## Hazeとは何か？

<a href="https://ja.wikipedia.org/wiki/%E3%83%98%E3%82%A4%E3%82%BA_(%E6%B0%97%E8%B1%A1)" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://ja.wikipedia.org/wiki/%E3%83%98%E3%82%A4%E3%82%BA_(%E6%B0%97%E8%B1%A1)', 'Wikipedia');" target="_blank">Wikipedia</a>によるとHazeとは

> ヘイズ (haze) とは、現代の気象用語としては煙霧を意味する英語だが、伝統的には広く靄、塵煙霧など、微粒子により視界が悪くなる大気現象全般を含む。原因は微細な水滴のほか、黄砂、工業などの煤煙、スモッグ、山火事・焼畑などがある。

というように書かれていますが、下の方をよく見ると発生原因として以下が挙げられています:

> インドネシアのスマトラ島やカリマンタン島などにおけるプランテーションでの野焼きや森林火災など。人為的な着火による処理の対象としては、パームヤシ農園や、製紙用パルプ材の植林地などでの残渣が主である。インドネシアにおける大手パーム油企業による野焼き規制は強化されているが、2015年現在改善の兆しはない。

インドネシア、お前か。。。健康的にかなり良くないもので、ひどい時は外に出たくないくらいです:

> ヘイズは人体に対して深刻な被害を及ぼす危険性がある。目、鼻、喉などの粘膜や、皮膚のかゆみ、気管から肺などの呼吸器系や循環器系への健康被害が報告されている。特にぜんそくや心臓疾患がある場合は注意が必要であると外務省・現地日本大使館から案内されている。

指標は以下のとおりで今日の午前中はUnhealthyでしたが、まぁ軽い方でしたね。。。

<a href="https://www.flickr.com/photos/42332031@N02/21949890061/in/dateposted-public/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/21949890061/in/dateposted-public/', '');" title="haze_table"  data-flickr-embed="true"><img class="aligncenter" src="https://farm6.staticflickr.com/5789/21949890061_d3767f1a24.jpg" alt="haze_table" width="346" height="255" /></a>

## 今回の目的

<a href="http://www.haze.gov.sg/home" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.haze.gov.sg/home', 'シンガポールのhaze情報のページ');" target="_blank">シンガポールのhaze情報のページ</a>からPSI情報をスクリーンショットとして取得し、アニメーションGIFに合成します。下の赤で囲んだ部分を切り取ります:

<a href="https://www.flickr.com/photos/42332031@N02/21913974856/in/dateposted-public/" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/21913974856/in/dateposted-public/', '');" title="target"  data-flickr-embed="true"><img class="aligncenter" src="https://farm6.staticflickr.com/5755/21913974856_53fdc95334.jpg" alt="target" width="295" height="500" /></a>

## スクリーンショットの取得

<a href="http://phantomjs.org/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://phantomjs.org/', 'ヘッドレスブラウザのPhantomJS');">ヘッドレスブラウザのPhantomJS</a>をRubyから呼び出してスクリーンショットを取得しました。関係する部分だけを書くと、こんな感じです:

```
#!/usr/bin/env ruby

require 'capybara'
require 'capybara/poltergeist'

URL                  = 'http://www.haze.gov.sg/haze-updates/psi'
YYYYMMDDHHMM         = Time.now.strftime('%Y%m%d%H%M')

STOREDIR             = "#{File.expand_path(File.dirname(__FILE__))}/screenshots"
screenshot_file_name = "#{STOREDIR}/#{YYYYMMDDHHMM}.png"


################################################
# Get Screenshots
################################################
begin
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app,  {:js_errors =&gt; false,  :timeout =&gt; 1000 })
  end

  browser = Capybara::Session.new(:poltergeist)

  browser.visit URL
  browser.save_screenshot(screenshot_file_name, full: true)
rescue Exception =&gt; e
  puts e.message
  exit 1
end
```

## 指定範囲の切り出し

スクリーンショットはウェブページ全体を取得しているので、そこから指定範囲を切り出します。<a href="http://www.imagemagick.org/script/index.php" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.imagemagick.org/script/index.php', 'ImageMagick');" target="_blank">ImageMagick</a>を使いました。使用例はこんな感じです:

`% convert <em>screenshot.png</em> -crop '330x340+640+490' output.png`

ImageMagickでできることを確認したら、Rubyから同じコマンドを呼び出してあげました。

## 日時情報の生成

これだけだと日時情報がなくてわかりづらかったため、日時情報の画像を生成してみました。こんな感じです:

`% convert -background none label:"2015/10/03 15:00" -pointsize 18 sample01.png`

できあがるのはこんな画像です:

<a href="http://blog.kazu634.com/wp-content/uploads/2015/10/sample01.png" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://blog.kazu634.com/wp-content/uploads/2015/10/sample01.png', '');"><img class="aligncenter size-full wp-image-6755" src="http://blog.kazu634.com/wp-content/uploads/2015/10/sample01.png" alt="sample01" width="98" height="13" /></a>

## 切り出した画像と日時情報の画像を結合

２つをくっつけてみました:

`% convert output.png sample01.png -gravity southwest -composite sample02.png`

## これを一つのRubyスクリプトにまとめてみました

こうなりました:

```
#!/usr/bin/env ruby

require 'capybara'
require 'capybara/poltergeist'
require 'rmagick'

URL                  = 'http://www.haze.gov.sg/haze-updates/psi'
YYYYMMDDHHMM         = Time.now.strftime('%Y%m%d%H%M')
OUT_STR              = Time.now.strftime('%Y/%m/%d %H:%M')

STOREDIR             = "#{File.expand_path(File.dirname(__FILE__))}/screenshots"
screenshot_file_name = "#{STOREDIR}/#{YYYYMMDDHHMM}.png"
crop_file_name       = "#{STOREDIR}/#{YYYYMMDDHHMM}_crop.png"
caption_file_name    = "#{STOREDIR}/#{YYYYMMDDHHMM}_caption.png"
result               = "#{STOREDIR}/#{YYYYMMDDHHMM}_result.png"

################################################
# Get Screenshots
################################################
begin
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app,  {:js_errors =&gt; false,  :timeout =&gt; 1000 }) #追加のオプションはググってくださいw
  end

  browser = Capybara::Session.new(:poltergeist)

  browser.visit URL
  browser.save_screenshot(screenshot_file_name, full: true)
rescue Exception =&gt; e
  puts e.message
  exit 1
end

################################################
# Crop & Date-time image generation
################################################
begin
  original = Magick::Image.read(screenshot_file_name).first

  crop = original.crop(285, 490, 340, 365)
  crop.write(crop_file_name)

  caption = Magick::Image.new(170, 30) {
    self.background_color = 'none'
  }
  draw    = Magick::Draw.new

  draw.annotate(caption, 0, 0, 4, 4, OUT_STR) do
    self.pointsize = 14
    self.gravity   = Magick::SouthWestGravity
  end

  caption.write(caption_file_name)
rescue Exception =&gt; e
  puts e.message
  exit 2
end

################################################
# Composite
################################################
begin
  save_image = crop.composite(caption, Magick::NorthWestGravity, Magick::OverCompositeOp);
  save_image.write(result)
rescue Exception =&gt; e
  puts e.message
  exit 3
ensure
  File.delete screenshot_file_name
end

################################################
# Post processing
################################################
begin
  File.delete crop_file_name
  File.delete caption_file_name
rescue Exception =&gt; e
  puts e.message
  exit 4
end

exit 0
```

## その後

作成したスクリプトを5分おきに実行して、しばらく放ったらかしてから以下のコマンドを実行してアニメーションGIFを作成しました。どうやら「+repage」してあげないと、切り取り前の画像サイズをもってしまっているようで、すごく1024&#215;600超の画像サイズのアニメーションGIFが出来上がってしまいました。。。

```
% ls -1 | xargs -I % -n 1 convert % -trim +repage %.trim
% rm *.png
% for i in `ls -1`
do
mv ${i} ${i/.trim/}
done
% convert -limit memory 1 -limit map 1 -delay 15 20151004*_result.png anime.gif
```

## 参考にしたサイト

  * <a href="http://blog.ruedap.com/2011/03/22/ruby-rmagick-imagemagick-resize-crop" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://blog.ruedap.com/2011/03/22/ruby-rmagick-imagemagick-resize-crop', 'RubyのRMagickで縦横比固定でリサイズしたり切り抜いたり &#8211; アインシュタインの電話番号');">RubyのRMagickで縦横比固定でリサイズしたり切り抜いたり &#8211; アインシュタインの電話番号</a>
  * <a href="http://gihyo.jp/dev/serial/01/ruby/0026?page=1" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://gihyo.jp/dev/serial/01/ruby/0026?page=1', '第26回　RMagickを用いた画像処理（1）リサイズ：Ruby Freaks Lounge｜gihyo.jp … 技術評論社');">第26回　RMagickを用いた画像処理（1）リサイズ：Ruby Freaks Lounge｜gihyo.jp … 技術評論社</a>
  * <a href="http://www.xmisao.com/2014/04/10/rmagick-tips.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.xmisao.com/2014/04/10/rmagick-tips.html', 'RMagickによる画像生成と文字の描画など &#8212; ぺけみさお');">RMagickによる画像生成と文字の描画など &#8212; ぺけみさお</a>
  * <a href="http://d.hatena.ne.jp/adorechic/20120316/1331885526" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/adorechic/20120316/1331885526', 'imagemagickで透過PNGとかcropするときに余白が残るときは+repage &#8211; あん肝とハイネケン');">imagemagickで透過PNGとかcropするときに余白が残るときは+repage &#8211; あん肝とハイネケン</a>
  * <a href="http://qcganime.web.fc2.com/FREEWARE/Gnuplot/HowToMakeAnimation02.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://qcganime.web.fc2.com/FREEWARE/Gnuplot/HowToMakeAnimation02.html', 'フリーウェアニメ(gnuplot編)');">フリーウェアニメ(gnuplot編)</a>
