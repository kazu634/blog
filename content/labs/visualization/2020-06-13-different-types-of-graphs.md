+++
title="色々あるグラフをどのように使い分けるか、まとめてみます"
date=2020-06-13
Description="グラフをどのように使い分けるか、『グラフを作る前に読む本』にまとめられていたのでメモします"
images = [""]
chart=true
+++

<a href="https://www.amazon.co.jp/%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E3%81%A4%E3%81%8F%E3%82%8B%E5%89%8D%E3%81%AB%E8%AA%AD%E3%82%80%E6%9C%AC%EF%BC%BB%E4%B8%80%E7%9E%AC%E3%81%A7%E4%BC%9D%E3%82%8F%E3%82%8B%E8%A1%A8%E7%8F%BE%E3%81%AF%E3%81%A9%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB%E7%94%9F%E3%81%BE%E3%82%8C%E3%81%9F%E3%81%AE%E3%81%8B%EF%BC%BD-%E6%9D%BE%E6%9C%AC-%E5%81%A5%E5%A4%AA%E9%83%8E-ebook/dp/B075WRLPGV/ref=as_li_ss_il?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&dchild=1&keywords=%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E4%BD%9C%E3%82%8B%E5%89%8D%E3%81%AB&qid=1592495480&sr=8-1&linkCode=li2&tag=simsnes-22&linkId=e0d680dadb70490cd55526f37e9e4fed&language=ja_JP" target="_blank">『グラフを作る前に読む本』</a>に、グラフをどのようにようにように使い分けるかについてまとめられていたのでメモします。

## まとめるとこんな感じ
書いてあることをまとめると、以下のようになるようです:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/50000844672/" title="Untitled"><img src="https://live.staticflickr.com/65535/50000844672_9eb0556d44_z.jpg" width="640" height="340" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## 各グラフの使いどころ

### 棒グラフ
棒グラフの特徴として、以下のようにまとめられていました:

> 棒グラフでは、複数並んだ棒の高さを比べて「棒が大きい(小さい)項目はどれだろう？」と考えます。つまり棒グラフが一番得意な表現方法はデータの「比較」です。棒グラフを使えば、比べたいデータを最も分かりやすクズで表現できます。
> 
> 「高さ」を比べて項目の量の違いを感覚的につかめるのが棒グラフの特徴です。

{{<chart canvas="box" height="200">}}
    var ctx = document.getElementById('box');
    var myChart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple', 'Orange'],
        datasets: [{
            label: '# of Votes',
            data: [12, 19, 3, 5, 2, 3],
            borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true
                }
            }]
        },
        plugins: {
          colorschemes: {
            scheme: 'tableau.Tableau20',
            fillAlpha: 0.3
          }
        } 
      }
  });
{{< /chart >}}


項目の並び順に気をつけると、もっとわかりやすくなるそうです:

> 棒グラフの一番得意な表現方法は「比較」だと述べました。しかし、単純に「比較」するといっても、どのようにデータ項目を並べるかで伝わり方は大きく変わります。棒グラフを作成する秘訣は、何を「比較」するためにデータ項目を並べるか、その順番にあると言っても、過言ではありません。

### 折れ線グラフ
折れ線グラフの特徴に以下のようにまとめられていました:

> 折れ線グラフは必ずデータ項目の複数の時点を描きます。点を一つだけ描く折れ線グラフを目にする機会はないでしょう。
> 
> 折れ線グラフでは、ある時点とある時点を左から右に線で結んで「線の傾きが大きい(小さい)時点はどれだろう？」、「傾きの傾向が変化するのはどの時点だろう？」と考えます。つまり折れ線グラフが一番得意な表現方法はデータの「推移」です。折れ線グラフを使えば、データの変化を最もわかりやすく図で表現できます。
> 
> ある時点とある時点の間の「傾き」から変化を感覚的につかめるのが折れ線グラフの特徴です。

