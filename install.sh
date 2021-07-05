#!/bin/sh
sudo apt install -y wget
wget https://repo.zabbix.com/zabbix/5.4/debian/pool/main/z/zabbix-release/zabbix-release_5.4-1+debian10_all.deb
dpkg -i zabbix-release_5.4-1+debian10_all.deb
apt update
apt install zabbix-server-pgsql zabbix-frontend-php php7.3-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent

apt install -y postgresql postgresql-contrib
systemctl enable --now postgresql@11-main

sudo -u postgres createuser --pwprompt zabbix
sudo -u postgres createdb -O zabbix -E Unicode -T template0 zabbix

zcat /usr/share/doc/zabbix-sql-scripts/postgresql/create.sql.gz | sudo -u zabbix psql zabbix

echo "DBPassword=password" >> /etc/zabbix/zabbix_server.conf
echo "php_value date.timezone America/Sao_Paulo" >> /etc/zabbix/nginx.conf

systemctl restart zabbix-server zabbix-agent nginx php7.3-fpm
systemctl enable zabbix-server zabbix-agent nginx php7.3-fpm
