+++
title = "WindowsサーバのIISにLet's Encryptで取得したワイルドカードSSL証明書をインポートする"
date = 2019-05-11T23:49:43+08:00
description = "WindowsサーバのIISにLet's Encryptで取得したワイルドカードSSL証明書をインポートする方法を調べたのでまとめています"
tags = ["Windows", "iis"]
categories = ["Labs", "Infra"]
author = "kazu634"
image=""
+++

WindowsサーバのIISにLet's Encryptで取得したワイルドカードSSL証明書をインポートする方法を調べたのでまとめした。

## 環境

- `Windows 2016`
- `IIS 10`

## 必要なもの
いろいろと試行錯誤したのですが、どうやらIISに対してSSL証明書を登録するためには、IISからCSRを作成する必要があるようです。しかし、Let's Encryptを用いてSSL証明書を取得する場合、どのようなCSRで証明書を取得しているのかわかりません。その結果、IISにSSL証明書を登録することができません。

この問題を解決するために、[PKISharp/win\-acme](https://github.com/PKISharp/win-acme)を利用します。このツールを利用することで、IISに自動的にLet's Encryptから取得したSSL証明書を登録することができます。

## 操作ログ
[PKISharp/win\-acme](https://github.com/PKISharp/win-acme)をダウンロード後、以下のように操作することでワイルドカードSSL証明書をIISに登録できました。

なお、手動でDNSに`txt`レコードを登録、削除を間に挟んでいることに注意ください。


```
C:\Users\Administrator\Desktop\win-acme.v2.0.3.206>wacs.exe

 [INFO] A simple Windows ACMEv2 client (WACS)
 [INFO] Software version 2.0.3.206 (RELEASE)
 [INFO] IIS version 10.0
 [INFO] Please report issues at https://github.com/PKISharp/win-acme

 N: Create new certificate
 M: Create new certificate with advanced options
 L: List scheduled renewals
 R: Renew scheduled
 S: Renew specific
 A: Renew *all*
 O: More options...
 Q: Quit

 Please choose from the menu: M

 [INFO] Running in mode: Interactive, Advanced

 1: Single binding of an IIS site
 2: SAN certificate for all bindings of an IIS site
 3: SAN certificate for all bindings of multiple IIS sites
 4: Manually input host names
 <Enter>:

 Which kind of certificate would you like to create?: 4

 Enter comma-separated list of host names, starting with the common name: *.holiday88sg.com

 [INFO] Target generated using plugin Manual: *.holiday88sg.com

 Suggested FriendlyName is '[Manual] *.holiday88sg.com', press enter to accept or type an alternative: <Enter>

 1: [dns-01] CNAME the record to a server that supports the acme-dns API
 2: [dns-01] Manually create record
 3: [dns-01] Run script to create and update records
 <Enter>: Abort

 How would you like to validate this certificate?: 2

 1: Elliptic Curve key
 2: Standard RSA key pair

 What kind of CSR would you like to create?: 2

 1: IIS Central Certificate Store
 2: Windows Certificate Store
 3: Write .pem files to folder (Apache, ngnix, etc.)

 How would you like to store this certificate?: 2

 1: Create or update https bindings in IIS
 2: Do not run any installation steps
 3: Run a custom script
 C: Abort

 Which installer should run for the certificate?: 2

 [INFO] Authorize identifier: xxx.com
 [INFO] Authorizing xxx.com using dns-01 validation (Manual)

 Domain:             xxx.com
 Record:             _acme-challenge.xxx.com
 Type:               TXT
 Content:            "2n6Q9rawV9C1sCAzVhpIQqpgJh1EtSDMIaz2zYus7sc"
 Note 1:             Some DNS control panels add quotes automatically. Only one set is required.
 Note 2:             Make sure your name servers are synchronised, this may take several minutes!

 Please press enter after you've created and verified the record

 [INFO] Answer should now be available at _acme-challenge.xxx.com
 [WARN] Preliminary validation failed, found (null) instead of 2n6Q9rawV9C1sCAzVhpIQqpgJh1EtSDMIaz2zYus7sc
 [INFO] Authorization result: valid

 Domain:             xxx.com
 Record:             _acme-challenge.xxx.com
 Type:               TXT
 Content:            "2n6Q9rawV9C1sCAzVhpIQqpgJh1EtSDMIaz2zYus7sc"

 Please press enter after you've deleted the record

 [INFO] Requesting certificate [Manual] *.xxx.com
 [INFO] Installing certificate in the certificate store
 [INFO] Adding certificate [Manual] *.xxx.com 2019/5/11 8:06:48 to store WebHosting
 [INFO] Installing with None...

 Do you want to replace the existing task? (y/n*)  - yes

 [INFO] Deleting existing task win-acme renew (acme-v02.api.letsencrypt.org) from Windows Task Scheduler.
 [INFO] Adding Task Scheduler entry with the following settings
 [INFO] - Name win-acme renew (acme-v02.api.letsencrypt.org)
 [INFO] - Path C:\Users\Administrator\Desktop\win-acme.v2.0.3.206
 [INFO] - Command wacs.exe --renew --baseuri "https://acme-v02.api.letsencrypt.org/"
 [INFO] - Start at 09:00:00
 [INFO] - Time limit 02:00:00

 Do you want to specify the user the task will run as? (y/n*)  - yes

 Enter the username (Domain\username): Administrator

 Enter the user's password: *********

 [INFO] Adding renewal for [Manual] *.holiday88sg.com
 [INFO] Next renewal scheduled at 2019/7/5 8:06:48

 N: Create new certificate
 M: Create new certificate with advanced options
 L: List scheduled renewals
 R: Renew scheduled
 S: Renew specific
 A: Renew *all*
 O: More options...
 Q: Quit

 Please choose from the menu: q
```

## 参考
- [Legoの使い方メモ \| His greatness lies in his sense of responsibility](https://blog.kazu634.com/labs/infra/2019-04-14_how_to_use_lego/)
