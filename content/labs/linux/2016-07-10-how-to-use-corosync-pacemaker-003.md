+++
author = "kazu634"
description = "Pacemaker + Corosyncを用いてクラスタ環境を構築してみました。RHEL 6.4で検証しました。今回はPacemakeとCorosyncを利用できるようにします"
categories = ["Labs", "Linux"]
tags = ["clustering", "pacemaker", "corosync"]
date = "2016-07-10T23:48:32+08:00"
title = "Pacemaker + Corosyncを用いてクラスタ環境の構築 - Pacemaker, Corosyncの構築"
images = ["images/7241213444_1c8a40e897.jpg"]
+++

お仕事でLinux環境でHAクラスタを検証する必要が出てきたので、手順を調べてみました。

## 環境
RHEL 6.4環境で検証しております:

```
# cat /etc/redhat-release
Red Hat Enterprise Linux Server release 6.4 (Santiago)
```

当然ながらCentOS6でも動作するかと思います。RHEL 7 or CentOS7ではOSの仕組みが変わっていると思いますので、ここでまとめた手順の通りにしてもおそらく動作しません。

ホスト名一覧などは以下のとおりです:

| # | Hostname | IP Address | Remarks |
|:-:|:--------:|:----------:|:-------:|
| 1 | rhel-act | 192.168.56.31 | Active server |
| 2 | rhel-sta | 192.168.56.32 | Standby server |
| 3 | rhel-logical | 192.168.56.30 | Logical hostname / floating IP |
| 4 | rhel-iscsi | 192.168.56.40 | iScsi server |

簡単なネットワーク図はこちら:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/27578460773/in/dateposted/" title="network diagram"><img src="https://c6.staticflickr.com/8/7307/27578460773_d917becbf9.jpg" width="500" height="281" alt="network diagram"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

## Pacemaker + Corosyncのインストール
Pacemaker + Corosyncのインストール方法を説明します。

### インストール方法
以下のコマンドを実行し、インストールします。なお、`rhel-act`およびに`rhel-sta`サーバ上で実施します:

```
# yum install -y pacemaker cman pcs
```

### セットアップ方法
セットアップ方法を説明します。

#### Quorumの無効化
以下のコマンドを実行し、Quorumを無効化します。なお、`rhel-act`およびに`rhel-sta`サーバ上で実施します:

```
# cd /etc/sysconfig/
# cp -p cman cman.${YYYYMMDD}
# vi cman
# diff -u cman.${YYYYMMDD} cman
--- cman.20160625       2016-05-11 17:59:29.000000000 +0800
+++ cman        2016-06-25 15:25:21.217999988 +0800
@@ -10,7 +10,7 @@
 #     startup. Quorum is needed by many other applications, so we may as
 #     well wait here.  If CMAN_QUORUM_TIMEOUT is zero, quorum will
 #     be ignored.
-#CMAN_QUORUM_TIMEOUT=45
+CMAN_QUORUM_TIMEOUT=0

 # CMAN_SHUTDOWN_TIMEOUT -- amount of time to wait for cman to become a
 #     cluster member before calling 'cman_tool' leave during shutdown.
```

#### `hauser`ユーザのパスワード設定
クラスタ操作で利用する`hauser`ユーザのパスワードを設定します。`rhel-act`およびに`rhel-sta`サーバで同じパスワードを指定してあげます。ここでは「p@ssword」を指定することとします。

なお、`rhel-act`およびに`rhel-sta`サーバ上で実施してください。

```
# passwd hacluster
Changing password for user hacluster.
New password:
BAD PASSWORD: it is based on a dictionary word
Retype new password:
passwd: all authentication tokens updated successfully.
```

#### `pcsd` デーモンの自動起動設定
クラスタ関連デーモンの`pcsd`デーモンをOS起動時に自動起動するように設定します。なお、`rhel-act`およびに`rhel-sta`サーバ上で実施してください:

```
# cd
# service pcsd status
pcsd is stopped
# service pcsd start
Starting pcsd:                                             [  OK  ]
# service pcsd status
pcsd (pid  1345) is running...
# chkconfig --list > 001-before.txt
# chkconfig pcsd on
# chkconfig --list > 001-after.txt
# diff -u 001-before.txt 001-after.txt
--- 001-before.txt      2016-06-25 15:29:00.331999983 +0800
+++ 001-after.txt       2016-06-25 15:29:09.834999999 +0800
@@ -21,7 +21,7 @@
 ntpdate                0:off   1:off   2:off   3:off   4:off   5:off   6:off
 oddjobd                0:off   1:off   2:off   3:off   4:off   5:off   6:off
 pacemaker              0:off   1:off   2:off   3:off   4:off   5:off   6:off
-pcsd                   0:off   1:off   2:off   3:off   4:off   5:off   6:off
+pcsd                   0:off   1:off   2:on    3:on    4:on    5:on    6:off
 postfix                0:off   1:off   2:on    3:on    4:on    5:on    6:off
 quota_nld              0:off   1:off   2:off   3:off   4:off   5:off   6:off
 rdisc                  0:off   1:off   2:off   3:off   4:off   5:off   6:off
```

#### `corosync`の自動起動の抑止
クラスタ関連デーモンの`pcsd`デーモンから起動されるようですので、OS起動時に`Corosync`を自動起動しないように設定します。なお、`rhel-act`およびに`rhel-sta`サーバ上で実施してください:

```
# chkconfig corosync off
```

#### クラスタのセットアップ
以下のコマンドを実行して、クラスタのセットアップを実行します。なお、`rhel-act` or `rhel-sta`のいずれか一方で実行してください。

以下のコマンドを実行し、クラスタソフトで利用するOSユーザ・パスワードを指定します:

```
# pcs cluster auth rhel-act rhel-sta -u hacluster -p p@ssw0rd
rhel-act: Authorized
rhel-sta: Authorized
```

以下のコマンドを実行し、クラスタソフト上でクラスタを構成します:

```
# pcs cluster setup --start --name cluster rhel-act rhel-sta
Destroying cluster on nodes: rhel-act, rhel-sta...
rhel-act: Stopping Cluster (pacemaker)...
rhel-sta: Stopping Cluster (pacemaker)...
rhel-sta: Successfully destroyed cluster
rhel-act: Successfully destroyed cluster

Sending cluster config files to the nodes...
rhel-act: Updated cluster.conf...
rhel-sta: Updated cluster.conf...

Starting cluster on nodes: rhel-act, rhel-sta...
rhel-act: Starting Cluster...
rhel-sta: Starting Cluster...

Synchronizing pcsd certificates on nodes rhel-act, rhel-sta...
rhel-act: Success
rhel-sta: Success

Restarting pcsd on the nodes in order to reload the certificates...
rhel-act: Success
rhel-sta: Success
```

以下のコマンドを実行し、構成したクラスタを有効化します:

```
# pcs cluster enable --all
rhel-act: Cluster Enabled
rhel-sta: Cluster Enabled
```

`crm_verify`コマンドを実行し、設定内容を検証します:

```
# crm_verify -L -V
   error: unpack_resources:     Resource start-up disabled since no STONITH resources have been defined
   error: unpack_resources:     Either configure some or disable STONITH with the stonith-enabled option
   error: unpack_resources:     NOTE: Clusters with shared data need STONITH to ensure data integrity
Errors found during check: config not valid
```

上の例では、STONITHの設定でエラーが出ています。今回の例ではSTONITHは使用しないため、無効化します。また、Quorumも利用しないため、無効化します。無効化するための設定は以下になります:

```
# pcs property set stonith-enabled=false
# pcs property set no-quorum-policy=ignore
```

### クラスタリソースの登録
クラスタリソースの登録方法を説明します。

#### 論理IPアドレスの登録
`pcs resource create vip ocf:heartbeat:IPaddr2`を実行し、論理IPアドレスを登録します。ここでは、`192.168.56.30`を登録します。なお、クラスタリソースグループとして`resource-group`を指定しています:

```
# pcs resource create vip ocf:heartbeat:IPaddr2 ¥
    ip="192.168.59.30" cidr_netmask "24" nic="eth0" ¥
    op start timeout="20s" on-fail="restart" ¥
    op stop timeout="20s" on-fail="block" ¥
    op monitor interval="10s" timeout="20s" on-fail="restart" ¥
    --group resource-group
```

上記のコマンドを実行後、`pcs status`コマンドを実行し、クラスタリソースが登録されているかを確認します:

```
# pcs status
Cluster name: cluster
Last updated: Sat Jun 25 16:11:19 2016          Last change: Sat Jun 25 16:11:17 2016 by root via cibadmin on rhel-act
Stack: cman
Current DC: rhel-sta (version 1.1.14-8.el6-70404b0) - partition with quorum
2 nodes and 1 resource configured

Online: [ rhel-act rhel-sta ]

Full list of resources:

 Resource Group: resource-group
     vip        (ocf::heartbeat:IPaddr2):       Started rhel-act

PCSD Status:
  rhel-act: Online
  rhel-sta: Online
```