{{<chart canvas="line-chart" height="200">}}
    var ctx = document.getElementById('line-chart');
    var myChart = new Chart(ctx, {
    type: 'line',
    data: {
        labels: ['2015', '2016', '2017', '2018', '2019', '2020'],
        datasets: [{
            label: '# of Votes',
            data: [12, 19, 3, 5, 2, 3],
            fill: false,
            borderColor: [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ],
            backgroundColor: [
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)'
            ],
            borderWidth: 1
        }]
    },
    options: {
        scales: {
            yAxes: [{
                ticks: {
                    beginAtZero: true
                }
            }]
        },
        plugins: {
          colorschemes: {
            scheme: 'tableau.Tableau20',
            fillAlpha: 0.3
          }
        } 
    }
});
{{< /chart >}}

折れ線グラフについては、数の変化に意味を持たせられると、意図が明確になるそうです:

> 折れ線グラフは推移の「傾向」に意味を持たせれば、何が言いたいのかがより伝わります。「傾向」とは、向かっていく方向という意味を持っています。

#### 割合を示すデータの推移を折れ線グラフで示すときは注意
割合を示すデータの推移を折れ線グラフで示すときは、総数が減っている可能性があるため、読み取る際に注意する必要がある:

> 割合で表示されるデータの推移が高まっても、総数が減っているなら、実数で表現されたデータは実質横ばいか減少している可能性があります。「若者の○○離れ」と呼ばれる現象は、この錯覚で大体説明ができると私は思っています。若者の総数が減っているのですから、アルコール好きも旅行好きも車好きも時系列の推移で見れば減るのは当然です。

### 円グラフ
円グラフの特徴に以下のようにまとめられていました:

> 円グラフは縁の中心から12時方向に引いた線を起点にして、項目の打ち分けごとに角度に置き換えて面を作り、「角度が大きい(小さい)項目はどれだろう？」「全体に対して占める割合が大きい(小さい)項目はどれだろう？」と考えます。つまり、円グラフが一番得意な表現方法は、データ全体の「内訳」です。

円の「角度」から内訳を感覚的につかめるのが、円グラフの特徴とのこと。下のグラフを見れば、A型とO型が大きな割合を占めていることがわかります:

{{<chart canvas="pie-chart" height="200">}}
  var ctx = document.getElementById("pie-chart");
  var myPieChart = new Chart(ctx, {
    type: 'pie',
    data: {
      labels: ["A", "O", "B", "AB"],
      datasets: [{
        data: [38, 31, 21, 10]
      }]
    },
    options: {
      title: {
        display: true,
        text: 'Blood Type Ratio'
      },
      plugins: {
        colorschemes: {
          scheme: 'tableau.Tableau20',
          fillAlpha: 0.3
        }
      } 
    }
  });
{{< /chart >}}

#### 円グラフの利用が推奨されない理由
以下、2つの理由があるそうです:

- 総量がわからないので違う円グラフの内訳と比較できない
- 時系列データを用いた時間経過による内訳の推移を表現できない

### レーダーチャート
レーダーチャートの特徴は以下のようにまとめられていました:

- レーダーチャートが一番得意な表現方法は複数あるデータ項目の「比較」
- 線で結ばれた面の「大きさ」、「滑らかさ」を比べてデータの大小を感覚的に掴めるのがレーダーチャートの特徴
- 特定のデータ項目のみに現れた傾向を比較したいのか、データ項目同士を比較したいのか、グラフを作る前に方針を決めておく

{{<chart canvas="radar-chart" height="200">}}
  var ctx = document.getElementById("radar-chart");
  var myPieChart = new Chart(ctx, {
    type: 'radar',
    data: { 
      labels: ["English", "Math", "Japanese", "Science", "History"],
      datasets: [{
        label: 'Alice',
        data: [92, 72, 86, 74, 86],
        borderColor: 'RGBA(225,95,150, 1)',
        borderWidth: 1,
        pointBackgroundColor: 'RGB(46,106,177)'
      }, {
        label: 'Bob',
        data: [73, 95, 80, 87, 79],
        borderColor: 'RGBA(115,255,25, 1)',
        borderWidth: 1,
        pointBackgroundColor: 'RGB(46,106,177)'
      }]
    },
    options: {
      title: {
        display: true,
        text: 'Test Results'
      },
      scale:{
        ticks:{
          suggestedMax: 100,
          suggestedMin: 0,
          stepSize: 10,
          callback: function(value, index, values){
            return  value
          }
        }
      },
      plugins: {
        colorschemes: {
          scheme: 'tableau.Tableau20',
          fillAlpha: 0.3
        }
      } 
    }
  });
{{< /chart >}}

