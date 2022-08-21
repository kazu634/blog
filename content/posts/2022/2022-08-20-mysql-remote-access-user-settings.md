+++
title = "MySQLのリモート接続用ユーザーの設定まとめ"
date = 2022-08-20T13:35:43+09:00
description = "MySQLのリモート接続用ユーザーの追加・削除方法をまとめました"
tags = ["MySQL", "MariaDB"]
categories = ["インフラ"]
author = "kazu634"
images = ["ogp/2022-08-20-mysql-remote-access-user-settings.webp"]
+++

`MySQL`や`MariaDB`のリモート接続用ユーザーの設定をまとめています。

## リモート接続用ユーザーの追加
`root`ユーザーに対して、`192.168.n.n`からのアクセスを許可する場合はこんな感じでコマンド実行します:

```sql
GRANT ALL PRIVILEGES ON *.* TO "root"@"192.168.%.%" IDENTIFIED BY 'password' WITH GRANT OPTIONS;
```

確認方法はこうします:

```sql
mysql> select user, host FROM mysql.user;
+-----------+--------------+
| user      | host         |
+-----------+--------------+
| root      | 127.0.0.1    |
| grafana   | 192.168.%.%  |
| guacamole | 192.168.%.%  |
| root      | 192.168.%.%  |
| vault     | 192.168.10.% |
| root      | ::1          |
| grafana   | localhost    |
| root      | localhost    |
+-----------+--------------+
8 rows in set (0.02 sec)
```

## リモート接続用ユーザーの削除
`guacamole`ユーザーに対して、`192.168.10.%`からのアクセス許可の設定を削除する場合には、こんな感じでコマンド実行します:

```sql
mysql> DROP USER 'guacamole'@'192.168.10.%';
```

## Synology NASのパッケージでMySQL, MariaDBを稼働させている場合
`Synology`のNAS上で`MySQL`や`MariaDB`を稼働させている場合、パスワードの規則をゆるくしないと、パスワード指定に失敗する可能性があります。その場合には、[ここ](https://community.synology.com/enu/forum/1/post/135783)を参考にします。

## 参考
- [Synology MariaDB 10 password policy \| Synology Community](https://community.synology.com/enu/forum/1/post/135783)
- [How to Check MySQL Version via The Command Line \- Knowledge base \- ScalaHosting](https://www.scalahosting.com/kb/how-to-check-mysql-version-via-the-command-line/)
- [MySQL \| パターンマッチングを行う\(LIKE演算子\)](https://www.javadrive.jp/mysql/select/index7.html)
- [How To Delete or Remove a MySQL User Account on Linux](https://phoenixnap.com/kb/remove-delete-mysql-user)
