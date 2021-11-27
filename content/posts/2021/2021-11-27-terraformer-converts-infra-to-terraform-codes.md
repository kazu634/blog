+++
title = "terraformerを試しに使ってみましたよ"
date = 2021-11-27T22:13:43+09:00
description = "必要に迫られて[terraformer](https://github.com/GoogleCloudPlatform/terraformer)を使ってみました。`terraform import`をお手軽簡単にできるものみたいです。"
tags = ["terraform"]
categories = ["インフラ", "HashiCorp"]
author = "kazu634"
+++

必要に迫られて[terraformer](https://github.com/GoogleCloudPlatform/terraformer)を使ってみました。`terraform import`をお手軽簡単にできるものみたいです。

## terraformerとは
各種クラウドサービスなどから、`Terraform`のコードを生成してくれるツールです。インフラからソースコードを生成します。

## 事前準備
[terraformer](https://github.com/GoogleCloudPlatform/terraformer)を利用する前の準備作業を説明します。

### AWSのIAMユーザー作成
今回はAWSからコードを生成するので、AWSから情報を取得するIAMユーザーを作成します。ポリシーは`ReadOnlyAccess`を割り当ててみました:

<a data-flickr-embed="true" href="https://www.flickr.com/photos/42332031@N02/51708608624/in/dateposted-public/" title="IAM Management C"><img src="https://live.staticflickr.com/65535/51708608624_6881a50569_z.jpg" width="640" height="491" alt="IAM Management C"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

### AWS認証情報を設定ファイルに格納
`~/.aws/credentials`に先ほど作成したIAMユーザーのアクセスキー・シークレットキーの情報、あとはリージョン情報を格納します:

```ini
[default]
aws_access_key_id=<ここにアクセスキー>
aws_secret_access_key=<ここにシークレットキー>
region=ap-northeast-1
```

## terraformerのインストール
それではインストールしていきます:

```bash
kazu634@bastion2004% export PROVIDER=all
kazu634@bastion2004% curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   666  100   666    0     0   2466      0 --:--:-- --:--:-- --:--:--  2475
100  358M  100  358M    0     0  21.0M      0  0:00:17  0:00:17 --:--:-- 26.9M
kazu634@bastion2004% chmod +x terraformer-${PROVIDER}-linux-amd64
kazu634@bastion2004% sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer
[sudo] password for kazu634:
```

## terraformerを使ってみる
まずはAWSの情報を取得するということを宣言するようで、`init.tf`に`provider “aws” {}`を書き込み、`terraform init`を実行します:

```bash
kazu634@bastion2004% echo 'provider "aws" {}' > init.tf
kazu634@bastion2004% terraform init
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.67.0...
- Installed hashicorp/aws v3.67.0 (signed by HashiCorp)

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

`Route53`の情報を取得する場合は、次のようにします:

```bash
kazu634@bastion2004% terraformer import aws --resources=route53
2021/11/27 21:25:49 aws importing default region
2021/11/27 21:25:51 aws importing... route53
2021/11/27 21:25:52 aws done importing route53
2021/11/27 21:25:52 Number of resources for service route53: 16
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_kazu634-002E-com-002E-_NS_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_blog-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_pocket-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_minio-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_openvpn-002E-kazu634-002E-com-002E-_CNAME_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_git-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_kazu634-002E-com-002E-_SOA_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_blog-002E-kazu634-002E-com-002E-_CAA_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_grafana-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_gitea-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_test-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_g-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_faktory-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:52 Refreshing state... aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com
2021/11/27 21:25:54 Refreshing state... aws_route53_record.tfer--ZI0FHD0611WVA_drone-002E-kazu634-002E-com-002E-_A_
2021/11/27 21:25:55 Filtered number of resources for service route53: 16
2021/11/27 21:25:55 aws Connecting....
2021/11/27 21:25:55 aws save route53
2021/11/27 21:25:55 aws save tfstate for route53
```

すると`generated`というディレクトリーが作成され、その中に`terraform`のソースコードが格納されます:

```bash
kazu634@bastion2004% ll
total 28K
drwxrwxr-x  4 kazu634 kazu634 4.0K Nov 27 21:25 .
drwxr-xr-x 13 kazu634 kazu634 4.0K Nov 26 23:51 ..
drwxrwxr-x  3 kazu634 kazu634 4.0K Nov 27 21:25 generated
-rw-rw-r--  1 kazu634 kazu634   18 Nov 27 00:54 init.tf
drwxr-xr-x  3 kazu634 kazu634 4.0K Nov 27 00:54 .terraform
-rw-r--r--  1 kazu634 kazu634 1.1K Nov 27 00:54 .terraform.lock.hcl
```

`generated`の中身はこのようになっています:

```bash
kazu634@bastion2004% pwd
/home/kazu634/works/mnt/others/terraformer/generated

kaws
    └── route53
        ├── outputs.tf
        ├── provider.tf
        ├── route53_record.tf
        ├── route53_zone.tf
        └── terraform.tfstate

2 directories,  5 files
```

たとえば`route53_record.tf`の中身はこのようになっています:

```bash
kazu634@bastion2004% cat route53_record.tf
resource "aws_route53_record" "tfer--ZI0FHD0611WVA_blog-002E-kazu634-002E-com-002E-_A_" {
  name    = "blog.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "86400"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_blog-002E-kazu634-002E-com-002E-_CAA_" {
  name    = "blog.kazu634.com"
  records = ["0 issue \"letsencrypt.org\""]
  ttl     = "86400"
  type    = "CAA"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_drone-002E-kazu634-002E-com-002E-_A_" {
  name    = "drone.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_faktory-002E-kazu634-002E-com-002E-_A_" {
  name    = "faktory.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_g-002E-kazu634-002E-com-002E-_A_" {
  name    = "g.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_git-002E-kazu634-002E-com-002E-_A_" {
  name    = "git.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_gitea-002E-kazu634-002E-com-002E-_A_" {
  name    = "gitea.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_grafana-002E-kazu634-002E-com-002E-_A_" {
  name    = "grafana.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_kazu634-002E-com-002E-_A_" {
  name    = "kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_kazu634-002E-com-002E-_NS_" {
  name    = "kazu634.com"
  records = ["ns-1111.awsdns-10.org.",  "ns-469.awsdns-58.com.",  "ns-720.awsdns-26.net.",  "ns-1844.awsdns-38.co.uk."]
  ttl     = "172800"
  type    = "NS"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_kazu634-002E-com-002E-_SOA_" {
  name    = "kazu634.com"
  records = ["ns-720.awsdns-26.net. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400"]
  ttl     = "900"
  type    = "SOA"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_minio-002E-kazu634-002E-com-002E-_A_" {
  name    = "minio.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_openvpn-002E-kazu634-002E-com-002E-_CNAME_" {
  name    = "openvpn.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "CNAME"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_pocket-002E-kazu634-002E-com-002E-_A_" {
  name    = "pocket.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}

resource "aws_route53_record" "tfer--ZI0FHD0611WVA_test-002E-kazu634-002E-com-002E-_A_" {
  name    = "test.kazu634.com"
  records = ["52.193.98.253"]
  ttl     = "3600"
  type    = "A"
  zone_id = "${aws_route53_zone.tfer--ZI0FHD0611WVA_kazu634-002E-com.zone_id}"
}
```

## まとめ
`terraform import`コマンドを使うと、AWSリソースのIDをいちいち調べて指定して、一つずつインポートするという苦行をしていたのですが、[terraformer](https://github.com/GoogleCloudPlatform/terraformer)を利用するとコマンド一発で`terraform`のコードに落とし込んでもらえるので、だいぶ楽になるということがわかりました。はまるとすると、IAMとかポリシーの部分ですかね。
