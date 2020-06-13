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

