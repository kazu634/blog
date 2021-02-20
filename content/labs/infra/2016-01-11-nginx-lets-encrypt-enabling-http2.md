+++
categories = [ "nginx" ]
description = "nginx + Let's Encryptを用いてhttp/2環境を構築してみました。"
tags = []
date = "2016-01-11T23:32:47+08:00"
title = "nginx + let's encryptを利用してHTTP/2を有効化した"
thumnail = "images/24021542270_0971890cc8_z.jpg"
+++

`nginx`+`Let's Encrypt`で`http/2`環境を構築したのでその時のメモです。

## `nginx`のインストール・セットアップ
### `nginx`で必要になる前提パッケージ
`libgeoip-dev`をインストールします:

```
% aptitude install libgeoip-dev
```

### nginx-buildのインストール
[cubicdaiya/nginx-build](https://github.com/cubicdaiya/nginx-build)をインストールします:

```
% wget https://github.com/cubicdaiya/nginx-build/releases/download/v0.6.5/nginx-build-linux-amd64-0.6.5.tar.gz
```

### nginxのインストール
以下の手順で`nginx`をインストールします:

```
% vi configure.sh

% ./nginx-build -d temp -v 1.9.9 -c configure.sh -zlib -pcre -openssl

% cd temp/nginx/1.9.9/nginx-1.9.9

% sudo make install
```

なお、`configure.sh`は以下の内容です:

```
#!/bin/bash

./configure --with-cc-opt='-g -O2 -fPIE -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' ¥
            --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log ¥
            --error-log-path=/var/log/nginx/error.log  --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid ¥
            --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi ¥
            --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi ¥
            --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module ¥
            --with-http_v2_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module ¥
            --with-http_addition_module --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module ¥
            --with-http_sub_module
```

### `nginx`のセットアップ
`nginx`をセットアップします。

#### `nginx`起動に必要となるディレクトリ作成
`nginx`起動に必要となるディレクトリを作成します:

```
% sudo mkdir -p /var/lib/nginx/{body,fastcgi,proxy,scgi,uwsgi}
```

#### `nginx`設定ファイルなどのデプロイ
`nginx`設定ファイルなどをデプロイします:

```
% sudo mkdir -p /etc/nginx/{sites-available,sites-enabled}

% vi /etc/nginx/nginx.conf

% vi /etc/init.d/nginx
% sudo update-rc.d nginx defaults

% vi /etc/nginx/sites-enabled/default
```

`nginx.conf`の中身は以下のとおりです:

```
user www-data;

# Newer version of Nginx calculates the worker_processes,
# based on the CPU cores. Use this feature:
worker_processes auto;

pid /run/nginx.pid;

# number of file descriptors used for nginx
# the limit for the maximum file descriptors on the server is usually set by the OS.
# if you don't set FD's then OS settings will be used.
worker_rlimit_nofile 100000;

events {
    # determines how much clients will be served per worker
    # max clients = worker_connections * worker_processes
    # max clients is also limited by the number of socket connections available on the system (~64k)
    worker_connections 4096;

    # accept as many connections as possible
    multi_accept on;

    # mutex config:
    accept_mutex on;
    accept_mutex_delay 100ms; # default: 500 -> 100 ms

    # optmized to serve many clients with each thread, essential for linux
    use epoll;
}

http {

    ##
    # Basic Settings
    ##

    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 30;
    types_hash_max_size 2048;

    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    server_names_hash_bucket_size  128;

    # cache informations about FDs, frequently accessed files
    # can boost performance:
    open_file_cache max=200000 inactive=20s;
    open_file_cache_valid 30s;
    open_file_cache_min_uses 2;
    open_file_cache_errors on;

    # allow the server to close connection on non responding client,
    # this will free up memory
    reset_timedout_connection on;

    # request timed out -- default 60
    client_body_timeout 10s;

    # if client stop responding, free up memory -- default 60
    send_timeout 2s;

    ##
    # Logging Settings
    ##

    log_format ltsv "time:$time_local\thost:$remote_addr"
                    "\tforwardedfor:$http_x_forwarded_for\t"
                    "method:$request_method\tpath:$request_uri\tprotocol:$server_protocol"
                    "\tstatus:$status\tsize:$body_bytes_sent\treferer:$http_referer"
                    "\tua:$http_user_agent\ttaken_sec:$request_time"
                    "\tbackend:$upstream_addr\tbackend_status:$upstream_status"
                    "\tcache:$upstream_http_x_cache\tbackend_runtime:$upstream_response_time"
                    "\tvhost:$host";

    access_log /var/log/nginx/access.log ltsv;
    error_log /var/log/nginx/error.log;

    ##
    # Gzip Settings
    ##

    gzip on;
    gzip_disable "msie6";
    gzip_min_length 10240;
    gzip_types text/plain text/css application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript;

    ##
    # Virtual Host Configs
    ##

    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

`nginx`の設定ファイルの中身は以下のとおりです:

```
#!/bin/sh

### BEGIN INIT INFO
# Provides:       nginx
# Required-Start:    $local_fs $remote_fs $network $syslog $named
# Required-Stop:     $local_fs $remote_fs $network $syslog $named
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: starts the nginx web server
# Description:       starts nginx using start-stop-daemon
### END INIT INFO

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/share/nginx/sbin/
DAEMON=/usr/share/nginx/sbin/nginx
NAME=nginx
DESC=nginx

# Include nginx defaults if available
if [ -r /etc/default/nginx ]; then
        . /etc/default/nginx
fi

STOP_SCHEDULE="${STOP_SCHEDULE:-QUIT/5/TERM/5/KILL/5}"

test -x $DAEMON || exit 0

. /lib/init/vars.sh
. /lib/lsb/init-functions

# Try to extract nginx pidfile
PID=$(cat /etc/nginx/nginx.conf | grep -Ev '^\s*#' | awk 'BEGIN { RS="[;{}]" } { if ($1 == "pid") print $2 }' | head -n1)
if [ -z "$PID" ]
then
        PID=/run/nginx.pid
fi

# Check if the ULIMIT is set in /etc/default/nginx
if [ -n "$ULIMIT" ]; then
        # Set the ulimits
        ulimit $ULIMIT
fi

#
# Function that starts the daemon/service
#
do_start()
{
        # Return
        #   0 if daemon has been started
        #   1 if daemon was already running
        #   2 if daemon could not be started
        start-stop-daemon --start --quiet --pidfile $PID --exec $DAEMON --test > /dev/null \
                || return 1
        start-stop-daemon --start --quiet --pidfile $PID --exec $DAEMON -- \
                $DAEMON_OPTS 2>/dev/null \
                || return 2
}

test_nginx_config() {
        $DAEMON -t $DAEMON_OPTS >/dev/null 2>&1
}

#
# Function that stops the daemon/service
#
do_stop()
{
        # Return
        #   0 if daemon has been stopped
        #   1 if daemon was already stopped
        #   2 if daemon could not be stopped
        #   other if a failure occurred
        start-stop-daemon --stop --quiet --retry=$STOP_SCHEDULE --pidfile $PID --name $NAME
        RETVAL="$?"

        sleep 1
        return "$RETVAL"
}

#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
        start-stop-daemon --stop --signal HUP --quiet --pidfile $PID --name $NAME
        return 0
}

