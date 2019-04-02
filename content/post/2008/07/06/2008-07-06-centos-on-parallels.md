---
title: CentOS on Parallels
author: kazu634
date: 2008-07-06
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";i:1;s:5:"delay";i:0;s:7:"enabled";i:1;s:10:"separation";s:2:"60";s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:4123;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
categories:
  - CentOS
  - Mac

---
<div class="section">
<p>
    　仕事でLinuxとWindowsサーバの構築・運用をすることになったので、その勉強をかねてParallels上にCentOSをインストールしました。自分用の備忘録として、ここに書き散らかしておきます。
</p>
  
<h4>
    対象とする読者
</h4>
  
<p>
    　「Parallelsって、MacでWindowsを動かすためにあるんでしょ？」みたいな感じでParallelsをインストールしている人。なおかつ、MacをUnix的なOSとして見て、そんな風に活用したいと考えて購入した人。
</p>
  
<p>
    　なんていうか、とりあえずParallelsをインストールできて、WindowsXPなんかを無難にインストールできた人を対象とした説明になっている…はずです。
</p>
  
<h4>
    CentOSとは？なぜCentOSなの？
</h4>
  
<p>
    　会社でとりあえず環境構築をしろといわれたのが、RedHat Linuxだから。FreeのRedHat LinuxがCentOSと呼ばれていることを同期から聞いたので、とりあえずこいつをインストールすることに決める。
</p>
  
<h4>
    CentOSの入手先
</h4>
  
<p>
    　<a href="http://isoredirect.centos.org/centos/5/isos/i386/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://isoredirect.centos.org/centos/5/isos/i386/', 'ここ');" target="_blank">ここ</a>から入手する。とりあえず自分は新しそうなver 5.2を選択した。netinstall用のだと最後までインストールできなかったので、isoイメージを1～6までダウンロードした。つまり、
</p>
  
<ol>
<li>
      CentOS-5.2-i386-bin-1of6.iso
</li>
<li>
      CentOS-5.2-i386-bin-2of6.iso
</li>
<li>
      CentOS-5.2-i386-bin-3of6.iso
</li>
<li>
      CentOS-5.2-i386-bin-4of6.iso
</li>
<li>
      CentOS-5.2-i386-bin-5of6.iso
</li>
<li>
      CentOS-5.2-i386-bin-6of6.iso
</li>
</ol>
  
<p>
    こいつら。
</p>
  
<h4>
    Parallels上にインストール
</h4>
  
<p>
    　Parallelsを起動して「ファイル &#8211; 新規」で、新しい仮想マシンを作る。
</p>
  
<p>
<center>
</center>
</p>
  
<p>
<a href="http://flickr.com/photos/7190707@N05/2641388707/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/photos/7190707@N05/2641388707/', '');" title="Parallels_01"><img src="http://farm4.static.flickr.com/3045/2641388707_935e5802c5_m.jpg" /></a>
</p>
  
<p>
    from <a href="http://flickr.com/people/7190707@N05/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/people/7190707@N05/', 'typhoon634');">typhoon634</a>
</p></p> 
  
<p>
    とりあえず真ん中の「典型的なインストール」を選択する。
</p>
  
<p>
<center>
</center>
</p>
  
<p>
<a href="http://flickr.com/photos/7190707@N05/2641388901/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/photos/7190707@N05/2641388901/', '');" title="Parallels_02"><img src="http://farm4.static.flickr.com/3066/2641388901_6c35e4d4b0_m.jpg" /></a>
</p>
  
<p>
    from <a href="http://flickr.com/people/7190707@N05/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/people/7190707@N05/', 'typhoon634');">typhoon634</a>
</p></p> 
  
<p>
    OSタイプは「Linux」 &#8211; 「他の Linux Kernel 2.6」だよ。
</p>
  
<p>
<center>
</center>
</p>
  
<p>
<a href="http://flickr.com/photos/7190707@N05/2642216426/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/photos/7190707@N05/2642216426/', '');" title="Parallels_03"><img src="http://farm4.static.flickr.com/3029/2642216426_bdd16e5e61_m.jpg" /></a>
</p>
  
<p>
    from <a href="http://flickr.com/people/7190707@N05/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/people/7190707@N05/', 'typhoon634');">typhoon634</a>
</p></p> 
  
<p>
    適当に仮想マシンの名前をつける。今回は「CentOS」にした。
</p>
  
<p>
<center>
</center>
</p>
  
<p>
<a href="http://flickr.com/photos/7190707@N05/2641389237/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/photos/7190707@N05/2641389237/', '');" title="Parallels_04"><img src="http://farm4.static.flickr.com/3179/2641389237_8ee5944e53_m.jpg" /></a>
</p>
  
<p>
    from <a href="http://flickr.com/people/7190707@N05/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/people/7190707@N05/', 'typhoon634');">typhoon634</a>
</p></p> 
  
<p>
    とりあえず「仮想マシン」でいいんではないかと。
</p>
  
<p>
<center>
</center>
</p>
  
<p>
<a href="http://flickr.com/photos/7190707@N05/2641389365/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/photos/7190707@N05/2641389365/', '');" title="Parallels_05"><img src="http://farm4.static.flickr.com/3274/2641389365_15403ce063_m.jpg" /></a>
</p>
  