#### 共有ディスクの登録
`iSCSI`を利用した共有ディスクリソースを登録します。

`iSCSI`を利用したクラスタリソース登録用の`Pacemaker`スクリプトがインストールされていなかったため、まずは`rhel-act`およびに`rhel-sta`サーバ上で以下のコマンドを実行し、スクリプトを登録します:

```
# cd /usr/lib/ocf/resource.d/heartbeat/
# wget https://raw.githubusercontent.com/ClusterLabs/resource-agents/master/heartbeat/iscsi --no-check-certificate
# chmod +x iscsi
```

ダウンロード後、`rhel-act` or `rhel-sta`サーバ上で以下のコマンドを実行します。まずは`pcs resource create shared_device  ocf:heartbeat:iscsi`を実行し、`iSCSI`で共有ディスクを参照できるようにします:

```
pcs resource create shared_device  ocf:heartbeat:iscsi  \
  params \
    portal="192.168.59.40:3260" \
    target="iqn.2016-06.local.test.has:sdb" \
  op start on-fail=block \
  op stop on-fail=block \
  op mointor on-fail=restart \
  --group resource-group
```

その後、`pcs resource create shared_mount Filesystem`を実行し、`iSCSI`で参照できるようになったデバイスをマウントします:

```
pcs resource create shared_mount Filesystem \
  device="/dev/sdb1" \
  directory="/share" \
  fstype="ext4" \
  op start on-fail=block \
  op stop on-fail=block \
  op mointor on-fail=restart \
  --group resource-group
```

#### プログラムをクラスタリソースとして登録する
お仕事で使うプログラムは、

- 起動コマンドを指定する
- 停止コマンドを指定する
- 状態監視コマンドを指定する

という方法でクラスタソフトに登録することを想定していましたが、クラスタソフト側ではそのような登録をすることができませんでした。しょうがないので、以下のようなクラスタリソース登録用のスクリプトを作成しました。`/usr/lib/ocf/resource.d/heartbeat/anything`という名称で保存してください:

```
#!/bin/sh

# OCF instance parameters
#       OCF_RESKEY_start_cmd
#       OCF_RESKEY_stop_cmd
#       OCF_RESKEY_monitor_cmd
#

# Initialization:
: ${OCF_FUNCTIONS_DIR=${OCF_ROOT}/lib/heartbeat}
. ${OCF_FUNCTIONS_DIR}/ocf-shellfuncs

# FIXME: Attributes special meaning to the resource id
#       OCF_RESKEY_start_cmd
#       OCF_RESKEY_stop_cmd
#       OCF_RESKEY_monitor_cmd
start_cmd="$OCF_RESKEY_start_cmd"
stop_cmd="$OCF_RESKEY_stop_cmd"
mointor_cmd="$OCF_RESKEY_monitor_cmd"

anything_status() {
        su - root -c "$OCF_RESKEY_monitor_cmd"
        RESULT=$?

        if [ $RESULT -eq 0 ]; then
          return $OCF_SUCCESS
        else
          return $OCF_NOT_RUNNING
        fi
}

anything_start() {
        if ! anything_status
        then
                su - root -c "$OCF_RESKEY_start_cmd"

                if anything_status
                then
                        ocf_log debug "Resource has started successfully"
                        return $OCF_SUCCESS
                else
                        ocf_log err "Resource fails to start."
                        return $OCF_ERR_GENERIC
                fi
        else
                # If already running, consider start successful
                ocf_log debug "Resource is already running"
                return $OCF_SUCCESS
        fi
}

anything_stop() {
        local rc=$OCF_SUCCESS

        if anything_status
        then
                su - root -c "$OCF_RESKEY_stop_cmd"
        fi

        if ! anything_status
        then
                rc=$OCF_SUCCESS
        fi
        return $rc
}

anything_monitor() {
        su - root -c "$OCF_RESKEY_monitor_cmd"
        RESULT=$?

        echo ${OCF_RESKEY_monitor_cmd} >> /root/result.txt
        echo $RESULT >> /root/result.txt

        if [ $RESULT -eq 0 ]; then
          return $OCF_SUCCESS
        else
          return $OCF_NOT_RUNNING
        fi
}


anything_validate() {
        return $OCF_SUCCESS
}

anything_meta() {
cat <<END
<?xml version="1.0"?>
<!DOCTYPE resource-agent SYSTEM "ra-api-1.dtd">
<resource-agent name="test">
<version>1.0</version>
<longdesc lang="en">
This is a generic OCF RA to manage almost anything.
</longdesc>
<shortdesc lang="en">Manages an arbitrary service</shortdesc>

<parameters>
<parameter name="start_cmd" required="1" unique="1">
<longdesc lang="en">
The start command to execute the resource.
</longdesc>
<shortdesc lang="en">Full path name of the start command to be executed</shortdesc>
<content type="string" default=""/>
</parameter>
<parameter name="stop_cmd" required="1" unique="1">
<longdesc lang="en">
The stop command to execute the resource.
</longdesc>
<shortdesc lang="en">Full path name of the stop command to be executed</shortdesc>
<content type="string" default=""/>
</parameter>
<parameter name="monitor_cmd">
<longdesc lang="en">
Command to run in monitor operation
</longdesc>
<shortdesc lang="en">Command to run in monitor operation</shortdesc>
<content type="string"/>
</parameter>
</parameters>
<actions>
<action name="start"   timeout="60s" />
<action name="stop"    timeout="60s" />
<action name="monitor" depth="0"  timeout="30s" interval="30" />
<action name="meta-data"  timeout="5" />
<action name="validate-all"  timeout="5" />
</actions>
</resource-agent>
END
exit 0
}

case "$1" in
        meta-data|metadata|meta_data)
                anything_meta
        ;;
        start)
                anything_start
        ;;
        stop)
                anything_stop
        ;;
        monitor)
                anything_monitor
        ;;
        validate-all)
                anything_validate
        ;;
        *)
                ocf_log err "$0 was called with unsupported arguments: $*"
                exit $OCF_ERR_UNIMPLEMENTED
        ;;
esac
```

