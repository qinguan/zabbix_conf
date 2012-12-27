#!/bin/bash

service iptables stop
ps -ef | grep zabbix_server | grep -v grep | awk '{print $2}' | xargs kill 
ps -ef | grep zabbix_agentd | grep -v grep | awk '{print $2}' | xargs kill 

service mysqld restart
/usr/local/sbin/zabbix_server
/usr/local/sbin/zabbix_agentd
/etc/rc.d/init.d/httpd restart
