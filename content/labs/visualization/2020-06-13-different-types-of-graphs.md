+++
title="色々あるグラフをどのように使い分けるか、まとめてみます"
date=2020-06-13
Description="グラフをどのように使い分けるか、『グラフを作る前に読む本』にまとめられていたのでメモします"
images = [""]
chart=true
+++

『グラフを作る前に読む本』に、グラフをどのようにようにように使い分けるかについてまとめられていたのでメモします。

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
            backgroundColor: [
                'rgba(255, 99, 132, 0.2)',
                'rgba(54, 162, 235, 0.2)',
                'rgba(255, 206, 86, 0.2)',
                'rgba(75, 192, 192, 0.2)',
                'rgba(153, 102, 255, 0.2)',
                'rgba(255, 159, 64, 0.2)'
            ],
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
            backgroundColor: [
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)',
                'rgba(0,0,0,0)'
            ],
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
          backgroundColor: [
              "#BB5179",
              "#FAFF67",
              "#58A27C",
              "#3C00FF"
          ],
          data: [38, 31, 21, 10]
      }]
    },
    options: {
      title: {
        display: true,
        text: 'Blood Type Ratio'
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
- 線で結ばれた面の「大きさ」、「滑らかさ」を比べてデータの代償を感覚的に掴めるのがレーダーチャートの特徴
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
        backgroundColor: 'RGBA(225,95,150, 0.5)',
        borderColor: 'RGBA(225,95,150, 1)',
        borderWidth: 1,
        pointBackgroundColor: 'RGB(46,106,177)'
      }, {
        label: 'Bob',
        data: [73, 95, 80, 87, 79],
        backgroundColor: 'RGBA(115,255,25, 0.5)',
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
          return  value +  '点'
        }
      }
    }
  });
{{< /chart >}}