その後、以下のコマンドを実行し、プログラムをクラスタリソースとして登録します:

```
pcs resource create program_logical ocf:heartbeat:anything \
  params \
    start_cmd="/path/to/start-command"  \
    stop_cmd="/path/to/stop-command" \
    monitor_cmd="/path/to/status-check-command" \
  --group resource-group
```

### 各種操作
各種操作について説明します。

#### 状態確認
`pcs status`コマンドを実行し、クラスタの状態を確認します:

```
# pcs status
Cluster name: cluster
Last updated: Sun Jul 10 22:14:31 2016          Last change: Sun Jul 10 22:09:49 2016 by root via crm_attribute on rhel-act
Stack: cman
Current DC: rhel-act (version 1.1.14-8.el6-70404b0) - partition with quorum
2 nodes and 5 resources configured

Online: [ rhel-act rhel-sta ]

Full list of resources:

 Resource Group: resource-group
     vip1       (ocf::heartbeat:IPaddr2):       Started rhel-act
     shared_device      (ocf::heartbeat:iscsi): Started rhel-act
     shared_mount       (ocf::heartbeat:Filesystem):    Started rhel-act
     program_logical    (ocf::heartbeat:anything):  Started rhel-act

PCSD Status:
  rhel-act: Online
  rhel-sta: Online
```

#### ノードのオフライン
`pcs cluster standby`コマンドを実行し、ノードをオフラインにします:

```
# pcs cluster standby rhel-act
# pcs status
Cluster name: cluster
Last updated: Sun Jul 10 22:18:02 2016          Last change: Sun Jul 10 22:16:14 2016 by root via crm_attribute on rhel-act
Stack: cman
Current DC: rhel-act (version 1.1.14-8.el6-70404b0) - partition with quorum
2 nodes and 5 resources configured

Node rhel-act: standby
Online: [ rhel-sta ]

Full list of resources:

 Resource Group: resource-group
     vip1       (ocf::heartbeat:IPaddr2):       Started rhel-sta
     shared_device      (ocf::heartbeat:iscsi): Started rhel-sta
     shared_mount       (ocf::heartbeat:Filesystem):    Started rhel-sta
     program_logical    (ocf::heartbeat:anything):  Started rhel-sta

PCSD Status:
  rhel-act: Online
  rhel-sta: Online
```

`pcs cluster standby --all`コマンドを実行すると、すべてのノードをオフラインにできます:

