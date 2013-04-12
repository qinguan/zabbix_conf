#!/bin/bash
# install the zabbix proxy 2.0.3

echo "**********************Download proxy rpm package***********************"
wget http://repo.zabbixzone.com/centos/6Server/x86_64/zabbix-proxy-2.0.3-1.el6.x86_64.rpm
wget http://repo.zabbixzone.com/centos/6Server/x86_64/zabbix-proxy-sqlite3-2.0.3-1.el6.x86_64.rpm

echo "*****************************Install proxy*****************************************"
yum install unixODBC.x86_64 OpenIPMI-libs.x86_64 net-snmp.x86_64 fping.x86_64
if [ $? -ne 0 ]; then
	 echo "check install: nixODBC.x86_64 OpenIPMI-libs.x86_64 net-snmp.x86_64 fping.x86_64"
	 exit
fi
rpm -ivh zabbix-proxy-2.0.3-1.el6.x86_64.rpm zabbix-proxy-sqlite3-2.0.3-1.el6.x86_64.rpm

echo "******************Configure database,default use sqlite3*******************"
mkdir -p /var/lib/sqlite
chmod -R 777  /var/lib/sqlite
#get zabbix_sqlite3_schema.sql 
#from zabbix source package: zabbix/database/sqlite3/schema.sql
if [ -f schema.sql ]; then
	 sqlite3 /var/lib/sqlite/zabbix.db < schema.sql
else
	 echo "missing zabbix_sqlite3_schema.sql file."
	 exit
fi

echo "*****************************Configure proxy*******************************"
conf_file=/etc/zabbix/zabbix_proxy.conf
a='Server=127.0.0.1'
b='Hostname=Zabbix proxy'
c='DBName=zabbix'

a1='Server=Zabbix Server' #Zabbix Server should be modified according the proxy machine's ip
b1='Hostname='`hostname`
c1='DBName=/var/lib/sqlite/zabbix.db'

conf_file=/etc/zabbix/zabbix_proxy.conf
if [ -f $conf_file ];then
	sed -i "s/$a/$a1/g" $conf_file
	sed -i "s/$b/$b1/g" $conf_file
	sed -i "s/$c/$c1/g" $conf_file
else
	echo "missing $conf_file file."
	exit;
fi

chkconfig zabbix-proxy on

echo "*****************************Start proxy*************************************"
/usr/sbin/zabbix_proxy