#
# Rotate log files
#
do_rotate() {
        start-stop-daemon --stop --signal USR1 --quiet --pidfile $PID --name $NAME
        return 0
}

#
# Online upgrade nginx executable                                                                                                                                                                                                                                      [67/1833]
#
# "Upgrading Executable on the Fly"
# http://nginx.org/en/docs/control.html
#
do_upgrade() {
        # Return
        #   0 if nginx has been successfully upgraded
        #   1 if nginx is not running
        #   2 if the pid files were not created on time
        #   3 if the old master could not be killed
        if start-stop-daemon --stop --signal USR2 --quiet --pidfile $PID --name $NAME; then
                # Wait for both old and new master to write their pid file
                while [ ! -s "${PID}.oldbin" ] || [ ! -s "${PID}" ]; do
                        cnt=`expr $cnt + 1`
                        if [ $cnt -gt 10 ]; then
                                return 2
                        fi
                        sleep 1
                done
                # Everything is ready, gracefully stop the old master
                if start-stop-daemon --stop --signal QUIT --quiet --pidfile "${PID}.oldbin" --name $NAME; then
                        return 0
                else
                        return 3
                fi
        else
                return 1
        fi
}

case "$1" in
        start)
                [ "$VERBOSE" != no ] && log_daemon_msg "Starting $DESC" "$NAME"
                do_start
                case "$?" in
                        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
                esac
                ;;
        stop)
                [ "$VERBOSE" != no ] && log_daemon_msg "Stopping $DESC" "$NAME"
                do_stop
                case "$?" in
                        0|1) [ "$VERBOSE" != no ] && log_end_msg 0 ;;
                        2) [ "$VERBOSE" != no ] && log_end_msg 1 ;;
                esac
                ;;
        restart)
                log_daemon_msg "Restarting $DESC" "$NAME"

                # Check configuration before stopping nginx
                if ! test_nginx_config; then
                        log_end_msg 1 # Configuration error
                        exit 0
                fi

                do_stop
                case "$?" in
                        0|1)
                                do_start
                                case "$?" in
                                        0) log_end_msg 0 ;;
                                        1) log_end_msg 1 ;; # Old process is still running
                                        *) log_end_msg 1 ;; # Failed to start
                                esac
                                ;;
                        *)
                                # Failed to stop
                                log_end_msg 1
                                ;;
                esac
                ;;
        reload|force-reload)
                log_daemon_msg "Reloading $DESC configuration" "$NAME"

                # Check configuration before reload nginx
                #
                # This is not entirely correct since the on-disk nginx binary
                # may differ from the in-memory one, but that's not common.
                # We prefer to check the configuration and return an error
                # to the administrator.
                if ! test_nginx_config; then
                        log_end_msg 1 # Configuration error
                        exit 0
                fi

                do_reload
                log_end_msg $?
                ;;
        configtest|testconfig)
                log_daemon_msg "Testing $DESC configuration"
                test_nginx_config
                log_end_msg $?
                ;;
        status)
                status_of_proc -p $PID "$DAEMON" "$NAME" && exit 0 || exit $?
                status_of_proc -p $PID "$DAEMON" "$NAME" && exit 0 || exit $?
                ;;
        upgrade)
                log_daemon_msg "Upgrading binary" "$NAME"
                do_upgrade
                log_end_msg 0
                ;;
        rotate)
                log_daemon_msg "Re-opening $DESC log files" "$NAME"
                do_rotate
                log_end_msg $?
                ;;
        *)
                echo "Usage: $NAME {start|stop|restart|reload|force-reload|status|configtest|rotate|upgrade}" >&2
                exit 3
                ;;
