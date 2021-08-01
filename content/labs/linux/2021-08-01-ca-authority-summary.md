+++
tags = ["ssl"]
categories = ["Labs", "Infra", "Linux"]
author = "kazu634"
date = "2021-08-01T20:25:05+09:00"
title = "CA認証局について色々調べてみたまとめです"
description = "SSL証明書などを発行するCA認証局まわりについて興味を持ったため、色々と調べてみました。"
+++

SSL証明書などを発行するCA認証局まわりについて興味を持ったため、色々と調べてみました。そのまとめです。

## CA認証局を構築する方法
SSL証明書を発行するためには、CA認証局というのを構築する必要があるのですが、Linuxなどで構築するためには、色々と方法があることがわかりました。私が調べた限りでは、

1. `openssl`コマンドを利用する方法
2. `easy-rsa`コマンドを利用する方法 (= `openssl`コマンドを利用したCA認証局構築のラッパーコマンド)
3. `mkcert`コマンドを利用する方法 (= 手っ取り早く検証用に証明書を発行したい場合はこちら。CA認証局部分の手順を全て隠蔽してくれる)

というように整理できるようでした。

`openssl`コマンドを直接使うのはとても大変そうでしたので、それ以外の方法について調べてみました。

## mkcertコマンドでお手軽に
[mkcert](https://github.com/FiloSottile/mkcert)というのでお手軽に認証局を作成し、SSL証明書を発行できます。この方法の場合には、ややこしいCA認証局の部分はほとんど隠蔽されていて、証明書だけを手に入れることができるのがポイント。

### インストール
次のようにしてインストールします:

```bash
% wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-amd64                                                                                                        
--2021-08-01 15:14:34--  https://github.com/FiloSottile/mkcert/releases/download/v1.4.3/mkcert-v1.4.3-linux-amd64                                                                                                         
github.com (github.com) をDNSに問いあわせています... 52.69.186.44                                            
github.com (github.com)|52.69.186.44|:443 に接続しています... 接続しました。                                 
HTTP による接続要求を送信しました、応答を待っています... 302 Found
場所: https://github-releases.githubusercontent.com/138547797/89a9d600-2f20-11eb-9474-a9aab8fb1873?X-Amz-Algo
rithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210801%2Fus-east-1%2Fs3%2Faws4_request&X-Amz
-Date=20210801T061434Z&X-Amz-Expires=300&X-Amz-Signature=cd4491f21aea9ecf37371302b4c84415a002d01e46d7123550f8
830d1636baa8&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=138547797&response-content-disposition=atta
chment%3B%20filename%3Dmkcert-v1.4.3-linux-amd64&response-content-type=application%2Foctet-stream [続く]
--2021-08-01 15:14:34--  https://github-releases.githubusercontent.com/138547797/89a9d600-2f20-11eb-9474-a9aa
b8fb1873?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20210801%2Fus-east-1%2Fs3%2
Faws4_request&X-Amz-Date=20210801T061434Z&X-Amz-Expires=300&X-Amz-Signature=cd4491f21aea9ecf37371302b4c84415a
002d01e46d7123550f8830d1636baa8&X-Amz-SignedHeaders=host&actor_id=0&key_id=0&repo_id=138547797&response-conte
nt-disposition=attachment%3B%20filename%3Dmkcert-v1.4.3-linux-amd64&response-content-type=application%2Foctet
-stream
github-releases.githubusercontent.com (github-releases.githubusercontent.com) をDNSに問いあわせています... 18
5.199.108.154, 185.199.110.154, 185.199.109.154, ...
github-releases.githubusercontent.com (github-releases.githubusercontent.com)|185.199.108.154|:443 に接続して
います... 接続しました。
HTTP による接続要求を送信しました、応答を待っています... 200 OK
長さ: 4803796 (4.6M) [application/octet-stream]
`mkcert-v1.4.3-linux-amd64' に保存中
```

ダウンロードしたファイルが既に実行ファイルとなっていますので、適当な場所に移動して、実行権限をつけます。私の場合は`/usr/local/bin/mkcert`として、実行権限を与えました。

### SSL証明書の作成
その後、`mkcert -install`を実行すると、ローカルCA認証局を開設し、開設した認証局の証明書をローカルの認証済みルート証明書に追加してくれます。

```bash
% mkcert -install
The local CA is already installed in the system trust store! 👍
The local CA is already installed in the Firefox and/or Chrome/Chromium trust store! 👍
```

その後、コマンドライン引数にSSL証明書に紐づく名前を指定してコマンドを実行すると、証明書とその証明書を作成した際の秘密鍵を生成してくれます。例えば、下の例の場合は、`localhost`と`192.168.10.101`に紐づくSSL証明書を作成してくれます。

```bash
% mkcert localhost 192.168.10.101
                                                                                                             
Created a new certificate valid for the following names 📜                                                   
 - "localhost"                                                                                               
 - "192.168.10.101"                                                                                          
                                                                                                             
The certificate is at "./localhost+1.pem" and the key at "./localhost+1-key.pem" ✅                          
                                                                                                             
It will expire on 25 October 2023 🗓     
```

### 作成したSSL証明書のテスト
[GitHub - mattn/serve](https://github.com/mattn/serve)でお手軽にSSL証明書の検証ができます。下のようにダウンロードして、`tar`ファイルを解凍すると、`serve`コマンドが出てきますので、適当なパスにコピーして、実行権限を与えてください。

```bash
% wget https://github.com/mattn/serve/releases/download/v0.0.1/serve_v0.0.1_linux_amd64.tar.gz
% tar xvzf serve_v0.0.1_linux_amd64.tar.gz
serve_v0.0.1_linux_amd64/
serve_v0.0.1_linux_amd64/README.md
serve_v0.0.1_linux_amd64/serve
```

下のように指定することで、生成したSSL証明書を利用して、Webサーバを起動します。

```bash
% serve -cf localhost+1.pem -kf localhost+1-key.pem
2021/08/01 15:37:45 serving /home/kazu634/tmp/serve as / on :5000
2021/08/01 15:37:58 192.168.10.101:39698 GET /
2021/08/01 15:38:13 127.0.0.1:52350 GET /
```

別なターミナルを立ち上げて、下のようにコマンド実行してみます。

```bash
% curl https://192.168.10.101:5000
<pre>
<a href="RootCA_key.pem">RootCA_key.pem</a>
<a href="domain_name.crt.pem">domain_name.crt.pem</a>
<a href="foo_crt.pem">foo_crt.pem</a>
<a href="foo_key.pem">foo_key.pem</a>
<a href="key_nopass.pem">key_nopass.pem</a>
<a href="localhost+1-key.pem">localhost+1-key.pem</a>
<a href="localhost+1.pem">localhost+1.pem</a>
<a href="privkey.pem">privkey.pem</a>
<a href="result.json">result.json</a>
<a href="serve">serve</a>
<a href="test.crt">test.crt</a>
<a href="vault_ca.pem">vault_ca.pem</a>
<a href="vault_cert.pem">vault_cert.pem</a>
<a href="vault_priv_key.pem">vault_priv_key.pem</a>
</pre>

% curl https://localhost:5000
<pre>
<a href="RootCA_key.pem">RootCA_key.pem</a>
<a href="domain_name.crt.pem">domain_name.crt.pem</a>
<a href="foo_crt.pem">foo_crt.pem</a>
<a href="foo_key.pem">foo_key.pem</a>
<a href="key_nopass.pem">key_nopass.pem</a>
<a href="localhost+1-key.pem">localhost+1-key.pem</a>
<a href="localhost+1.pem">localhost+1.pem</a>
<a href="privkey.pem">privkey.pem</a>
<a href="result.json">result.json</a>
<a href="serve">serve</a>
<a href="test.crt">test.crt</a>
<a href="vault_ca.pem">vault_ca.pem</a>
<a href="vault_cert.pem">vault_cert.pem</a>
<a href="vault_priv_key.pem">vault_priv_key.pem</a>
</pre>
```

`serve`コマンドを実行したディレクトリの中身を表示してくれるので、ディレクトリのファイル一覧が表示されればOKです。

ちなみに`mkcert -install`を実施したホスト上でテストをしてください。それ以外のホストでテストをした場合、信頼済みのルート証明書が追加されていないため、証明書の検証ができずエラーになります。

## easy-rsaでCA認証局を構築、証明書を発行する
`mkcert`コマンドの場合は、CA認証局の部分が隠蔽されていましたが、`easy-rsa`の場合は、少しだけCA認証局の部分を意識する必要があります。

なお、[How To Set Up and Configure a Certificate Authority (CA) On Ubuntu 20.04 | DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-and-configure-a-certificate-authority-ca-on-ubuntu-20-04)を参考にさせていただきました。

### easy-rsaのインストール
以下のコマンドを実行して、`easy-rsa`パッケージをインストールします:

```bash
% sudo apt install easy-rsa
```

### CA認証局の構築
以下のようにしてCA認証局を構築していきます。CA認証局用のディレクトリを作成して進めていきます。私の場合は、`/home/kazu634/works/easy-rsa`を作成しました。

まずは`easyrsa init-pki`を実行して、CA認証局の構築の準備をします。

```bash
% ./easyrsa init-pki

init-pki complete; you may now create a CA or requests.
Your newly created PKI dir is: /home/kazu634/works/easy-rsa/pki
```

次に`vars`ファイルを編集します。基本的には以下の部分だけ編集をすればいいのかなと思います:

```
set_var EASYRSA_REQ_COUNTRY     "JP"
set_var EASYRSA_REQ_PROVINCE    "Tokyo"
set_var EASYRSA_REQ_CITY        "Tokyo"
set_var EASYRSA_REQ_ORG.        "Musashi"
set_var EASYRSA_REQ_EMAIL       "simoom634@yahoo.co.jp"
set_var EASYRSA_REQ_OU          "IT"
```

次に`easyrsa build-ca`コマンドを実行して、CA認証局を構築します。なお、`nopass`を指定すると、パスワードなしでできるようです。

```bash
% ./easyrsa build-ca nopass
Note: using Easy-RSA configuration from: ./vars
Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020
read EC key
writing EC key
Can't load /home/kazu634/works/easy-rsa/pki/.rnd into RNG
139845623887168:error:2406F079:random number generator:RAND_load_file:Cannot open file:../crypto/rand/randfil
e.c:98:Filename=/home/kazu634/works/easy-rsa/pki/.rnd
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:Musashi CA
CA creation complete and you may now import and sign cert requests.
Your new CA certificate file for publishing is at:
/home/kazu634/works/easy-rsa/pki/ca.crt
```

これで`CA`の公開鍵と秘密鍵が作成されました。

### サーバ証明書の作成
それではサーバ証明書を発行してみようと思います。

#### サーバ証明書をリクエストするサーバ側作業
どこでもいいのですが、サーバ証明書を作成するための秘密鍵をまず作成します。

```bash
% openssl genrsa -out test.key
Generating RSA private key, 2048 bit long modulus (2 primes)
........................................................................+++++
.................................................................+++++
e is 65537 (0x010001)     
```

その後、CSRを作成します。`bastion2004`としてある部分は、サーバ証明書を利用するホスト名を指定してください:

```bash
% openssl req -new -key ./test.key -out test.req
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:JP
State or Province Name (full name) [Some-State]:Tokyo
Locality Name (eg, city) []:Tokyo
Organization Name (eg, company) [Internet Widgits Pty Ltd]:Musashi
Organizational Unit Name (eg, section) []:IT
Common Name (e.g. server FQDN or YOUR name) []:bastion2004
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:
```

#### CA認証局での作業
`/home/kazu634/works/easy-rsa`に移動し、`easyrsa import-req <作成したCSRファイル名> <任意の名称>`を実行します。別なホストでCSRファイルを作成した場合は、コピーしておいてください。

```bash
% ./easyrsa import-req ../practice-csr/test.req test

Note: using Easy-RSA configuration from: ./vars

Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020

The request has been successfully imported with a short name of: test
You may now use this name to perform signing operations on this request.
```

`easyrsa sign-req server <前の手順で指定した名称>`を実行して、CSRに署名して、証明書を発行します。今回はサーバー証明書なので、`server`を指定してあげます:

```bash
% ./easyrsa sign-req server test

Note: using Easy-RSA configuration from: ./vars

Using SSL: openssl OpenSSL 1.1.1f  31 Mar 2020


You are about to sign the following certificate.
Please check over the details shown below for accuracy. Note that this request
has not been cryptographically verified. Please be sure it came from a trusted
source or that you have verified the request checksum with the sender.

Request subject, to be signed as a server certificate for 1080 days:

subject=
    countryName               = JP
    stateOrProvinceName       = Tokyo
    localityName              = Tokyo
    organizationName          = Musashi
    organizationalUnitName    = IT
    commonName                = bastion2004


Type the word 'yes' to continue, or any other input to abort.
  Confirm request details: yes
Using configuration from /home/kazu634/works/pki/easy-rsa/pki/safessl-easyrsa.cnf
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
countryName           :PRINTABLE:'JP'
stateOrProvinceName   :ASN.1 12:'Tokyo'
localityName          :ASN.1 12:'Tokyo'
organizationName      :ASN.1 12:'Musashi'
organizationalUnitName:ASN.1 12:'IT'
commonName            :ASN.1 12:'bastion2004'
Certificate is to be certified until Jul  9 13:25:47 2024 GMT (1080 days)

Write out database with 1 new entries
Data Base Updated

Certificate created at: /home/kazu634/works/pki/easy-rsa/pki/issued/test.crt
```

作成した証明書はそのままでは利用できないので、以下のコマンドを実行します:

```bash
% openssl x509 -in test.crt -out foo.crt
```

### 作成したサーバ証明書のテスト
それでは作成したサーバ証明書のテストをします。

#### ルート証明書をデプロイ
Linuxの信頼済みルート証明書に、構築したCA認証局の公開鍵を追加します。`Ubuntu`の場合は、以下のようにします。

```bash
% sudo cp /home/kazu634/works/pki/easy-rsa/pki/ca.crt /usr/local/share/ca-certificates/
% sudo chmod 444 /usr/local/share/ca-certificates/ca.crt
% sudo update-ca-certificates
```

異なるホストにデプロイする場合には、`/home/kazu634/works/pki/easy-rsa/pki/ca.crt`を対象ホストの`/usr/local/share/ca-certificates/`ディレクトリ配下にコピーします。

#### 動作確認
`serve`コマンドで動作確認をします:

```bash
% ./serve -cf test.crt -kf test.key
2021/08/01 22:25:46 serving /home/kazu634/tmp/serve as / on :5000
2021/08/01 22:25:50 127.0.0.1:48662 GET /
2021/08/01 22:25:58 127.0.0.1:48670 GET /
```

別なターミナルを立ち上げて、アクセスしてみます:

```bash
% curl https://bastion2004:5000
<pre>
<a href="RootCA_key.pem">RootCA_key.pem</a>
<a href="domain_name.crt.pem">domain_name.crt.pem</a>
<a href="foo_crt.pem">foo_crt.pem</a>
<a href="foo_key.pem">foo_key.pem</a>
<a href="key_nopass.pem">key_nopass.pem</a>
<a href="localhost+1-key.pem">localhost+1-key.pem</a>
<a href="localhost+1.pem">localhost+1.pem</a>
<a href="privkey.pem">privkey.pem</a>
<a href="result.json">result.json</a>
<a href="serve">serve</a>
<a href="test.crt">test.crt</a>
<a href="vault_ca.pem">vault_ca.pem</a>
<a href="vault_cert.pem">vault_cert.pem</a>
<a href="vault_priv_key.pem">vault_priv_key.pem</a>
</pre>
```

## まとめ
`mkcert`コマンドと`easy-rsa`パッケージを利用した場合の、CA認証局の構築・SSL証明書の発行について見てみました。