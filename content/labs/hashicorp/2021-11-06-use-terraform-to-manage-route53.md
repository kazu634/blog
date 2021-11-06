+++
title = "TerraformでRoute53を管理してみたメモ"
date = 2021-11-06T14:21:43+09:00
description = "これまでは`roadwork`で`Route53`を管理していたのですが、お仕事関係のこともあってTerraformを利用して、`Route53`を管理してみようと思いたち、始めてみました。"
tags = ["Terraform", "Linux"]
categories = ["Labs", "Infra", "HashiCorp"]
author = "kazu634"
+++

これまでは`roadwork`で`Route53`を管理していたのですが、お仕事関係のこともあってTerraformを利用して、`Route53`を管理してみようと思いたち、始めてみました。

## 前提とする環境
前提とする環境は以下になります:

```
kazu634@bastion2004% cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.3 LTS"
```

## インストール
[ここ](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)を参考にしてインストールを行います。ログはこちら:

```bash
kazu634@bastion2004% sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
[sudo] kazu634 のパスワード:
ヒット:1 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal InRelease
ヒット:2 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal-updates InRelease
ヒット:3 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal-backports InRelease
ヒット:4 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal-security InRelease
ヒット:5 https://download.docker.com/linux/ubuntu focal InRelease
ヒット:6 https://apt.releases.hashicorp.com focal InRelease
ヒット:7 http://ppa.launchpad.net/git-core/ppa/ubuntu focal InRelease
ヒット:8 https://packages.grafana.com/oss/deb stable InRelease
パッケージリストを読み込んでいます... 完了
パッケージリストを読み込んでいます... 完了
依存関係ツリーを作成しています
状態情報を読み取っています... 完了
curl はすでに最新バージョン (7.68.0-1ubuntu2.7) です。
gnupg はすでに最新バージョン (2.2.19-3ubuntu2.1) です。
software-properties-common はすでに最新バージョン (0.98.9.5) です。
software-properties-common は手動でインストールしたと設定されました。
アップグレード: 0 個、新規インストール: 0 個、削除: 0 個、保留: 0 個。
kazu634@bastion2004% curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
kazu634@bastion2004% sudo apt-get update && sudo apt-get install terraform
ヒット:1 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal InRelease
ヒット:2 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal-updates InRelease
ヒット:3 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal-backports InRelease
ヒット:4 http://192.168.10.200:8080/ubuntu/apt-mirror/mirror/jp.archive.ubuntu.com/ubuntu focal-security InRelease
ヒット:5 https://download.docker.com/linux/ubuntu focal InRelease
ヒット:6 https://apt.releases.hashicorp.com focal InRelease
ヒット:7 http://ppa.launchpad.net/git-core/ppa/ubuntu focal InRelease
ヒット:8 https://packages.grafana.com/oss/deb stable InRelease
パッケージリストを読み込んでいます... 完了
パッケージリストを読み込んでいます... 完了
依存関係ツリーを作成しています
状態情報を読み取っています... 完了
以下のパッケージが新たにインストールされます:
  terraform
アップグレード: 0 個、新規インストール: 1 個、削除: 0 個、保留: 0 個。
32.7 MB のアーカイブを取得する必要があります。
この操作後に追加で 79.3 MB のディスク容量が消費されます。
取得:1 https://apt.releases.hashicorp.com focal/main amd64 terraform amd64 1.0.9 [32.7 MB]
32.7 MB を 2秒 で取得しました (21.2 MB/s)
以前に未選択のパッケージ terraform を選択しています。
(データベースを読み込んでいます ... 現在 178635 個のファイルとディレクトリがインストールされています。)
.../terraform_1.0.9_amd64.deb を展開する準備をしています ...
terraform (1.0.9) を展開しています...
terraform (1.0.9) を設定しています ...
```

動作確認はこんな感じで行います:

```bash
kazu634@bastion2004% terraform -help
Usage: terraform [global options] <subcommand> [args]

The available commands for execution are listed below.
The primary workflow commands are given first, followed by
less common or more advanced commands.

Main commands:
  init          Prepare your working directory for other commands
  validate      Check whether the configuration is valid
  plan          Show changes required by the current configuration
  apply         Create or update infrastructure
  destroy       Destroy previously-created infrastructure

All other commands:
  console       Try Terraform expressions at an interactive command prompt
  fmt           Reformat your configuration in the standard style
  force-unlock  Release a stuck lock on the current workspace
  get           Install or upgrade remote Terraform modules
  graph         Generate a Graphviz graph of the steps in an operation
  import        Associate existing infrastructure with a Terraform resource
  login         Obtain and save credentials for a remote host
  logout        Remove locally-stored credentials for a remote host
  output        Show output values from your root module
  providers     Show the providers required for this configuration
  refresh       Update the state to match remote systems
  show          Show the current state or a saved plan
  state         Advanced state management
  taint         Mark a resource instance as not fully functional
  test          Experimental support for module integration testing
  untaint       Remove the 'tainted' state from a resource instance
  version       Show the current Terraform version
  workspace     Workspace management

Global options (use these before the subcommand, if any):
  -chdir=DIR    Switch to a different working directory before executing the
                given subcommand.
  -help         Show this help output, or the help for a specified subcommand.
  -version      An alias for the "version" subcommand.
```

