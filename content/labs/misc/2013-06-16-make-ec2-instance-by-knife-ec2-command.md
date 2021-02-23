---
title: knife ec2コマンドで AWS EC2 インスタンスを作成する
author: kazu634
date: 2013-06-16
has_been_twittered:
  - failed
twitter_failure_code:
  - 410
tmac_last_id:
  - 9223372036854775807
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1550;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.0";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:3;s:13:"tweet_log_ids";a:2:{i:0;i:1549;i:1;i:1550;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
author:
  - kazu634
categories:
  - chef
  - インフラ

---
ここ一ヶ月ほどは EC2 インスタンスを作って遊んでいました。Chef を使っていると、knife コマンドで AWS の EC2 インスタンスを作成できると便利です。そこで今回は knife コマンドで ec2 インスタンスを作成するところまでをご紹介します。

なお、Chef serverを構築していると、Chef serverと連携してChefの実行までできるようですが、今回は Chef solo 環境で knife ec2 コマンドを使用するところまでです。

<a href="http://www.flickr.com/photos/42332031@N02/9049601610/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/9049601610/', '');" title="http://aws.amazon.com/jp/ by kazu634, on Flickr"><img class="aligncenter" alt="http://aws.amazon.com/jp/" src="http://farm4.staticflickr.com/3822/9049601610_046fff34ed.jpg" width="226" height="500" /></a>

<!--more-->

## やりたいこと

knifeコマンドのインターフェースを用いて AWS EC2 インスタンスを作成します。Chef Server は無いので、単純にインスタンスを作るところまで。

## Amazon EC2 CLI Toolsのセットアップ

### Amazon EC2 CLI Toolsのダウンロード

<a href="http://www.amazon.com/gp/redirect.html/ref=aws_rc_ec2tools?location=http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip&token=A80325AA4DAB186C80828ED5138633E3F49160D9" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.amazon.com/gp/redirect.html/ref=aws_rc_ec2tools?location=http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip&token=A80325AA4DAB186C80828ED5138633E3F49160D9', 'Amazon EC2 API Tools');" title="Amazon EC2 API Tools"  target="_blank">Amazon EC2 API Tools</a>から、Amazon EC2 CLI Toolsをダウンロードします。ダウンロードしたら解答します:

    wget "http://www.amazon.com/gp/redirect.html/ref=aws_rc_ec2tools?location=http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip&amp;token=A80325AA4DAB186C80828ED5138633E3F49160D9" -O ec2-api-tools.zip
    
    unzip ec2-api-tools.zip
    
    mv ec2-api-tools-1.6.7.3 ~/bin/ec2-api-tools
    

私の場合は ~/bin/ec2-api-tools 配下に格納しました。

ちなみに ~/bin/ec2-api-tools/bin に PATH を通しておきましょう。

### アクセスキー・シークレットアクセスキーの取得

AWSマネジメントコンソールにアクセスして、セキュリティ証明書を選択します:

<a href="http://www.flickr.com/photos/42332031@N02/9055817917/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/9055817917/', '');" title="AWS Management Console | アマゾン ウェブ サービス（AWS 日本語） by kazu634, on Flickr"><img class="aligncenter" alt="AWS Management Console | アマゾン ウェブ サービス（AWS 日本語）" src="http://farm8.staticflickr.com/7402/9055817917_475fa30d76.jpg" width="500" height="199" /></a>

Security Credentialsをクリックします:

<a href="http://www.flickr.com/photos/42332031@N02/9055849587/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/9055849587/', '');" title="IAM Management Console by kazu634, on Flickr"><img class="aligncenter" alt="IAM Management Console" src="http://farm3.staticflickr.com/2848/9055849587_90bc9928ec.jpg" width="500" height="380" /></a>

Access Credentialセクションにアクセスキー・シークレットアクセスキーが表示されます:

<a href="http://www.flickr.com/photos/42332031@N02/9058089732/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.flickr.com/photos/42332031@N02/9058089732/', '');" title="Amazon Web Services by kazu634, on Flickr"><img class="aligncenter" alt="Amazon Web Services" src="http://farm3.staticflickr.com/2857/9058089732_3d97a171a5.jpg" width="500" height="272" /></a>

### 環境変数の設定など