### ヒートマップ
ヒートマップの特徴は以下のように説明されていました:

- ヒートマップの最大の特徴は、塗り絵のように表を色で塗る点です。データを読んでわかるというよりは、データの傾向を表す色を見てわかる「表」に仕上がります。
-  ヒートマップは数字を色に置き換えて、「どのデータ項目にデータが偏っているだろうか？」と考えます。つまりヒートマップが一番得意な表現方法は、量の「偏り」です。
- 細かく比較するのにはヒートマップは適していませんが、全体のデータの傾向を一瞬で把握するのには最適なのです。

### 散布図
散布図の特徴は以下のように説明されていました:

> 散布図は2つのデータとその2つのデータを束ねるデータ項目が用意されます。あとは、縦軸と横軸の2軸で構成された表にひたすらそのデータを点として打ち込むだけです。まさに「scatter：なのです。たったそれだけなのに、データの傾向を把握できます。

散布図が表現するのは、2つのデータ項目の「関係」:

> 複数の項目を表現した点を俯瞰して見て「縦軸と横軸の相関(二つのデータ項目が密接に関わり合っている状態)はあるだろうか？」と考えます。つまり散布図が一番得意な表現方法は、2つのデータ項目の「関係」です。散布図は、二つの観点から見たデータの関係性を最もわかりやすく図で表現できます。「相関」という言葉、あまり聞き慣れないですよね。一方の値が変化している時、他方の値も変化しているという2つの値の関連性を意味しています。「相関関係」とも表現します。

> 伝えたい内容は、2つのデータ項目間の比較でも推移でも偏りでもありません。「関係」というデータ同士のつながりです。

下の散布図を見ると、英語と数学のテストの成績には関係性が隠れていそうです:

{{<chart canvas="scatter-chart" height="200">}}
  var ctx = document.getElementById("scatter-chart");

  var myScatterChart = new Chart(ctx, {
    type: 'scatter', 
    data: { 
      datasets: [
        {
          label: '1st Class',
          data: [{x:90, y:82},{x:39, y:45},{x:63, y:65},{x:83, y:75},{x:83, y:95}]
          }, 
        {
          label: '2nd Class',
          data: [{x:97, y:92},{x:63, y:70},{x:48, y:52},{x:83, y:79},{x:66, y:74}]
        }]
    },
    options:{
      title: {
        display: true,
          text: 'Test Results'
      },
      scales: {
        xAxes: [{        
          scaleLabel: {             
            display: true,          
            labelString: 'English' 
          },
          ticks: {
            suggestedMin: 0,
            suggestedMax: 100,
            stepSize: 10,
            callback: function(value, index, values){
              return  value
            }
          }
        }],
        yAxes: [{        
          scaleLabel: {             
            display: true,          
            labelString: 'Math' 
          },
          ticks: {
            suggestedMax: 100,
            suggestedMin: 0,
            stepSize: 10,
            callback: function(value, index, values){
              return  value
            }
          }
        }]
      },
      plugins: {
        colorschemes: {
          scheme: 'tableau.Tableau20',
          fillAlpha: 0.3
        }
      }
    }
  });
{{< /chart >}}

### 積み上げ棒グラフ
積み上げ棒グラフの特徴は以下のように説明されていました:

> そもそも積み上げ棒グラフとは、棒グラフを改良させたグラフです。基本は棒グラフの表現をしているので、データ項目同士の「比較」もデータ項目の内訳の「比較」も把握できます。だから、円グラフの「総量がわからないので違う円グラフの内訳と比較できない」というデメリットを解消できるのです。高さを比べて量の大小を感覚的につかめる棒グラフの特徴を活かして、積み上げた棒の高さをそれぞれ比べられるのです。送料に対する内訳の表現を円ではなく、棒の高さで表現しているからです。

