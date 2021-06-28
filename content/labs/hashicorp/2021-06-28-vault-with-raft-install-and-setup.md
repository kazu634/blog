+++
title = "VaultをIntegrated Storage (raft)でセットアップ"
date = 2021-06-28T13:49:43+08:00
description = "VaultをIntegrated Storage (raft)でセットアップしてみました。"
tags = ["Vault", "Linux"]
categories = ["Labs", "Infra", "HashiCorp"]
author = "kazu634"
+++

Vaultをインストール・セットアップしてみたので、そのときのメモになります。

## 想定する環境
想定する環境を説明します。Vaultについては、`Integrated Storage (Raft)`を利用して、クラスターを構成します。

### ダイアグラム
3台のサーバでクラスターを構成してみます。

![Diagram](https://farm66.staticflickr.com/65535/51275717613_7dfe3a9d11_c.jpg)

### サーバのOS・CPUアーキテクチャーとか
`Ubuntu 20.04 LTS`にインストールします。

```bash
% cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=20.04
DISTRIB_CODENAME=focal
DISTRIB_DESCRIPTION="Ubuntu 20.04.2 LTS"
```

```bash
% arch
x86_64
```

## インストール
`apt`リポジトリがあるので、そこからインストールします。公式解説ページは[こちら](https://learn.hashicorp.com/tutorials/vault/getting-started-install)。

### HashiCorp GPGキーの追加
以下のコマンドを実行して、GPGキーを追加します。

```bash
% curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -

$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

### インストール
各サーバー上で以下のコマンドを実行して、`Vault`のインストールを行います。

```bash
% sudo apt-get update && sudo apt-get install vault
```

### インストールすると導入されるもの
以下のものが導入されるようです:

- `vault`のバイナリー
- `systemd`設定ファイル
- `/opt/vault`ディレクトリが作成される
	- `/opt/vault/data`はデータ格納用を意図していると思われる
	- `/opt/vault/tls`はオレオレ証明書を作成して格納しているようです
- `/etc/vault.d`が作成される
	- `/etc/vault.d/vault.hcl`が標準の設定ファイルとしてデプロイされる

### 注意点
- `systemd`設定ファイルが導入されますが、自動起動はしません。自動起動させるには`sudo systemctl enable vault`を自分で実施する必要があります。

- オレオレ証明書の中身を確認する限り、バーチャルホスト名が「Vault」の時に有効な証明書を作っているようです。

```bash
% openssl x509 -text -noout -in /opt/vault/tls/tls.crt
Certificate:                                                                                                 
    Data:                                                                                                    
        Version: 3 (0x2)                                                                                     
        Serial Number: 7e:28:fd:b0:56:83:69:a9:d0:08:8c:26:f5:18:60:1e:42:17:16:02                                      
        Signature Algorithm: sha256WithRSAEncryption                                                         
        Issuer: O = HashiCorp, CN = Vault                                                                    
        Validity                                                                                             
            Not Before: Jun  7 23:23:17 2021 GMT                                                             
            Not After : Jun  6 23:23:17 2024 GMT                                                             
        Subject: O = HashiCorp, CN = Vault                                                                   
        Subject Public Key Info:                                                                             
            Public Key Algorithm: rsaEncryption                                                              
                RSA Public-Key: (4096 bit)                                                                   
[…snip…]
```

## セットアップ
セットアップの手順を説明していきます。

### 設定ファイルの置換
各サーバ上の`/etc/vault.d/vault.hcl`を、以下の内容で上書きします。なお、下の例は`vault01`サーバの例です。適宜、IPアドレス・ホスト名など読み替えてください。

```
ui = true
disable_mlock = true

storage "raft" {
  path    = "/opt/vault/data"
  # ノード名はサーバごとに変わりますので置き換えてください
  node_id = "vault01"

 # 再接続先のIPアドレスもサーバごとに変わりますので置き換えてください
 retry_join {
    leader_api_addr = "http://192.168.10.143:8200"
  }

  retry_join {
    leader_api_addr = "http://192.168.10.144:8200"
  }
}

# ここも変わりますので置き換えてください。
api_addr = "http://192.168.10.142:8200"
cluster_addr = "http://192.168.10.142:8201"

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"

  # SSL通信は今回は使用しない
  tls_disable = true
  # tls_cert_file = "/opt/vault/tls/tls.crt"
  # tls_key_file  = "/opt/vault/tls/tls.key"
}
```

### Vault起動 (1台目)
どこでもいいので、以下のコマンドを実行し、どこかのサーバでVaultを起動します。

```bash
% sudo systemctl start vault
```

`vault`コマンドに接続先サーバを指示するため、`VAULT_ADDR`環境変数を指定します:

```bash
% export VAULT_ADDR=http://192.168.10.142:8200
```

後は通常通り、`vault operator init`コマンドを実行します。すると、リカバリーキーと`Initial Root Token`が発行されます。`vault operator unseal`コマンドでunsealします。

### Vault起動 (2台目以降)
それ以外のサーバーでは、`sudo systemctl start vault`を実行してから、`vault operator unseal`コマンドでunsealします。

### 動作確認
`vault status`コマンドを実行して、`storage Type`が`raft`、`HA Enabled`が`true`であることを確認します。

```bash
% vault status
Key                      Value
---                      -----
Recovery Seal Type       shamir
Initialized              true
Sealed                   false
Total Recovery Shares    5
Threshold                3
Version                  1.7.3
Storage Type             raft
Cluster Name             vault-cluster-e2a49833
Cluster ID               08252ea2-3816-419e-7f67-2d8929c438bb
HA Enabled               true
HA Cluster               https://192.168.10.144:8201
HA Mode                  active
Active Since             2021-06-26T15:14:28.755516837Z
Raft Committed Index     31294
Raft Applied Index       31294
```

`vault operator raft list-peers`コマンドを実行すると、適切にセットアップされていれば、どこかのサーバーが`leader`に、その他が`follower`として表示されます。

```
kazu634@vault01% vault operator raft list-peers
Node       Address                State       Voter
----       -------                -----       -----
vault01    192.168.10.142:8201    follower    true
vault02    192.168.10.143:8201    follower    true
vault03    192.168.10.144:8201    leader      true
```

`Integrated storage (raft)`を利用している際に、ノードの異常などを検知して、クラスターリーダーの変更などをする機能を`autopilot`と呼んでいます。この機能の状態を`vault operator raft autopilot state`コマンドで確認できます。`Healthy`が`true`であることを確認します。

```bash
kazu634@vault01% vault operator raft autopilot state
Healthy:                      true                                                                           
Failure Tolerance:            1                                                                              
Leader:                       vault03                                                                        
Voters:                                                                                                      
   vault03                                                                                                   
   vault01                                                                                                   
   vault02                                                                                                   
Servers:                                                                                                     
   vault01                                                                                                   
      Name:            vault01                                                                               
      Address:         192.168.10.142:8201                                                                   
      Status:          voter                                                                                 
      Node Status:     alive                                                                                 
      Healthy:         true                                                                                  
      Last Contact:    3.880838102s                                                                          
      Last Term:       10                                                                                    
      Last Index:      31293                                                                                 
   vault02                                                                                                   
      Name:            vault02                                                                               
      Address:         192.168.10.143:8201                                                                   
      Status:          voter                                                                                 
      Node Status:     alive                                                                                 
      Healthy:         true 
      Last Contact:    1.404623564s
      Last Term:       10
      Last Index:      31293
   vault03
      Name:            vault03
      Address:         192.168.10.144:8201
      Status:          leader
      Node Status:     alive
      Healthy:         true
      Last Contact:    0s
      Last Term:       10
      Last Index:      31293
```

## その他
その他のセットアップ関連です。

### 自動起動
`sudo systemctl enable vault`コマンドを実行します。

