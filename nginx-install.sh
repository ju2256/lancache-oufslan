#!/bin/bash
# script d'installation de nginx 1.9.10 pour lancache
echo 'installation des dépendances'
apt-get install build-essential libpcre3-dev zlib1g-dev git

echo ' recuperation de la configuration lancache oufslan'
[ -d /etc/nginx ] && echo "data Exists" || mkdir /etc/nginx
cd /etc/nginx
git clone https://github.com/ju2256/lancache-oufslan.git

echo ' creation des repertoires sur \data'

[ -d /data ] && echo "data Exists" || mkdir /data
[ -d /data/src ] && echo "data Exists" || mkdir /data/src
[ -d /data/logs ] && echo "data Exists" || mkdir /data/logs
[ -d /data/cache ] && echo "data Exists" || mkdir /data/cache
[ -d /data/cache/other ] && echo "data Exists" || mkdir /data/cache/other
[ -d /data/cache/tmp ] && echo "data Exists" || mkdir /data/cache/tmp
[ -d /data/cache/blizzard ] && echo "data Exists" || mkdir /data/cache/blizzard
[ -d /data/cache/steam ] && echo "data Exists" || mkdir /data/cache/steam
[ -d /data/cache/origin ] && echo "data Exists" || mkdir /data/cache/origin
[ -d /data/cache/riot ] && echo "data Exists" || mkdir /data/cache/riot
[ -d /data/cache/windows ] && echo "data Exists" || mkdir /data/cache/windows
[ -d /data/cache/twitch ] && echo "data Exists" || mkdir /data/cache/twitch

echo 'changement droits sur /data'
chown -R www-data:www-data /data
chmod -R 755 /data
echo ' telechargement des sources nginx + modules'
cd /data/src
git clone https://github.com/openresty/sregex.git
git clone https://github.com/openresty/replace-filter-nginx-module.git
wget http://nginx.org/download/nginx-1.9.10.tar.gz

echo 'regexlib'
cd sregex
make
make install
cd ..
echo 'nginx'
tar xvzf nginx-1.9.10.tar.gz
cd nginx-1.9.10
echo 'configure with custom options'

./configure --prefix=/etc/nginx \
--error-log-path=/data/logs/nginx-error.log \
--http-log-path=/data/logs/nginx-access.log \
--pid-path=/var/run/nginx.pid \
--with-http_sub_module \
--with-http_slice_module \
--with-http_stub_status_module \
--add-module=../replace-filter-nginx-module \
--with-ld-opt="-Wl,-rpath,/usr/local/lib"

echo ' make'
make

echo 'make install'
make install
echo 'nginx installed in /etc/nginx'

exit 0