> 積み上げ棒グラフは、棒の中に必ず複数のデータ項目を描きます。棒の内訳に1つのデータ項目しかない積み上げ棒グラフは、何も積み上げていないので単なる棒グラフです。そんな積み上げ棒グラフを目にする機会は少ないでしょう。積み上げ棒グラフでは、あるデータ項目の内訳の高さを比べて「全体に対して占める割合が大きい(小さい)データ量はどれだろう？」と考えます。つまり積み上げ棒グラフが一番得意な表現方法は、データ全体の「内訳」の「比較」です。積み上げ棒グラフは、各データ項目が全体に対して占める割合を比べやすいように図で表現できます。

以下の説明で書かれているように、積み上げ棒グラフには2種類の読み方がある:

> 積み上げ棒グラフは、円グラフが得意とする「内訳」と棒グラフが得意とする「比較」のどちらを強調したいか決めれば、何が言いたいのかより伝わります。

1. 「比較」を重視する作り方
2. 「内訳」を重視する作り方

#### 比較を重視する積み上げ棒グラフ
比較を重視した場合は、総量を純粋に積み上げて、以下のようなグラフを利用することになりそう:

{{<chart canvas="stacked-bar-chart" height="200">}}
  var ctx = document.getElementById("stacked-bar-chart");
  var myBarChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['8月1日', '8月2日', '8月3日', '8月4日', '8月5日', '8月6日', '8月7日'],
      datasets: [
        {
          label: 'A店 来客数',
          data: [62, 65, 93, 85, 51, 66, 47]
      },{
          label: 'B店 来客数',
          data: [55, 45, 73, 75, 41, 45, 58]
      },{
          label: 'C店 来客数',
          data: [33, 45, 62, 55, 31, 45, 38]
      }]
    },
    options: {
      title: {
        display: true,
        text: '支店別 来客数'
      },
      scales: {
        xAxes: [{
          stacked: true
        }],
        yAxes: [{
          stacked: true,
          ticks: {
            suggestedMax: 250,
            suggestedMin: 0,
            stepSize: 10,
            callback: function(value, index, values){
              return  value +  '人'
            }
          }
        }]
      },
      plugins: {
        colorschemes: {
          scheme: 'tableau.Tableau20',
          fillAlpha: 0.3
        }
      }  
  },
  });
{{< /chart >}}

#### 内訳を重視する積み上げ棒グラフ
内訳を重視した場合は、総量に対する割合を積み上げて、合計が100%になるようにした、以下のようなグラフを利用することになりそう:

{{<chart canvas="stacked-ratio-bar-chart" height="200">}}
  var ctx = document.getElementById("stacked-ratio-bar-chart");
  var myBarChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: ['8月1日', '8月2日', '8月3日', '8月4日', '8月5日', '8月6日', '8月7日'],
      datasets: [
        {
          label: 'A店 来客数',
          data: [62, 65, 93, 85, 51, 66, 47]
      },{
          label: 'B店 来客数',
          data: [55, 45, 73, 75, 41, 45, 58]
      },{
          label: 'C店 来客数',
          data: [33, 45, 62, 55, 31, 45, 38]
      }]
    },
    options: {
      title: {
        display: true,
        text: '支店別 来客数'
      },
      scales: {
        xAxes: [{
          stacked: true
        }],
        yAxes: [{
          stacked: true,
          ticks: {
            suggestedMax: 250,
            suggestedMin: 0,
            stepSize: 10,
            callback: function(value, index, values){
              return  value +  '%'
            }
          }
        }]
      },
      plugins: {
        colorschemes: {
          scheme: 'tableau.Tableau20',
          fillAlpha: 0.3
        },
        stacked100: {
          enable: true
        },
      }  
    },
  });
{{< /chart >}}

### 面グラフ
面グラフの特徴は以下のように説明されていました:

