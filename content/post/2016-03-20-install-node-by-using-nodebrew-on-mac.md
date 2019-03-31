+++
Categories = ["node.js"]
Description = "Hubot使ってみたかったから、nodebrewを使って、node.jsをMac (El Capitan 10.11.3)にインストールしてみました。"
Tags = []
date = "2016-03-20T14:53:36+08:00"
title = "nodebrewを使って、node.jsをMacにインストールしてみた"
url = "/2016/03/20/install-node-by-using-nodebrew-on-mac/"
thumbnail = "images/4932794177_e73e90a820_z.jpg"
+++

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/ncc_badiey/4932794177/in/photolist-8vTRRt-8vTGyg-8GHj9Z-8vWTLy-8vTUtF-8vTTzr-8vWUP7-8vWW11-8vTSFV-c6cfGW-8vQPme-a77qLQ-8vTT8t-8THvsD-ma59Cy-8vWVrU-8vWUSU-dQUJyT-8vTRZp-8vWUr9-8vWUjU-8vTSar-8vWTFf-8vWW5y-8vWUwh-bAnNC8-8vTTrV-8vWUBd-8vWWyL-8vWVRA-bufANU-8vTUkc-8vTRAa-8vTS6K-8vTTut-8vTTS8-8vTSyP-8vWWrY-8vWVLu-ma5bEE-ma5hdd-rfmy16-ma4gge-ma4fKe-ma4n3p-ma5iqo-ma3zf4-ma5kDG-ma5ePf-ma4ike" title="Node.js Knockout"><img src="https://farm5.staticflickr.com/4120/4932794177_e73e90a820_z.jpg" width="640" height="425" alt="Node.js Knockout"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

`Hubot`使ってみたくて、`nodebrew`を使って、`node.js`をMac (El Capitan 10.11.3)にインストールしてみました。

## nodebrewのインストール
`brew`コマンドを使って、`nodebrew`をインストールします:

```
% brew install nodebrew
==> Downloading https://github.com/hokaccha/nodebrew/archive/v0.9.2.tar.gz
==> Downloading from https://codeload.github.com/hokaccha/nodebrew/tar.gz/v0.9.2
######################################################################## 100.0%
==> /usr/local/Cellar/nodebrew/0.9.2/bin/nodebrew setup_dirs
==> Caveats
Add path:
  export PATH=$HOME/.nodebrew/current/bin:$PATH

To use Homebrew's directories rather than ~/.nodebrew add to your profile:
  export NODEBREW_ROOT=/usr/local/var/nodebrew

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d

zsh completion has been installed to:
  /usr/local/share/zsh/site-functions
==> Summary
🍺  /usr/local/Cellar/nodebrew/0.9.2: 7 files, 34.4K, built in 5 seconds
```

## nodebrewのセットアップ
`${HOME}/.nodebrew/current/bin`にパスを通しておく必要があるようなので、`${HOME}/.zshenv`に以下を追記しました (`bash`使っている人は、`${HOME}/.bash_env`などに適宜読み替えてくださいね):

```
# === nodebrew ===
case ${OSTYPE} in
  *)
  if [ -e /usr/local/bin/nodebrew ]; then
    PATH=${HOME}/.nodebrew/current/bin:${PATH}
    export PATH
  fi
  ;;
esac
```

訳わからなかったけど、`${HOME}/.nodebrew/src`が存在しないと怒られたので、自分で作成しました:

```
% mkdir -p ${HOME}/.nodebrew/src/
```

## nodebrewの使い方
`nodebrew`の簡単な使い方です。

### インストールできるnode.jsの一覧を取得
`nodebrew ls-remote`を実行します:

```
% nodebrew ls-remote
v0.0.1    v0.0.2    v0.0.3    v0.0.4    v0.0.5    v0.0.6

[...snip...]

v4.4.0

[...snip...]

io@v3.3.0 io@v3.3.1
```

### node.jsのインストール
`nodebrew install-binary`でダウンロードしてきて、`nodebrew use`で

```
% nodebrew install-binary v4.4.0
fetch: http://nodejs.org/dist/v4.4.0/node-v4.4.0-darwin-x64.tar.gz
######################################################################## 100.0%
Install successful

% nodebrew ls
v4.4.0

current: none

% nodebrew use v4.4.0
use v4.4.0

% nodebrew ls
v4.4.0

current: v4.4.0
```

これで利用できるようになっているはず:

```
% node -v
v4.4.0
```

うまくいかないようなら、`${PATH}`の設定が反映されていないと思うので、`exec -l ${SHELL}`を実行してみましょう。

## その他、やること
`npm`のバージョンが低くて`npm install`が失敗する場合があるらしいので、以下のコマンドを実行し`npm`のバージョンを上げておきます:

```
% npm -v
2.14.20
% npm install -g npm
/Users/kazu634/.nodebrew/node/v4.4.0/bin/npm -> /Users/kazu634/.nodebrew/node/v4.4.0/lib/node_modules/npm/bin/npm-cli.js
npm@3.8.2 /Users/kazu634/.nodebrew/node/v4.4.0/lib/node_modules/npm
% npm -v
3.8.2
```

## 参考にしたサイト
- [nodebrew で Mac の Node.js 環境をスッキリさせた - akiyoko blog](http://akiyoko.hatenablog.jp/entry/2015/06/20/132239)
