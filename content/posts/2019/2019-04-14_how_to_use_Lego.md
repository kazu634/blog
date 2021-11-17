+++
title="Legoの使い方メモ"
date=2019-04-14T15:04:05Z
publishdate=2019-04-14T15:04:05Z
description="Legoを用いたDNS経由でのSSL/TSL証明書取得について調べた内容をまとめました"
categories = ["インフラ"]
author = "kazu634"
tags = ["Lego", "Let'sEncrypt"]
+++

[Lego](https://github.com/go-acme/lego)を用いてSSL/TSL証明書を取得する方法を説明します。ここではDNS認証でSSL/TSL証明書を取得する方法を説明します。

## LegoとLet’s Encrypt
[Let&#39;s Encrypt](https://letsencrypt.org/)はSSL/TSL証明書を発行してくれるサービスです。

SSL/TSL証明書を発行するにあたり、そのドメインの所有者が本当に手続きをしているのか本人確認の手続きをします。

手続き方法には以下の方法があります。

### HTTP-01認証
ドメインの所有者であれば、そのドメインにアクセスした際に表示されるコンテンツを自由にできるはずですので、それを利用した認証方式です。具体的には[Let&#39;s Encrypt](https://letsencrypt.org/)から送られてきたトークンを記入したファイルをウェブサーバで配信できる状態にして、[Let&#39;s Encrypt](https://letsencrypt.org/)にそのファイル・トークンを確認してもらうことで、ドメインを所有していることを証明します。

{{< mermaid >}}
sequenceDiagram
    participant User
    participant Web Server
    participant Let’s Encrypt
    participant DNS

    Note over User, DNS: 1. Resolve Host Name
    User ->> DNS: Add A/CNAME record

    Note over User, DNS: 2. Start Listening (Port 80)
    User ->> Web Server: Set up Web Server

    Note over User, DNS: 3. Request SSL/TSL Certificate
    User ->> Let’s Encrypt: Request
    Let’s Encrypt ->> User: File name
    Let’s Encrypt ->> User: Token
    User ->> Web Server: Put the file with the token
    User ->> Let’s Encrypt: Request to continue
    Let’s Encrypt ->> DNS: Name Resolution Request
    DNS ->> Let’s Encrypt: Name Resolution Response
    Let’s Encrypt ->> Web Server: HTTP Request (Port 80) via Internet
    Web Server ->> Let’s Encrypt: HTTP Response (200) with the valid token
    Let’s Encrypt ->> User: SSL/TSL Certificate
{{< /mermaid >}}

### DNS-01認証
ドメインの所有者であれば、

1. そのドメインのサブドメインを作成できる
2. 作成したサブドメインのTXTレコードを自由に設定できる

はずですので、それを利用した認証方式です。[Let&#39;s Encrypt](https://letsencrypt.org/)から送られてきたトークンをTXTレコードに指定し、それを[Let&#39;s Encrypt](https://letsencrypt.org/)に確認してもらうことで、ドメインを所有していることを証明します。

{{<mermaid align="center">}}
sequenceDiagram
    participant User
    participant Let’s Encrypt
    participant DNS

    Note over User, DNS: 1. Request SSL/TSL Certificate
    User ->> Let’s Encrypt: Request
    Let’s Encrypt ->> User: Return the key
    Note over User, DNS: 2. Specify TXT record
    User ->> DNS: Specify the key to the TXT record
    Note over User, DNS: 3. Continue the Request Process
    User ->> Let’s Encrypt: Request to continue
    Let’s Encrypt ->> DNS: Check the TXT record
    DNS ->> Let’s Encrypt: Return the TXT record
    alt TXT record: valid
        Let’s Encrypt ->> User: SSL/TSL Certificate
    else TXT record: not valid
        Let’s Encrypt ->> User: Failure Notice
    end
{{< /mermaid >}}

### ここまでのまとめ
[Lego](https://github.com/go-acme/lego)はコマンドラインで[Let&#39;s Encrypt](https://letsencrypt.org/)を用いてSSL/TSL証明書を発行するツールです。DNS認証にも対応しており、各種マネージドのDNSサービスを利用することで、自動的にTXTレコードを変更して、SSL/TSL証明書を取得することができます。

おおまかな処理の流れをまとめると、以下のようになります。[Lego](https://github.com/go-acme/lego)を利用することで、煩雑な手続きをまとめて実行してくれていることがわかると思います:

{{<mermaid align="center">}}
sequenceDiagram
    participant User
    participant Lego
    participant Let’s Encrypt
    participant DNS

    User ->> Lego: Request
    Lego ->> Let’s Encrypt: Request
    Let’s Encrypt ->> Lego: Return the key
    Lego ->> DNS: Create the sub domain
    Lego ->> DNS: Specify the key to the TXT record of the sub domain
    note over Lego,DNS: Wait for TXT record to propagate
    Lego ->> Let’s Encrypt: Request to continue
    Let’s Encrypt ->> DNS: Check the TXT record
    DNS ->> Let’s Encrypt: Return the TXT record
    Let’s Encrypt ->> Lego: SSL/TSL Certificate
    Lego ->> User: SSL/TSL Certificate
{{< /mermaid >}}

この記事ではAWSのマネージドDNSサービス・[Amazon Route 53](https://aws.amazon.com/route53/)を利用して、SSL/TSL証明書を取得してみます。

## Legoのインストール方法
githubからダウンロードします。

### ダウンロード
ファイルのダウンロードは何でも構いませんが、たとえば以下のようになるかと思います:

```sh
kazu634@ip-10-0-1-234% wget https://github.com/go-acme/lego/releases/download/v2.4.0/lego_v2.4.0_linux_amd64.t
ar.gz
--2019-03-31 04:33:09--  https://github.com/go-acme/lego/releases/download/v2.4.0/lego_v2.4.0_linux_amd64.tar.gz
Resolving github.com (github.com)... 192.30.255.112, 192.30.255.113
Connecting to github.com (github.com)|192.30.255.112|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-production-release-asset-2e65be.s3.amazonaws.com/37038121/00375780-500b-11e9-89db-d849ef1f49d0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20190331%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190331T043309Z&X-Amz-Expires=300&X-Amz-Signature=bd866b55d7db150708b3b6a778430195ae6e82653c58cd0fa30b72c5abcd04dd&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dlego_v2.4.0_linux_amd64.tar.gz&response-content-type=application%2Foctet-stream [following]
--2019-03-31 04:33:10--  https://github-production-release-asset-2e65be.s3.amazonaws.com/37038121/00375780-500b-11e9-89db-d849ef1f49d0?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20190331%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190331T043309Z&X-Amz-Expires=300&X-Amz-Signature=bd866b55d7db150708b3b6a778430195ae6e82653c58cd0fa30b72c5abcd04dd&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dlego_v2.4.0_linux_amd64.tar.gz&response-content-type=application%2Foctet-stream
Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.17.224
Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.17.224|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 8597077 (8.2M) [application/octet-stream]
Saving to: ‘lego_v2.4.0_linux_amd64.tar.gz’

lego_v2.4.0_linux_amd64.tar 100%[=========================================>]   8.20M  3.81MB/s    in 2.2s

2019-03-31 04:33:12 (3.81 MB/s) - ‘lego_v2.4.0_linux_amd64.tar.gz’ saved [8597077/8597077]
```

### 解凍
解凍方法は以下のようになるかと思います:

```sh
kazu634@ip-10-0-1-234% tar xvzf lego_v2.4.0_linux_amd64.tar.gz                                      [~/works]
CHANGELOG.md
LICENSE
lego
kazu634@ip-10-0-1-234% ll                                                                           [~/works]
total 35M
drwxr-xr-x  2 kazu634 kazu634 4.0K Mar 31 04:34 .
drwxr-xr-x 14 kazu634 kazu634 4.0K Mar 31 04:34 ..
-rw-rw-r--  1 kazu634 kazu634  18K Mar 26 19:52 CHANGELOG.md
-rwxrwxr-x  1 kazu634 kazu634  27M Mar 26 20:02 lego
-rw-rw-r--  1 kazu634 kazu634 8.2M Mar 26 20:06 lego_v2.4.0_linux_amd64.tar.gz
-rw-rw-r--  1 kazu634 kazu634 1.1K Mar 26 19:52 LICENSE
```

## 使い方
ここでは[Lego](https://github.com/go-acme/lego)の使い方を説明します。

### 下準備
コマンドラインのヘルプはこんな感じになります:

```sh
kazu634@ip-10-0-1-234% ./lego dnshelp
Credentials for DNS providers must be passed through environment variables.

To display the documentation for a DNS providers:

        $ lego dnshelp -c code

All DNS codes:
        acme-dns, alidns, auroradns, azure, bluecat, cloudflare, cloudns, cloudxns, conoha, designate, digitalocean, dnsimple, dnsmadeeasy, dnspod, dode, dreamhost, duckdns, dyn, exec, exoscale, fastdns, gandi, gandiv5, gcloud, glesys, godaddy, hostingde, httpreq, iij, inwx, lightsail, linode, linodev4, manual, mydnsjp, namecheap, namedotcom, netcup, nifcloud, ns1, oraclecloud, otc, ovh, pdns, rackspace, rfc2136, route53, sakuracloud, selectel, stackpath, transip, vegadns, vscale, vultr, zoneee

More information: https://go-acme.github.io/lego/dns
```

[Amazon Route 53](https://aws.amazon.com/route53/)特有の注意事項はこちら:

```sh
kazu634@ip-10-0-1-234% ./lego dnshelp -c route53
Configuration for Amazon Route 53.
Code: 'route53'

Credentials:
        - "AWS_ACCESS_KEY_ID":
        - "AWS_HOSTED_ZONE_ID":
        - "AWS_REGION":
        - "AWS_SECRET_ACCESS_KEY":

Additional Configuration:
        - "AWS_POLLING_INTERVAL": Time between DNS propagation check
        - "AWS_PROPAGATION_TIMEOUT": Maximum waiting time for DNS propagation
        - "AWS_TTL": The TTL of the TXT record used for the DNS challenge
```

ここから各種環境変数を指定して利用する必要があるとわかります:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_HOSTED_ZONE_ID`
- `AWS_REGION`

つまりこのようなフローになります:

{{<mermaid align="center">}}
sequenceDiagram
    participant User
    participant Lego
    participant Let’s Encrypt
    participant Route53

    note over User,Route53: Preparation
    User ->> User: Specify AWS Environment Variables

    note over User,Route53: Actual Operation
    User ->> Lego: Request
    Lego ->> Let’s Encrypt: Request
    Let’s Encrypt ->> Lego: Return the key
    Lego ->> Route53: Create the sub domain
    Lego ->> Route53: Specify the key to the TXT record of the sub domain
    note over Lego,Route53: Wait for TXT record to propagate
    Lego ->> Let’s Encrypt: Request to continue
    Let’s Encrypt ->> Route53: Check the TXT record
    Route53 ->> Let’s Encrypt: Return the TXT record
    Let’s Encrypt ->> Lego: SSL/TSL Certificate
    Lego ->> User: SSL/TSL Certificate
{{< /mermaid >}}

### AWS_ACCESS_KYE_IDとAWS_SECRET_ACCESS_KEYの調べ方
後で書く

### AWS_HOSTED_ZONE_IDの調べ方
[Amazon Route 53](https://aws.amazon.com/route53/)で`Hosted Zone ID`の部分を調べます:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/33730730248/in/dateposted/" title="Untitled"><img src="https://live.staticflickr.com/7899/33730730248_53708c0113.jpg" width="500" height="349" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

### 証明書の取得
それでは証明書を取得してみます。以下のように実行することになると思います:

```sh
kazu634@ip-10-0-1-234% export AWS_ACCESS_KEY_ID="xxxx"
kazu634@ip-10-0-1-234% export AWS_SECRET_ACCESS_KEY="yyyy"
kazu634@ip-10-0-1-234% export AWS_HOSTED_ZONE_ID="zzzz"
kazu634@ip-10-0-1-234% export AWS_REGION="ap-northeast-1"

kazu634@ip-10-0-1-234% ./lego --dns route53 --domains lego.kazu634.com --email simoom634@yahoo.co.jp run
2019/03/31 05:02:07 [INFO] [lego.kazu634.com] acme: Obtaining bundled SAN certificate
2019/03/31 05:02:08 [INFO] [lego.kazu634.com] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/kT24lTOu3gbmepIH2vWudVjaxSTi8Q2Lu1y_BGlxD1E
2019/03/31 05:02:08 [INFO] [lego.kazu634.com] acme: Could not find solver for: tls-alpn-01
2019/03/31 05:02:08 [INFO] [lego.kazu634.com] acme: Could not find solver for: http-01
2019/03/31 05:02:08 [INFO] [lego.kazu634.com] acme: use dns-01 solver
2019/03/31 05:02:08 [INFO] [lego.kazu634.com] acme: Preparing to solve DNS-01
2019/03/31 05:02:09 [INFO] Wait for route53 [timeout:2m0s, interval: 4s]
2019/03/31 05:02:42 [INFO] [lego.kazu634.com] acme: Trying to solve DNS-01
2019/03/31 05:02:42 [INFO] [lego.kazu634.com] acme: Checking DNS record propagation using [localhost:53 127.0.0.1:53]
2019/03/31 05:02:42 [INFO] Wait for propagation [timeout: 2m0s, interval: 4s]
2019/03/31 05:02:47 [INFO] [lego.kazu634.com] The server validated our request
2019/03/31 05:02:47 [INFO] [lego.kazu634.com] acme: Cleaning DNS-01 challenge
2019/03/31 05:02:47 [INFO] Wait for route53 [timeout:2m0s, interval: 4s]
2019/03/31 05:03:25 [INFO] [lego.kazu634.com] acme: Validations succeeded; requesting certificates
2019/03/31 05:03:26 [INFO] [lego.kazu634.com] Server responded with a certificate.
```


### nginxで証明書を指定する
以下のように証明書が取得されているはずです:

```sh
kazu634@ip-10-0-1-234% pwd
/home/kazu634/works/.lego/certificates

kazu634@ip-10-0-1-234% ll
total 28K
drwxr-xr-x 2 kazu634 kazu634 4.0K Mar 31 05:50 .
drwxr-xr-x 4 kazu634 kazu634 4.0K Mar 31 04:59 ..
-rwxr-xr-x 1 root    root    3.3K Mar 31 05:14 lego.kazu634.com.crt
-rwxr-xr-x 1 kazu634 kazu634 1.7K Mar 31 05:14 lego.kazu634.com.issuer.crt
-rwxr-xr-x 1 kazu634 kazu634  237 Mar 31 05:14 lego.kazu634.com.json
-rwxr-xr-x 1 root    root     288 Mar 31 05:14 lego.kazu634.com.key
```

この場合、`nginx`には以下のように指定します:

```nginx
    ssl_certificate     /home/kazu634/works/.lego/certificates/lego.kazu634.com.crt;
    ssl_certificate_key /home/kazu634/works/.lego/certificates/lego.kazu634.com.key;
```

### IISで利用する場合
[Lego](https://github.com/go-acme/lego)ではうまくIISに登録できないことがわかったため、[WindowsサーバのIISにLet's Encryptで取得したワイルドカードSSL証明書をインポートする](https://blog.kazu634.com/labs/infra/2019-05-11-create-wildcard-ssl-certificate-on-windows/)を参照してください。

### ワイルドカード証明書が必要な場合
[Amazon Route 53](https://aws.amazon.com/route53/)側で以下のようにレコードを作成する:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/46692293625/in/photostream/" title="Untitled"><img src="https://live.staticflickr.com/7902/46692293625_bdfb426704.jpg" width="500" height="349" alt="Untitled"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

その後は通常通り、コマンドを実行します:

```sh
kazu634@ip-10-0-1-234% ./lego --dns route53 --domains "*.kazu634.com" --email simoom634@yahoo.co.jp run
2019/03/31 06:26:23 [INFO] [*.kazu634.com] acme: Obtaining bundled SAN certificate
2019/03/31 06:26:23 [INFO] [*.kazu634.com] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/FSIRwOjEhpS6H5U0hV2OT-s1ez8qRlHFNmLZ3-0PNw8
2019/03/31 06:26:23 [INFO] [*.kazu634.com] acme: use dns-01 solver
2019/03/31 06:26:23 [INFO] [*.kazu634.com] acme: Preparing to solve DNS-01
2019/03/31 06:26:24 [INFO] Wait for route53 [timeout: 2m0s, interval: 4s]
2019/03/31 06:27:02 [INFO] [*.kazu634.com] acme: Trying to solve DNS-01
2019/03/31 06:27:02 [INFO] [*.kazu634.com] acme: Checking DNS record propagation using [localhost:53 127.0.0.1:53]
2019/03/31 06:27:02 [INFO] Wait for propagation [timeout: 2m0s, interval: 4s]
2019/03/31 06:27:06 [INFO] [*.kazu634.com] The server validated our request
2019/03/31 06:27:06 [INFO] [*.kazu634.com] acme: Cleaning DNS-01 challenge
2019/03/31 06:27:07 [INFO] Wait for route53 [timeout: 2m0s, interval: 4s]
2019/03/31 06:29:04 [INFO] [*.kazu634.com] acme: Obtaining bundled SAN certificate
2019/03/31 06:29:05 [INFO] [*.kazu634.com] AuthURL: https://acme-v02.api.letsencrypt.org/acme/authz/FSIRwOjEhp2019/03/31 06:29:06 [INFO] [*.kazu634.com] Server responded with a certificate.
```


## 参考
- [nginx-lego/nginx.conf at master · pavels/nginx-lego · GitHub](https://github.com/pavels/nginx-lego/blob/master/nginx.conf)
- [Let&amp;#39;s Encrypt で DNS-01を利用したSSL証明書の取得方法 - Qiita](https://qiita.com/madaran0805/items/20c4437005d48458dc4f)
- [Free wildcard certs with Let&#039;s Encrypt &amp; DNS auth ft. Route 53 | Varun Priolkar](https://varunpriolkar.com/2018/05/free-wildcard-certs-with-lets-encrypt-dns-auth-ft-route-53/)
- [Issue Let&#39;s Encrypt certificate using AWS Route53](https://appscode.com/products/voyager/7.0.0/guides/certificate/dns/route53/)
- [How to Import & Export SSL Certificates in IIS 7 | DigiCert](https://www.digicert.com/ssl-support/pfx-import-export-iis-7.htm)
- [Importing & Exporting SSL Certificates In IIS 8 & IIS 8.5](https://www.digicert.com/ssl-support/pfx-import-export-iis-8.htm)
- [IIS 10 Exporting/Importing SSL Certificates | digicert.com](https://www.digicert.com/ssl-support/certificate-pfx-file-export-import-iis-10.htm)
- [WindowsサーバのIISにLet's Encryptで取得したワイルドカードSSL証明書をインポートする](https://blog.kazu634.com/labs/infra/2019-05-11-create-wildcard-ssl-certificate-on-windows/)