> 面グラフは1つの線を描き終えると、2つ目の先は先に引いた線上を0の基準とみなして再び線を描きます。2つ目の線は、1つ目に引かれた線を0という基準にしていいるのを明確にするために、1つ目に引いた線の下側を塗りつぶし、2つ目の線の下側と1つ目の線の上側も塗りつぶします。だから面グラフと言われています。

> 面グラフは必ず複数の時点、面の中に複数のデータ項目を描きます。面の内訳が1つだけ描かれる面グラフは単なる折れ線グラフです。そんな面グラフを目にする機会はないでしょう。面グラフでは、面の推移を比べて「全体に対して占める割合が大きい(小さい)データ量はどのように変化するのだろう？」と考えます。つまり面グラフが一番得意な表現方法は、データ全体の「内訳」の「推移」です。面グラフは、データ(数字)の総量と内訳の変化を最もわかりやすく図で表現できます。
> 
> データ全体に対する特定のデータ項目の「推移」から内訳の変化を感覚的につかめるのが面グラフの特徴です。

> 面グラフは、円グラフが得意とする「内訳」と折れ線グラフが得意とする「推移」のどちらかを強調したいか決めれば、何が言いたいのかより伝わります。

面グラフの具体例は以下になります:

{{<chart canvas="area-stacked-chart" height="200">}}
  const loggedIn = [26, 36, 42, 38, 40, 30, 12];
  const available = [34, 44, 33, 24, 25, 28, 25];
  const availableForExisting = [16, 13, 25, 33, 40, 33, 45];
  const unavailable = [5, 9, 10, 9, 18, 19, 20];
  const xData = [13, 14, 15, 16, 17, 18, 19];

  var ctx = document.getElementById("area-stacked-chart");
  var myBarChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: xData,
      datasets: [{
        label: "Unavailable",
        fill: true,
        borderCapStyle: 'butt',
        data: unavailable
      }, {
        label: "Available for Existing",
        fill: true,
        borderCapStyle: 'butt',
        data: availableForExisting
      }, {
        label: "Available",
        fill: true,
        borderCapStyle: 'butt',
        data: available
      }, {
        label: "Logged In",
        fill: true,
        data: loggedIn
      }]
    },
    options: {
      scales: {
        yAxes: [{
          stacked: true,
        }]
      },
      plugins: {
        colorschemes: {
          scheme: 'tableau.Tableau20',
          fillAlpha: 0.3
        },
      }
    }
  });
{{< /chart >}}


## 参考