esac

:
```

`/etc/nginx/sites-enabled/default`の中身は以下のとおりです:

```
server {
  # allow access from localhost
  listen 80 reuseport backlog=1024;
  server_name test.kazu634.com;

  root /usr/share/nginx/html;
  index index.html index.htm;

  location / {
    gzip on;
    gzip_types text/css text/javascript;
    gzip_vary on;

    gzip_static always;
    gunzip on;

    try_files $uri $uri/ /index.html;

  }
}

# Denies the access without the pre-defined virtual host.
server {
  listen 80 default_server;
  server_name _;

  return 444;
}
```



## Let's Encyptを用いて証明書を取得する
以下の手順で[Let's Encrypt](https://letsencrypt.org/)から証明書を取得します:

```
% git clone https://github.com/letsencrypt/letsencrypt

% cd letsencrypt

% ./letsencrypt-auto certonly --webroot -d test.kazu634.com --webroot-path /usr/share/nginx/html/
```

途中で以下のダイアログが表示されます。ひとつ目のダイアログではメールアドレスを入力します:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/24290975906/in/dateposted/" title="1. tmux"><img src="https://farm2.staticflickr.com/1482/24290975906_26411cea6e_z.jpg" width="640" height="485" alt="1. tmux"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

次のダイアログでは`[Agree]`ボタンを押します:

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/24021542300/in/dateposted/" title="2. tmux"><img src="https://farm2.staticflickr.com/1609/24021542300_efacda5ea8_z.jpg" width="640" height="485" alt="2. tmux"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

すると以下のような注意書きが表示されます:

```
IMPORTANT NOTES:
 - If you lose your account credentials, you can recover through
   e-mails sent to simoom634@yahoo.co.jp.
 - Congratulations! Your certificate and chain have been saved at
   /etc/letsencrypt/live/test.kazu634.com/fullchain.pem. Your cert
   will expire on 2016-04-02. To obtain a new version of the
   certificate in the future, simply run Let's Encrypt again.
 - Your account credentials have been saved in your Let's Encrypt
   configuration directory at /etc/letsencrypt. You should make a
   secure backup of this folder now. This configuration directory will
   also contain certificates and private keys obtained by Let's
   Encrypt so making regular backups of this folder is ideal.
 - If you like Let's Encrypt, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

