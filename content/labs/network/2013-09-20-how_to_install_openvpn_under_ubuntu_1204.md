---
title: Ubuntu 12.04でOpenVPNをインストールする
author: kazu634
date: 2013-09-20
geo_latitude:
  - 38.305994
geo_longitude:
  - 141.022701
geo_public:
  - 1
wordtwit_posted_tweets:
  - 'a:1:{i:0;i:1855;}'
wordtwit_post_info:
  - 'O:8:"stdClass":13:{s:6:"manual";b:0;s:11:"tweet_times";s:1:"1";s:5:"delay";s:1:"0";s:7:"enabled";s:1:"1";s:10:"separation";i:60;s:7:"version";s:3:"3.7";s:14:"tweet_template";b:0;s:6:"status";i:2;s:6:"result";a:0:{}s:13:"tweet_counter";i:2;s:13:"tweet_log_ids";a:1:{i:0;i:1855;}s:9:"hash_tags";a:0:{}s:8:"accounts";a:1:{i:0;s:7:"kazu634";}}'
author:
  - kazu634
categories:
  - openvpn

---
<div class="entry-content">
<p>
    OpenVPNを導入してみたくなり、Ubuntu 12.04 で導入してみました。ネットワークの分野はまだよく理解できていないため、自分で手を動かして動作させられたことに満足です。
</p>
  
<h2>
    OpenVPN とは
</h2>
  
<p>
    異なるネットワークに所属する個々のクライアントを仮想的な同一ネットワークに所属させる仕組み……のようです。VPN を経由した通信はすべて暗号化されるため、物理的に離れた機器同士を接続する際に使われるようです。色々と試行錯誤して試してみた結果、要するにインターネットからアクセス可能な公開用ルーターに相当するものに接続、ルーターにぶら下がっている機器同士で暗号化された通信を実現しているようです。
</p>
  
<p>
    簡単に図で説明してみます。物理的には以下の様な構成になっているとします。
</p>
  
<h3>
    自宅内のネットワーク
</h3>
  
<p>
    1つ目は自宅内のネットワーク:
</p>
  
<p>
<a href="https://www.flickr.com/photos/42332031@N02/15327938728" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15327938728', '');" title="20130915_HomeNetwork by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm4.staticflickr.com/3930/15327938728_d8233047e0.jpg" alt="20130915_HomeNetwork" width="439" height="408" /></a>
</p>
  
<h3>
    外部の公衆無線LANサービスなどに接続している機器が所属するネットワーク
</h3>
  
<p>
    2つめは自宅外のネットワーク。例えば外部の公衆無線LANサービスに接続した iPad とかですかね。iPhone などでもいいですね:
</p>
  
<p>
<a href="https://www.flickr.com/photos/42332031@N02/15328022177" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15328022177', '');" title="20130915_PublicWifi by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm6.staticflickr.com/5597/15328022177_72960b3ae6.jpg" alt="20130915_PublicWifi" width="430" height="404" /></a>
</p>
  
<h3>
    VPNネットワーク
</h3>
  
<p>
    VPNで接続すると仮想的なプライベートネットワークにぶら下がることになります。VPNサーバはグローバルIPを持ち、外部からアクセスできる必要があります。
</p>
  
<p>
<a href="https://www.flickr.com/photos/42332031@N02/15327865330" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://www.flickr.com/photos/42332031@N02/15327865330', '');" title="20130915_VPNNetwork by Kazuhiro MUSASHI, on Flickr"><img class="aligncenter" src="https://farm6.staticflickr.com/5605/15327865330_4e97a01b28.jpg" alt="20130915_VPNNetwork" width="500" height="362" /></a>
</p>
  
<p>
    このように仮想的なプライベートネットワークに各サーバがぶら下がる形になります。
</p>
  
<p>
<!-- more -->
</p>
  
<h2>
    OpenVPNのインストール
</h2>
  
<p>
    OpenVPN のインストール方法を説明します。サーバ側で実施する作業を解説します！
</p>
  
<h3>
    事前設定: カーネルパラメータ
</h3>
  
<p>
<code>/etc/sysctl.conf</code>を編集し、IPv4 のパケット転送を許可します:
</p>
  
<pre class="lang:default decode:true ">net.ipv4.ip_forward=1</pre>
  
<p>
    ※ 「#」を外します。
</p>
  
<p>
    編集後 <code>sudo sysctl -p</code> を実行します。
</p>
  
<h3>
    事前設定: ファイアーウォールの設定
</h3>
  
<p>
    OpenVPNサーバをOpenVPNクライアントのデフォルトゲートウェイにした場合、VPNに接続したクライアントがインターネットと接続するためには、OpenVPNサーバ側でパケットをインターネット側に転送して上げる必要があります。以下のコマンドを実行してあげます:
</p>
  
<pre class="lang:sh decode:true ">sudo iptables -t nat -A POSTROUTING -s 10.8.0.0/255.255.0.0 -o eth0 -j MASQUERADE</pre>
  
<h3>
    パッケージのインストール
</h3>
  
<p>
    パッケージをインストールします:
</p>
  
<pre class="lang:sh decode:true ">sudo aptitude install openvpn libssl-dev openssl</pre>
  
<h2>
    OpenVPNサーバ側の設定
</h2>
  
<h3>
    サーバ鍵の作成
</h3>
  
<p>
    ひな形になるファイルがあるので、それをコピーしてあげます:
</p>
  
<pre class="lang:sh decode:true ">sudo mkdir /etc/openvpn/easy-rsa/
sudo cp -R /usr/share/doc/openvpn/examples/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
sudo chown -R $USER /etc/openvpn/easy-rsa/</pre>
  
<p>
    認証局の設定情報を指定してあげます:
</p>
  
<pre class="lang:sh decode:true ">export KEY_COUNTRY=”US”
export KEY_PROVINCE=”NY”
export KEY_CITY=”New York City”
export KEY_ORG=”Queens”
export KEY_EMAIL=”me@myhost.mydomain”</pre>
  
<p>
    サーバ用の鍵を作成します:
</p>
  
<pre class="lang:sh decode:true ">cd /etc/openvpn/easy-rsa/
ln -s openssl-1.0.0.cnf openssl.cnf

cd /etc/openvpn/easy-rsa/
source vars
./clean-all
./build-dh
./pkitool –initca
./pkitool –server server
cd keys
openvpn –genkey –secret ta.key</pre>
  
<p>
    サーバ用のキーを所定の場所にコピーします:
</p>
  
<pre class="lang:sh decode:true ">cp server.crt server.key ca.crt dh1024.pem ta.key /etc/openvpn/</pre>
  
<h3>
    OpenVPN サーバの設定
</h3>
  
<p>
    サンプルとなるファイルをコピーします:
</p>
  
<pre class="lang:sh decode:true ">cp /usr/share/doc/openvpn/examples/sample-config-files/server.conf.gz /etc/openvpn/
gzip -d /etc/openvpn/server.conf.gz</pre>
  
<p>
<code>vi /etc/openvpn/server.conf</code>で設定ファイルを編集します。
</p>
  
<p>
    以下の行を編集して、OpenVPN内部のネットワークで使用する IP アドレスを指定します。デフォルトは「10.8.0.0/24」です:
</p>
  
<pre class="lang:default decode:true ">server 192.168.2.0 255.255.255.0</pre>
  
<p>
    OpenVPNサーバをデフォルトゲートウェイとして扱うために、以下の設定の「;」を削除してあげます:
</p>
  
<pre class="lang:default decode:true ">push "redirect-gateway def1 bypass-dhcp"</pre>
  
<p>
    セキュリティ上の理由から、OpenVPNサーバを実行するユーザー・グループを指定してあげます:
</p>
  
<pre class="lang:default decode:true ">user nobody
group nogroup</pre>
  
<h3>
    server.confのサンプル
</h3>
  
<p>
    server.confのサンプルはこのようになります:
</p>
  
<pre class="lang:default decode:true "># OpenVPN server config file
#
# Generated by Chef - local changes will be overwritten

port 1194
proto tcp
dev tun
keepalive 10 120
comp-lzo
local 0.0.0.0

# Keys and certificates.
ca   /etc/openvpn/keys/ca.crt
key  /etc/openvpn/keys/server.key # This file should be kept secret.
cert /etc/openvpn/keys/server.crt
dh   /etc/openvpn/keys/dh1024.pem

ifconfig-pool-persist /etc/openvpn/ipp.txt

server 10.8.0.0 255.255.0.0

user nobody
group nogroup

# avoid accessing certain resources on restart
persist-key
persist-tun

# current client connections
status /etc/openvpn/openvpn-status.log

# logging settings.
log-append  /var/log/openvpn.log
verb 1  # don't spam the log with messages.
mute 10 # suppress identical messages &gt; 10 occurances.

script-security 1
push "redirect-gateway def1 bypass-dhcp"</pre>
  
<h2>
    OpenVPNクライアント側の設定
</h2>
  
<h3>
    クライアント用の鍵作成
</h3>
  
<p>
    以下のコマンドを実行して、クライアント用の鍵を作成します:
</p>
  
<pre class="lang:sh decode:true ">cd /etc/openvpn/easy-rsa/
source vars
KEY_CN=someuniqueclientcn ./pkitool client</pre>
  
