---
title: peco + git ls-files を改良してみた
author: kazu634
date: 2014-12-20
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:5569;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:1;s:11:"tweet_times";i:1;s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";s:98:"ブログに新しい記事を投稿したよ: peco + git ls-files を改良してみた - [link] ";s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:5569;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
tmac_last_id:
  - 565475588425912321
categories:
  - git
  - vim
  - zsh

---
<a href="http://qiita.com/la_luna_azul/items/7998abd0379e8a3248f4" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://qiita.com/la_luna_azul/items/7998abd0379e8a3248f4', 'Git &#8211; pecoを使って生産性を上げるちょっとした工夫 &#8211; Qiita');">Git &#8211; pecoを使って生産性を上げるちょっとした工夫 &#8211; Qiita</a>から少し改良させてみました。改良点は以下の点です:

  * pecoで何も指定しなかった場合は、vimを起動しないようにする
  * gitレポジトリではない場合は、そもそもなにもしないようにする

コードはこちら:

```
# check whether `peco` exists
if which peco > /dev/null; then
  function gim () {
    # check whether the current directory is under `git` repository.
    if git rev-parse 2&gt; /dev/null; then
      local selected_file=$(git ls-files . | peco)

      if [ -n "${selected_file}" ]; then
        vi ${selected_file}
      fi
    fi
  }
fi
```

* * *

### 参考

  * <a href="http://qiita.com/la_luna_azul/items/7998abd0379e8a3248f4" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://qiita.com/la_luna_azul/items/7998abd0379e8a3248f4', 'pecoを使って生産性を上げるちょっとした工夫');">pecoを使って生産性を上げるちょっとした工夫</a>
  * <a href="http://d.hatena.ne.jp/sugyan/20120323/1332507609" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://d.hatena.ne.jp/sugyan/20120323/1332507609', 'カレントディレクトリがGitリポジトリ下か否か判定する &#8211; すぎゃーんメモ');">カレントディレクトリがGitリポジトリ下か否か判定する &#8211; すぎゃーんメモ</a>
  * <a href="http://tkengo.github.io/blog/2013/05/12/zsh-vcs-info/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://tkengo.github.io/blog/2013/05/12/zsh-vcs-info/', 'zshのターミナルにリポジトリの情報を表示してみる &#8211; けんごのお屋敷');">zshのターミナルにリポジトリの情報を表示してみる &#8211; けんごのお屋敷</a>
