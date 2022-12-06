#!/bin/bash

set -e

# Install nginx,php
sudo su -
yum -y install gcc gcc-c++ autoconf automake make cmake pcre pcre-devel wget
yum -y install openssl openssl-devel expat-devel libxml2-devel ncurses
yum -y install ncurses-devel bison zlib-devel libtool-ltdl-devel libtool flex
yum -y install php php-fpm php-mysqlnd unzip mariadb mariadb-devel
cd ~ && wget http://nginx.org/download/nginx-1.22.1.tar.gz
tar -xf nginx-1.22.1.tar.gz -C /usr/src/
cd /usr/src/nginx-1.22.1/
./configure --prefix=/usr/local/nginx --user=nginx --group=nginx --with-http_ssl_module --with-http_stub_status_module
make && make install
[ $? -eq 0 ] && cd ~ && rm -rf nginx-1.22.1.tar.gz /usr/src/nginx-1.22.1/
useradd -M -s /sbin/nologin nginx

# config php and start service
sed -i 's/user = apache/user = nginx/' /etc/php-fpm.d/www.conf
sed -i 's/group = apache/group = nginx/' /etc/php-fpm.d/www.conf
systemctl enable php-fpm --now

# config nginx
cd ~ && wget --content-disposition https://github.com/EliasChanm/lnmp/archive/refs/heads/main.zip && unzip main.zip
/bin/cp -f lnmp-main/nginx.conf /usr/local/nginx/conf/nginx.conf && rm -rf main.zip lnmp-main

# online Discuz
cd ~ && wget http://discuz.net/down/Discuz_X3.4_SC_UTF8_20220811.zip && mkdir -p /usr/src/discuz
unzip /root/Discuz_X3.4_SC_UTF8_20220811.zip -d /usr/src/discuz
cp -r /usr/src/discuz/upload/* /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/{config/,data/}
chmod -R 777 /usr/local/nginx/html/uc_client/data/cache
chmod -R 777 /usr/local/nginx/html/uc_server/data
chown -R nginx /usr/local/nginx/html
rm -rf ~/Discuz_X3.4_SC_UTF8_20220811.zip /usr/src/discuz

# start nginx
/usr/local/nginx/sbin/nginx -t && /usr/local/nginx/sbin/nginx