<p>
    注意点としては、KEY_CNを変更してあげないとうまく鍵作成ができないことです。詳細は<a href="http://blog.kenyap.com.au/2012/07/txtdb-error-number-2-when-generating.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://blog.kenyap.com.au/2012/07/txtdb-error-number-2-when-generating.html', 'Greenpossum today: TXT_DB error number 2 when generating openvpn client certificates');">Greenpossum today: TXT_DB error number 2 when generating openvpn client certificates</a>を参照ください。
</p>
  
<h3>
    クライアントへの鍵配備
</h3>
  
<p>
    以下のファイルをクライアント側へ配備します:
</p>
  
<ul>
<li>
      /etc/openvpn/ca.crt
</li>
<li>
      /etc/openvpn/ta.key
</li>
<li>
      /etc/openvpn/easy-rsa/keys/client.crt
</li>
<li>
      /etc/openvpn/easy-rsa/keys/client.key
</li>
</ul>
  
<p>
    またクライアント用の設定ファイルも server.conf をベースに作成する必要があります。ovpnという形式でクライアントキーなどを一つのファイルにまとめることが可能です。<a href="http://www.marbacka.net/misc/arkiv/openvpn_iphone.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.marbacka.net/misc/arkiv/openvpn_iphone.html', 'iPhoneでOpenVPNを使おう');">iPhoneでOpenVPNを使おう</a>を参考にしてください。この設定ファイルもクライアント側に配備します。
</p>
  
<h3>
    クライアント用設定ファイルのサンプル
</h3>
  
<p>
    クライアント用の設定ファイルのサンプルです:
</p>
  
<pre class="lang:default decode:true ">client
dev tun
proto tcp
remote openvpn-server.kazu634.com 1194
resolv-retry infinite
nobind
persist-key
persist-tun
;ca ca.crt
;cert ipad.crt
;key ipad.key
comp-lzo
verb 3

&lt;ca&gt;
-----BEGIN CERTIFICATE-----
MIIDuDCCAyGgAwIBAgIJANv02SnW6i6TMA0GCSqGSIb3DQEBBQUAMIGaMQswCQYD
[... snip ...]
Ggx0uDBQuVzhC4skB9YXt+Z2TCzXogEBtE9h/A0tR8t+ErsoXSDJ3UC7MRI=
-----END CERTIFICATE-----
&lt;/ca&gt;
&lt;cert&gt;
-----BEGIN CERTIFICATE-----
MIID9TCCA16gAwIBAgIBAjANBgkqhkiG9w0BAQUFADCBmjELMAkGA1UEBhMCSlAx
[... snip ...]
5uE2hKer80ia
-----END CERTIFICATE-----
&lt;/cert&gt;
&lt;key&gt;
-----BEGIN PRIVATE KEY-----
MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMesHWRNGH9klvU/
[... snip ...]
GHsGbRenaBWR0A==
-----END PRIVATE KEY-----
&lt;/key&gt;</pre>
  
<h2>
    まとめ
</h2>
  
<p>
    OpenVPNクライアント側でクライアント用に生成したファイル一式を配備してあげれば、OpenVPNで接続できるようになります。
</p>
  
<h3>
    参考
</h3>
  
<ul>
<li>
<a href="http://www.slsmk.com/installing-openvpn-on-ubuntu-server-12-04-using-tun/" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.slsmk.com/installing-openvpn-on-ubuntu-server-12-04-using-tun/', 'Installing OpenVPN on Ubuntu Server 12.04 using TUN | Super Library of Solutions');">Installing OpenVPN on Ubuntu Server 12.04 using TUN | Super Library of Solutions</a>
</li>
<li>
<a href="http://blog.kenyap.com.au/2012/07/txtdb-error-number-2-when-generating.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://blog.kenyap.com.au/2012/07/txtdb-error-number-2-when-generating.html', 'Greenpossum today: TXT_DB error number 2 when generating openvpn client certificates');">Greenpossum today: TXT_DB error number 2 when generating openvpn client certificates</a>
</li>
<li>
<a href="https://help.ubuntu.com/community/OpenVPN#Generating_Client_Certificate_and_Key" onclick="__gaTracker('send', 'event', 'outbound-article', 'https://help.ubuntu.com/community/OpenVPN#Generating_Client_Certificate_and_Key', 'OpenVPN &#8211; Community Ubuntu Documentation');">OpenVPN &#8211; Community Ubuntu Documentation</a>
</li>
<li>
<a href="http://www.marbacka.net/misc/arkiv/openvpn_iphone.html" onclick="__gaTracker('send', 'event', 'outbound-article', 'http://www.marbacka.net/misc/arkiv/openvpn_iphone.html', 'iPhoneでOpenVPNを使おう');">iPhoneでOpenVPNを使おう</a>
</li>
</ul>
</div>