### 参考リンク
- [Chart.jsでグラフを描画してみた - Qiita](https://qiita.com/Haruka-Ogawa/items/59facd24f2a8bdb6d369#3-2-%E6%A3%92%E3%82%B0%E3%83%A9%E3%83%95)
- [ChartJS stacked line chart](https://codepen.io/natenorberg/pen/WwqRar)

### 書籍情報

<div class="krb-amzlt-box" style="margin-bottom:0px;"><div class="krb-amzlt-image" style="float:left;margin:0px 12px 1px 0px;"><a href="https://www.amazon.co.jp/%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E3%81%A4%E3%81%8F%E3%82%8B%E5%89%8D%E3%81%AB%E8%AA%AD%E3%82%80%E6%9C%AC%EF%BC%BB%E4%B8%80%E7%9E%AC%E3%81%A7%E4%BC%9D%E3%82%8F%E3%82%8B%E8%A1%A8%E7%8F%BE%E3%81%AF%E3%81%A9%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB%E7%94%9F%E3%81%BE%E3%82%8C%E3%81%9F%E3%81%AE%E3%81%8B%EF%BC%BD-%E6%9D%BE%E6%9C%AC-%E5%81%A5%E5%A4%AA%E9%83%8E-ebook/dp/B075WRLPGV/ref=as_li_ss_il?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&dchild=1&keywords=%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E4%BD%9C%E3%82%8B%E5%89%8D%E3%81%AB&qid=1592495480&sr=8-1&linkCode=li2&tag=simsnes-22&linkId=e0d680dadb70490cd55526f37e9e4fed&language=ja_JP" target="_blank" rel="nofollow" rel="nofollow"><img border="0" src="//ws-fe.amazon-adsystem.com/widgets/q?_encoding=UTF8&ASIN=B075WRLPGV&Format= _SL250_&ID=AsinImage&MarketPlace=JP&ServiceVersion=20070822&WS=1&tag=simsnes-22&language=ja_JP" ></a><img src="https://ir-jp.amazon-adsystem.com/e/ir?t=simsnes-22&language=ja_JP&l=li2&o=9&a=B075WRLPGV" width="1" height="1" border="0" alt="" style="border:none !important; margin:0px !important;" /></div><div class="krb-amzlt-info" style="line-height:120%; margin-bottom: 10px"><div class="krb-amzlt-name" style="margin-bottom:10px;line-height:120%"><a href="https://www.amazon.co.jp/%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E3%81%A4%E3%81%8F%E3%82%8B%E5%89%8D%E3%81%AB%E8%AA%AD%E3%82%80%E6%9C%AC%EF%BC%BB%E4%B8%80%E7%9E%AC%E3%81%A7%E4%BC%9D%E3%82%8F%E3%82%8B%E8%A1%A8%E7%8F%BE%E3%81%AF%E3%81%A9%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB%E7%94%9F%E3%81%BE%E3%82%8C%E3%81%9F%E3%81%AE%E3%81%8B%EF%BC%BD-%E6%9D%BE%E6%9C%AC-%E5%81%A5%E5%A4%AA%E9%83%8E-ebook/dp/B075WRLPGV/ref=as_li_ss_il?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&dchild=1&keywords=%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E4%BD%9C%E3%82%8B%E5%89%8D%E3%81%AB&qid=1592495480&sr=8-1&linkCode=li2&tag=simsnes-22&linkId=e0d680dadb70490cd55526f37e9e4fed&language=ja_JP" name="amazletlink" target="_blank" rel="nofollow" rel="nofollow">グラフをつくる前に読む本［一瞬で伝わる表現はどのように生まれたのか］ Kindle版</a><div class="krb-amzlt-powered-date" style="font-size:80%;margin-top:5px;line-height:120%">posted with <a href="https://kaereba.com/wind/" title="amazlet" target="_blank" rel="nofollow" rel="nofollow">カエレバ</a></div></div><div class="krb-amzlt-detail"></div><div class="krb-amzlt-sub-info" style="float: left;"><div class="krb-amzlt-link" style="margin-top: 5px"><a href="https://www.amazon.co.jp/%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E3%81%A4%E3%81%8F%E3%82%8B%E5%89%8D%E3%81%AB%E8%AA%AD%E3%82%80%E6%9C%AC%EF%BC%BB%E4%B8%80%E7%9E%AC%E3%81%A7%E4%BC%9D%E3%82%8F%E3%82%8B%E8%A1%A8%E7%8F%BE%E3%81%AF%E3%81%A9%E3%81%AE%E3%82%88%E3%81%86%E3%81%AB%E7%94%9F%E3%81%BE%E3%82%8C%E3%81%9F%E3%81%AE%E3%81%8B%EF%BC%BD-%E6%9D%BE%E6%9C%AC-%E5%81%A5%E5%A4%AA%E9%83%8E-ebook/dp/B075WRLPGV/ref=as_li_ss_il?__mk_ja_JP=%E3%82%AB%E3%82%BF%E3%82%AB%E3%83%8A&dchild=1&keywords=%E3%82%B0%E3%83%A9%E3%83%95%E3%82%92%E4%BD%9C%E3%82%8B%E5%89%8D%E3%81%AB&qid=1592495480&sr=8-1&linkCode=li2&tag=simsnes-22&linkId=e0d680dadb70490cd55526f37e9e4fed&language=ja_JP" name="amazletlink" target="_blank" rel="nofollow" rel="nofollow">Amazon.co.jpで詳細を見る</a></div></div></div><div class="krb-amzlt-footer" style="clear: left"></div></div>
