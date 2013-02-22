#!/bin/bash

service iptables stop
# if not disable selinux, the frontend will show message: zabbix server is not runnning
setenforce 0
ps -ef | grep zabbix_server | grep -v grep | awk '{print $2}' | xargs kill 
ps -ef | grep zabbix_agentd | grep -v grep | awk '{print $2}' | xargs kill 

service mysqld restart
/usr/local/sbin/zabbix_server
/usr/local/sbin/zabbix_agentd
/etc/rc.d/init.d/httpd restart