## TerraformでRoute53を管理する
ここから`Terraform`で`Route53`を管理していきます。

### tfファイルの作成
新しくディレクトリを作成し、ここでtfファイルの作成をしていきます。`main.tf`をこのように作成していきます:

```
provider "aws" {
  region = "ap-northeast-1"
  access_key = "very-very-secret"
  secret_key = "very-very-secret"
}
```

### terraform initの実行
`main.tf`ファイルが格納されているディレクトリで、`terraform init`を実行します。

```bash
kazu634@bastion2004% terraform init
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.63.0...
- Installed hashicorp/aws v3.63.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### AWSから現状の定義をインポートする
`terraform import`コマンドを実行すると、AWSから現状の定義をインポートできるということで、インポートしてみました。

なお、`Terraform`は実行した結果をステートファイルというファイルに格納して、そのステートファイルに記載の状態を正として変更点を洗い出します。ここが実際の状況と食い違っていると、悲劇が始まります。。

現状の定義を`terraform`コマンドでインポートするには、事前に`main.tf`で空のリソース定義を記載する必要があります。`route53`で定義できるリソースは二種類あります。

1. `zone`: DNSゾーンを定義します
2. `record`: DNSレコードを定義します

これらの空の定義を、`route53`上のゾーン、レコード定義分作成してあげます。

#### zoneの空の定義
`zone`の定義は以下のようになります:

```
resource "aws_route53_zone" "kazu634" {}
```

#### recordの空の定義
`record`の定義は以下のようになります:

```
resource "aws_route53_record" "blog-a" {}
```

### terraformコマンドによるインポート
`terraform`コマンドでインポートする方法を説明します。

#### zoneのインポート
`zone`をインポートする際は、次のコマンドを実行します: `terraform import aws_route53_zone.xxx <Hosted-Zone-ID>`。

`xxx`には`main.tf`で指定した`zone`定義のリソース名を指定します。私はこのように指定したので、

```
resource "aws_route53_zone" "kazu634" {}
```

`xxx`には`kazu634`を指定します。`<Hosted-Zone-ID>`には、AWS Consoleから、`Route53`を開いて、ゾーン定義の詳細部分でIDを調べます:




これでインポートの準備ができました。次のようにコマンドを実行すると、インポートできます。

```bash
$ terraform import aws_route53_zone.kazu634 ZI0FHD0611WVA
```

#### recordのインポート
`record`をインポートする場合は、次のコマンドを実行します: `terraform import aws_route53_record.<レコード名> <Hosted-Zone-ID>_<FQDN>_<レコード種別>`。

レコード名には、`main.tf`ファイルに記載の名称を指定します。例えば、次のレコード名にインポートする場合は、

```
resource "aws_route53_record" "blog-a" {}
```

`blog-a`がレコード名になります。

`Route53`上で`blog.kazu634.com`をレコード登録している場合は、`FQDN`は`blog.kazu634.com`になります。レコード種別は、DNSレコードの種別です。`A`レコードとか、`CNAME`レコードとかです。

例えば、`A`レコードをインポートする場合は、こんな感じでインポートします。

```
$ terraform import aws_route53_record.blog-caa ZI0FHD0611WVA_blog.kazu634.com_A
```

このインポート作業を既存レコードの数、実施します。

### 準備完了
`Route53`に登録しているゾーン、レコード分インポートを行ったら、ステートファイルの準備はできました。

この状態で`terraform plan`コマンドを実行すると、`main.tf`ファイルの中身が空のため、エラーになります。リソース定義の中身を入れていき、`terraform plan`コマンドで差分がなくなるようにしましょう。

例えば`blog.kazu634.com`の場合は、このように記載しました:

```
resource "aws_route53_record" "blog-a" {
  zone_id = aws_route53_zone.kazu634.zone_id
  name    = "blog.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = 3600
  type    = "A"
}
```


## 振り返り
今回は`roadworker`で管理していたものからの移行でしたが、手間を考えると0から設定を作っていく方がお手軽ですね。もっと簡単に既存の`Route53`定義を`Terraform`に落とし込んでいけると良いのですが。


## 参考リンク
- [Install Terraform \| Terraform \- HashiCorp Learn](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
- [terraformでroute53の管理](https://blog.n-t.jp/tech/terraform-route53/)