これで終わりです:

### Grade A+取得の道
[Qualys SSL Labs](https://www.ssllabs.com/index.html)で評価A+を目指した軌跡です。基本は[nginx - 我々はどのようにして安全なHTTPS通信を提供すれば良いか - Qiita](http://qiita.com/harukasan/items/fe37f3bab8a5ca3f4f92)を参考にして設定しています。

#### 暗号化スイートの選択
以下のように設定しました:

```
  ssl_protocols TLSv1.2 TLSv1.1 TLSv1;
  ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:DES-CBC3-SHA;
  ssl_prefer_server_ciphers on;
```

#### OCSP Staplingの設定
以下のように設定しました:

```
  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 8.8.4.4 8.8.8.8 valid=300s;
  resolver_timeout 10s;
```

#### ssl_dhparam
以下のコマンドを実行し、`DH鍵交換`に使用する暗号化ファイルを作成しました:

```
% sudo openssl dhparam -out /etc/letsencrypt/live/test.kazu634.com/dhparams_4096.pem 4096
```

作成後以下のように設定を実施しました:

```
  ssl_dhparam /etc/letsencrypt/live/test.kazu634.com/dhparams_4096.pem;
```

#### HTTP Strict Transport Security(HSTS)の付与
以下のように設定を行います:

```
  # Enable HSTS (HTTP Strict Transport Security)
  add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload";
```

#### TLS Session Ticketsの有効化
以下のコマンドで鍵ファイルを作成します:

```
# openssl rand 48 > /etc/letsencrypt/live/test.kazu634.com/ticket.key
```

その後、以下のように設定を実施します:

```
  ssl_session_tickets on;
  ssl_session_ticket_key /etc/letsencrypt/live/test.kazu634.com/ticket.key;
```

#### 結論
まとめると、以下のような`nginx`の設定ファイルを作成します:

```
server {
  # allow access from localhost
  # listen 80 reuseport backlog=1024;
  listen 443 ssl http2 backlog=1024;
  server_name test.kazu634.com;

  ssl_certificate /etc/letsencrypt/live/test.kazu634.com/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/test.kazu634.com/privkey.pem;
  ssl_dhparam /etc/letsencrypt/live/test.kazu634.com/dhparams_4096.pem;

  ssl_session_cache   shared:SSL:3m;
  ssl_buffer_size     4k;
  ssl_session_timeout 10m;

  ssl_session_tickets on;
  ssl_session_ticket_key /etc/letsencrypt/live/test.kazu634.com/ticket.key;

  ssl_protocols TLSv1.2 TLSv1.1 TLSv1;
  ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:AES128-GCM-SHA256:AES128-SHA256:AES128-SHA:AES256-GCM-SHA384:AES256-SHA256:AES256-SHA:DES-CBC3-SHA;
  ssl_prefer_server_ciphers on;

  ssl_stapling on;
  ssl_stapling_verify on;
  resolver 8.8.4.4 8.8.8.8 valid=300s;
  resolver_timeout 10s;

  # Enable HSTS (HTTP Strict Transport Security)
  add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload";

  root /var/www/blog_cache;
  index index.html index.htm;

  location / {
    gzip on;
    gzip_types text/css text/javascript;
    gzip_vary on;

    gzip_static always;
    gunzip on;

    try_files $uri $uri/ /index.html;

  }
}

# Denies the access without the pre-defined virtual host.
server {
  listen 80 default_server;
  server_name _;

  return 444;
}
```

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/42332031@N02/24021542270/in/dateposted/" title="SSL Server Test_ test.kazu634.com (Powered by Qualys SSL Labs)"><img src="https://farm2.staticflickr.com/1510/24021542270_0971890cc8_z.jpg" width="640" height="448" alt="SSL Server Test_ test.kazu634.com (Powered by Qualys SSL Labs)"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

