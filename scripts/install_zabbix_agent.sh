#!/bin/bash
# install the zabbix agent 2.0.3

# download the zabbix agent
wget http://www.kodai74.net/packages/zabbix/zabbix-2.0/rhel/6/x86_64/zabbix-2.0.3-1.el6.x86_64.rpm
wget http://www.kodai74.net/packages/zabbix/zabbix-2.0/rhel/6/x86_64/zabbix-agent-2.0.3-1.el6.x86_64.rpm

if [ `ls zabbix-2.0.3-1.el6.x86_64.rpm zabbix-agent-2.0.3-1.el6.x86_64.rpm | wc -l` -ne 2 ]; then
	echo "download error."
	exit;
else
	echo "download zabbix agent succesfully."
fi

# install the zabbix agent
rpm -ivh zabbix-2.0.3-1.el6.x86_64.rpm zabbix-agent-2.0.3-1.el6.x86_64.rpm 

installed=`rpm -qa "zabbix*" | wc -l`
if [ $installed -ne 2 ]; then
        echo "zabbix agent has not been installed."
        exit;
else
        echo "zabbix agent has been installed."
fi


# modify the configuration

if [ -d /etc/zabbix/zabbix_agentd.d/ ] && [ -f /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf ];then
        echo "dir exists."
        mv /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf.bak
else
        echo "dir not exists."
        exit;
fi

ip=`/sbin/ifconfig eth0 | grep "inet addr" | cut -f 2 -d ':' | cut -f 1 -d ' '`

a='# EnableRemoteCommands=0'
b='Server=127.0.0.1'
c='Hostname=Zabbix server'

a1=' EnableRemoteCommands=1'
b1='Server=monitor.abc.com'
c1="Hostname=$ip"

conf_file=/etc/zabbix/zabbix_agentd.conf
if [ -f $conf_file ];then
	sed -i "s/$a/$a1/g" $conf_file
	sed -i "s/$b/$b1/g" $conf_file
	sed -i "s/$c/$c1/g" $conf_file
else
	echo "$conf_file not exists."
	exit;
fi

# start the zabbix-agent
/etc/rc.d/init.d/zabbix-agent start
