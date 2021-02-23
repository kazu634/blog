+++
draft = false
description = "お仕事で必要に迫られたのでAWS EC2の利用状況をコマンドラインから取得する方法を調べてみました"
tags = []
categories = ["AWS"]
author = "kazu634"
date = "2016-11-06T23:38:21+08:00"
title = "aws-cliを用いてEC2インスタンスの情報を取得する"
images = ["https://c1.staticflickr.com/9/8561/15670725648_356a50f786.jpg"]
+++

お仕事で必要に迫られたのでAWS EC2の利用状況をコマンドラインから取得する方法を調べてみました。どうやら`aws-cli`というのを使うのがお手軽みたい。

## インストール方法
このページを参照すると幸せになれます: [Installing the AWS Command Line Interface \- AWS Command Line Interface](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)

## awe-cliの初期設定
`aws configure`を実行します。AWS Access Key ID, Secret Access Keyは各自のを入力してください。

```
% aws configure
AWS Access Key ID [None]: xxxxx
AWS Secret Access Key [None]: xxxxx
Default region name [None]: ap-northeast-1
Default output format [None]: json
```

## 今月の見込み支払い金額情報の取得
今月の見込み支払金額情報というのを取得できたので取得してみました。こんな感じです:

```
% aws cloudwatch --region us-east-1 get-metric-statistics --namespace 'AWS/Billing' --metric-name EstimatedCharges --start-time 2016-11-05T00:00:00+00:00 --end-time 2016-11-05T23:59:59+00:00 --period 86400 --statistics 'Sum' --dimensions "Name=Currency,Value=USD"
{
    "Datapoints": [
        {
            "Timestamp": "2016-11-05T00:00:00Z",
            "Sum": 25.94,
            "Unit": "None"
        }
    ],
    "Label": "EstimatedCharges"
}
```

これだとごちゃごちゃした情報がくっついているため、`jq`と組み合わせてみます:

```
% aws cloudwatch --region us-east-1 get-metric-statistics --namespace 'AWS/Billing' --metric-name EstimatedCharges --start-time 2016-11-05T00:00:00+00:00 --end-time 2016-11-05T23:59:59+00:00 --period 86400 --statistics 'Sum' --dimensions "Name=Currency,Value=USD" | jq '.Datapoints[].Sum'
25.94
```

## EC2インスタンス情報の取得
EC2インスタンス情報の取得方法をまとめました。基本的に以下の情報を取得することを目指しています:

- インスタンスID
- インスタンス種別
- インスタンスを起動した時間

### インスタンスID一覧の取得
インスタンスID一覧の取得方法です:

```
% aws ec2 describe-instances  | jq '.Reservations[].Instances[].InstanceId'
"i-ddca0b53"
"i-83d6110d"
"i-399657b7”
```

起動しているもののみを取得する場合は以下のようにします:

```
% aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" | jq '.Reservations[].Instances[].InstanceId'
"i-83d6110d"
```

### 起動中のインスタンスID, インスタンス種別, 起動時間の取得
`jq`を使って絞り込んでいくと、こんな形で必要な情報を取得できました:

```
% aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" | jq '.Reservations[].Instances[] | {InstanceId, InstanceType, LaunchTime}'
{
  "InstanceId": "i-83d6110d",
  "InstanceType": "t2.nano",
  "LaunchTime": "2016-11-01T20:32:07.000Z"
}
```

上の例では、起動しているインスタンスのID, インスタンス種別、起動時間を取得しています。

インスタンス種別と起動した時間がわかれば、これまでにかかった費用が計算できるので、後はそれでゴニョゴニョすれば良さそうです。

## 参考
* [AWS CLIを使ってEC2インスタンスの情報を取得する \- Qiita](http://qiita.com/toshiro3/items/37821bdcc50c8b6d06dc)
* [AWSのCloudWatchで取得できるBillingの情報を毎日Slackに通知させて費用を常に把握する \- さよならインターネット](http://blog.kenjiskywalker.org/blog/2015/04/20/aws-cloudwatch-billing-chatops/)
* [AWS CLIのインストールから初期設定メモ \- Qiita](http://qiita.com/n0bisuke/items/1ea245318283fa118f4a)