JAVA\_HOMEの設定は各自の環境に応じて設定してください。ACCESS\_KEY, SECRET_KEYは先ほど調べたアクセスキー・シークレットアクセスキーを入力してください:

    export JAVA_HOME=/usr
    
    export EC2_HOME=/home/kazu634/bin/ec2-api-tools
    export PATH=$PATH:$EC2_HOME/bin
    
    export AWS_ACCESS_KEY=your-aws-access-key 
    export AWS_SECRET_KEY=your-aws-secret-key
    
    export EC2_REGION=ap-northeast-1
    export EC2_URL=https://ec2.ap-northeast-1.amazonaws.com
    export EC2_AVAILABILITY_ZONE=ap-northeast-1a
    

### テスト

ec2-describe-regionコマンドを実行して、以下のように表示されれば OK です:

    % ec2-describe-regions
    REGION  eu-west-1       ec2.eu-west-1.amazonaws.com
    REGION  sa-east-1       ec2.sa-east-1.amazonaws.com
    REGION  us-east-1       ec2.us-east-1.amazonaws.com
    REGION  ap-northeast-1  ec2.ap-northeast-1.amazonaws.com
    REGION  us-west-2       ec2.us-west-2.amazonaws.com
    REGION  us-west-1       ec2.us-west-1.amazonaws.com
    REGION  ap-southeast-1  ec2.ap-southeast-1.amazonaws.com
    REGION  ap-southeast-2  ec2.ap-southeast-2.amazonaws.com
    

## knife ec2 コマンドのインストール

gemからインストールします:

    gem install knife-ec2
    

## knife ec2コマンドの使い方

knife ec2コマンドの使い方は以下の通りです:

### EC2インスタンスの作成

knife ec2コマンドは Chef Server の情報をもとにEC2インスタンスをセットアップします。今回私は Chef Server をセットアップしていないため、Chef Serverとの通信をしないように明示的に指定してあげます。

まずは次のようなテンプレートファイルを作成します:

    bash -c '
    aptitude update
    aptitude safe-upgrade -y
    '
    

そして次のようにコマンドを実行します:

    knife ec2 server create -I AMIのイメージ名称 -G セキュリティグループ名 --flavor=t1.micro -S AWSのSSH Key Pair -i SSHのプライベートキー --template-file テンプレート名
    

こうすることで Chef Server との通信を実施せずに、EC2インスタンスの作成だけが実行されます(他に aptitude update && aptitude safe-upgrade も)。私の場合は次のように指定して knife ec2 server create することが多いです:

    knife ec2 server create -I ami-9763e696 -G quicklaunch-1 --flavor=t1.micro -S amazon -i ~/.ssh/amazon.pem --template-file ~/junk/template.erb
    

### EC2インスタンスの一覧取得

knife ec2 server listコマンドを実行します。

### EC2インスタンスの削除

knife ec2 server deleteコマンドを実行します。

## 参考URL

  * <a href="http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SettingUp_CommandLine.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SettingUp_CommandLine.html', 'Setting Up the Amazon EC2 Command Line Interface Tools on Linux/UNIX');" title="Setting Up the Amazon EC2 Command Line Interface Tools on Linux/UNIX"  target="_blank">Setting Up the Amazon EC2 Command Line Interface Tools on Linux/UNIX</a>
  * <a href="http://docs.opscode.com/plugin_knife_ec2.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://docs.opscode.com/plugin_knife_ec2.html', 'knife ec2');" title="knife ec2"  target="_blank">knife ec2</a>
  * <a href="http://wiki.opscode.com/display/chef/EC2+Bootstrap+Fast+Start+Guide" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://wiki.opscode.com/display/chef/EC2+Bootstrap+Fast+Start+Guide', 'EC2 Bootstrap Fast Start Guide');" title="EC2 Bootstrap Fast Start Guide"  target="_blank">EC2 Bootstrap Fast Start Guide</a>
  * <a href="http://www.captnswing.net/2013/01/from-vagrant-to-ec2-with-knife-solo.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.captnswing.net/2013/01/from-vagrant-to-ec2-with-knife-solo.html', 'From Vagrant to EC2 with knife-solo');" title="From Vagrant to EC2 with knife-solo"  target="_blank">From Vagrant to EC2 with knife-solo</a>