```
# pcs cluster standby --all
# pcs status
Cluster name: cluster
Last updated: Sun Jul 10 22:20:14 2016          Last change: Sun Jul 10 22:19:26 2016 by root via crm_attribute on rhel-act
Stack: cman
Current DC: rhel-act (version 1.1.14-8.el6-70404b0) - partition with quorum
2 nodes and 5 resources configured

Node rhel-act: standby
Node rhel-sta: standby

Full list of resources:

 Resource Group: resource-group
     vip1       (ocf::heartbeat:IPaddr2):       Stopped
     shared_device      (ocf::heartbeat:iscsi): Stopped
     shared_mount       (ocf::heartbeat:Filesystem):    Stopped
     program_logical    (ocf::heartbeat:anything):  Stopped

PCSD Status:
  rhel-act: Online
  rhel-sta: Online
```

#### ノードのオンライン
`pcs cluster unstandby`コマンドを実行し、ノードをオンラインにします:

```
# pcs cluster unstandby rhel-act
# pcs status
Cluster name: cluster
Last updated: Sun Jul 10 22:23:41 2016          Last change: Sun Jul 10 22:22:37 2016 by root via crm_attribute on rhel-act
Stack: cman
Current DC: rhel-act (version 1.1.14-8.el6-70404b0) - partition with quorum
2 nodes and 5 resources configured

Node rhel-sta: standby
Online: [ rhel-act ]

Full list of resources:

 Resource Group: resource-group
     vip1       (ocf::heartbeat:IPaddr2):       Started rhel-act
     shared_device      (ocf::heartbeat:iscsi): Started rhel-act
     shared_mount       (ocf::heartbeat:Filesystem):    Started rhel-act
     program_logical    (ocf::heartbeat:anything):  Started rhel-act

PCSD Status:
  rhel-act: Online
  rhel-sta: Online
```

`pcs cluster unstandby --all`コマンドを実行すると、すべてのノードをオンラインにできます:

```
# pcs cluster unstandby --all
# pcs status
Cluster name: cluster
Last updated: Sun Jul 10 22:25:37 2016          Last change: Sun Jul 10 22:25:21 2016 by root via crm_attribute on rhel-act
Stack: cman
Current DC: rhel-act (version 1.1.14-8.el6-70404b0) - partition with quorum
2 nodes and 5 resources configured

Online: [ rhel-act rhel-sta ]

Full list of resources:

 Resource Group: resource-group
     vip1       (ocf::heartbeat:IPaddr2):       Started rhel-act
     shared_device      (ocf::heartbeat:iscsi): Started rhel-act
     shared_mount       (ocf::heartbeat:Filesystem):    Started rhel-act
     program_logical    (ocf::heartbeat:anything):  Started rhel-act

PCSD Status:
  rhel-act: Online
  rhel-sta: Online
```

#### リソースの系切り替え
`pcs resource move`コマンドを実行し、リソースの系切り替えを行います。たとえば、`program_logical`を`rhel-sta`に移動させる場合、以下のコマンドを実行します:

```
# pcs resource move program_logical rhel-sta
```

## 参考
- [CentOS 7 で DRBD/Pacemaker/Corosync で High Availability NFS \- Qiita](http://qiita.com/ngyuki/items/9c2c6fccaa2ea8bb054f)
- [これで安心！信頼性を高めるサーバのクラスタ構成 Part2](http://maplesystems.co.jp/blog/programming/15889.html)
- [Pacemakerクラスタ管理コマンドまとめ \- とあるエンジニアの技術メモ](http://kan3aa.hatenablog.com/entry/2015/11/14/194942)
- [超私的 Undocumented Pacemaker and Corosync Vol\.2 \| cloudpack技術情報サイト](https://blog.cloudpack.jp/2014/07/29/undocumented-pacemaker-2/)
- [Pacemaker を使用した Red Hat High Availability Add\-On の設定](https://access.redhat.com/documentation/ja-JP/Red_Hat_Enterprise_Linux/6/html-single/Configuring_the_Red_Hat_High_Availability_Add-On_with_Pacemaker/index.html)
- [インフラ構築手順書 Pacemaker\+MySQLレプリケーション構築【Pacemakerインストール】](http://infra.blog.shinobi.jp/Entry/120/)
- [Blue21: \[CentOS6\] Pacemaker\(Corosync\) のインストール](https://blue21neo.blogspot.sg/2016/03/centos6-pacemaker-corosync.html)
- [Pacemaker \+ Corosync を利用してHAクラスタを構成するレシピ \- Qiita](http://qiita.com/MahoTakara/items/42da4199a99ae9532a25)
- [Corosync と Pacemaker で作る HA 環境 \| cloudpack技術情報サイト](https://blog.cloudpack.jp/2014/07/14/corosync-pacemaker-ha/)