<p>
    from <a href="http://flickr.com/people/7190707@N05/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/people/7190707@N05/', 'typhoon634');">typhoon634</a>
</p></p> 
  
<p>
    詳細なオプションをクリックして、「isoイメージ」を選択する。ダウンロードした「CentOS-5.2-i386-bin-1of6.iso」を選択する。後は終了をクリック！
</p>
  
<h4>
    CentOSのインストール
</h4>
  
<p>
    ここら辺は、そこいらの解説サイトを参考にしてちょ。CDを取り替えろと言われたら、「デバイス &#8211; CD / DVD ドライブ」を選択して、「イメージに接続」を選択してあげればいい。「&#8230;2of6.iso」なんかを選択してあげてください。
</p>
  
<p>
    完成予想図はこんな感じ:
</p>
  
<p>
<center>
</center>
</p>
  
<p>
<a href="http://flickr.com/photos/7190707@N05/2642284878/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/photos/7190707@N05/2642284878/', '');" title="CentOS on Parallels"><img src="http://farm4.static.flickr.com/3162/2642284878_0661d8bf24_m.jpg" /></a>
</p>
  
<p>
    from <a href="http://flickr.com/people/7190707@N05/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://flickr.com/people/7190707@N05/', 'typhoon634');">typhoon634</a>
</p></p> 
  
<h4>
    これから
</h4>
  
<p>
    『<a href="http://d.hatena.ne.jp/asin/4839920958" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/asin/4839920958', 'CentOSサーバ構築バイブル (MYCOM UNIX Books)');">CentOSサーバ構築バイブル (MYCOM UNIX Books)</a>』で勉強だな。
</p>
  
<div class="hatena-asin-detail">
<a href="http://www.amazon.co.jp/dp/4839920958/?tag=hatena_st1-22&ascsubtag=d-7ibv" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazon.co.jp/dp/4839920958/?tag=hatena_st1-22&ascsubtag=d-7ibv', '');"><img src="https://images-na.ssl-images-amazon.com/images/I/51SRBE548JL._SL160_.jpg" class="hatena-asin-detail-image" alt="CentOSサーバ構築バイブル (MYCOM UNIX Books)" title="CentOSサーバ構築バイブル (MYCOM UNIX Books)" /></a></p> 
    
<div class="hatena-asin-detail-info">
<p class="hatena-asin-detail-title">
<a href="http://www.amazon.co.jp/dp/4839920958/?tag=hatena_st1-22&ascsubtag=d-7ibv" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazon.co.jp/dp/4839920958/?tag=hatena_st1-22&ascsubtag=d-7ibv', 'CentOSサーバ構築バイブル (MYCOM UNIX Books)');">CentOSサーバ構築バイブル (MYCOM UNIX Books)</a>
</p>
      
<ul>
<li>
<span class="hatena-asin-detail-label">作者:</span> <a href="http://d.hatena.ne.jp/keyword/%C0%EE%B0%E6%B5%C1%BC%A3" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/keyword/%C0%EE%B0%E6%B5%C1%BC%A3', '川井義治');" class="keyword">川井義治</a>,<a href="http://d.hatena.ne.jp/keyword/%B0%CB%C6%A3%B9%AC%C9%D7" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/keyword/%B0%CB%C6%A3%B9%AC%C9%D7', '伊藤幸夫');" class="keyword">伊藤幸夫</a>,<a href="http://d.hatena.ne.jp/keyword/%CA%C6%C5%C4%CB%FE" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/keyword/%CA%C6%C5%C4%CB%FE', '米田満');" class="keyword">米田満</a>,<a href="http://d.hatena.ne.jp/keyword/%CC%EE%C0%EE%BD%DA%BB%D2" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/keyword/%CC%EE%C0%EE%BD%DA%BB%D2', '野川准子');" class="keyword">野川准子</a>
</li>
<li>
<span class="hatena-asin-detail-label">出版社/メーカー:</span> <a href="http://d.hatena.ne.jp/keyword/%CB%E8%C6%FC%A5%B3%A5%DF%A5%E5%A5%CB%A5%B1%A1%BC%A5%B7%A5%E7%A5%F3%A5%BA" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/keyword/%CB%E8%C6%FC%A5%B3%A5%DF%A5%E5%A5%CB%A5%B1%A1%BC%A5%B7%A5%E7%A5%F3%A5%BA', '毎日コミュニケーションズ');" class="keyword">毎日コミュニケーションズ</a>
</li>
<li>
<span class="hatena-asin-detail-label">発売日:</span> 2006/06
</li>
<li>
<span class="hatena-asin-detail-label">メディア:</span> 単行本
</li>
<li>
<span class="hatena-asin-detail-label">クリック</span>: 53回
</li>
<li>
<a href="http://d.hatena.ne.jp/asin/4839920958" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/asin/4839920958', 'この商品を含むブログ (12件) を見る');" target="_blank">この商品を含むブログ (12件) を見る</a>
</li>
</ul>
</div>
    
<div class="hatena-asin-detail-foot">
</div>
</div>
</div>
