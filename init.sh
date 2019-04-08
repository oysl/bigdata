#!/bin/bash

#系统初始化

####创建普通用户帐号，并授权使用sudo -i切换到root

LOG=/tmp/system_init.log


###设置DNS
modify_dnsserver(){
	echo "nameserver 192.168.10.1" >> /etc/resolv.conf
	echo "nameserver 114.114.114.114" >> /etc/resolv.conf
}

####安装常用命令
install_command()
{
	yum install -y net-tools vim lrzsz wget nfs-utils socat gcc bc gcc-c++ make
	yum -y install java-1.8.0-openjdk*
}

####修改系统显示颜色
color_modify()
{
	echo "ulimit -SHn 65535" >> /root/.bashrc
	echo "ulimit -u 65535" >> /root/.bashrc
	echo "PS1='\${debian_chroot:+(\$debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '" >> /root/.bashrc
}

####关闭防火墙

iptables_stop()
{
	systemctl stop firewalld.service
	systemctl disable firewalld.service
	systemctl stop postfix.service
  	systemctl disable postfix.service
}

####关闭SELinux
selinux_stop()
{
  	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
  	sed -i 's/SELINUXTYPE=targeted/#SELINUXTYPE=targeted/g' /etc/selinux/config
}

####内核优化
kernel_optimize()
{

	echo -e "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
	echo -e "kernel.core_uses_pid = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
	echo -e "kernel.msgmnb = 65536" >> /etc/sysctl.conf
	echo -e "kernel.msgmax = 65536" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_max_tw_buckets = 5000" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_sack = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_window_scaling = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_rmem = 4096 87380 4194304" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_wmem = 4096 16384 4194304" >> /etc/sysctl.conf
	echo -e "net.core.netdev_max_backlog = 32768" >> /etc/sysctl.conf
	echo -e "net.core.somaxconn = 65535" >> /etc/sysctl.conf
	echo -e "net.core.wmem_default = 8388608" >> /etc/sysctl.conf
	echo -e "net.core.rmem_default = 8388608" >> /etc/sysctl.conf
	echo -e "net.core.rmem_max = 16777216" >> /etc/sysctl.conf
	echo -e "net.core.wmem_max = 16777216" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_max_orphans = 3276800" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_max_syn_backlog = 8192" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_timestamps = 0" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_synack_retries = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_syn_retries = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_fin_timeout = 10" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_mem = 94500000 915000000 927000000" >> /etc/sysctl.conf
	echo -e "net.ipv4.tcp_keepalive_time = 1500" >> /etc/sysctl.conf
	echo -e "net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf

	modprobe bridge
	sysctl -p >> $LOG
}

####同步系统时间
ntp_time()
{
  	echo "安装同步系统时间"
  	yum install chrony -y
  	sed -i 's/server*/#server/g' /etc/chrony.conf
  	sed -i 's/#server 2.centos.pool.ntp.org iburst/server  time1.aliyun.com  iburst/g' /etc/chrony.conf
  	sed -i 's/#server 3.centos.pool.ntp.org iburst/server  ntp1.aliyun.com  iburst/g' /etc/chrony.conf
 	 systemctl restart chronyd.service
  	timedatectl | grep "NTP synchronized"
}


####修改系统打开文件的限制
modify_limits()
{
    	if ! grep -q ^* /etc/security/limits.conf
		then
	  	echo -e "* soft nproc unlimited" >> /etc/security/limits.conf
		echo -e "* hard nproc unlimited" >> /etc/security/limits.conf
		echo -e "* soft nofile 65535" >> /etc/security/limits.conf
		echo -e "* hard nofile 65535" >> /etc/security/limits.conf
	fi
	if ! grep -q pam_limits.so /etc/pam.d/login
	then
	echo "session    required    pam_limits.so" >> /etc/pam.d/login
	fi
}

####删除不必要的用户和组
delete_users_groups()
{
	userdel adm > /dev/null
	userdel lp > /dev/null
	userdel sync > /dev/null
	userdel shutdown > /dev/null
	userdel halt > /dev/null
	userdel operator > /dev/null
	groupdel adm > /dev/null
	groupdel lp > /dev/null
}

####关闭不必要的服务
close_services()
{
	systemctl stop auditd > /dev/null
	systemctl disable auditd > /dev/null
	systemctl stop postfix > /dev/null
	systemctl disable postfix > /dev/null
	systemctl stop messagebus > /dev/null
	systemctl disable messagebus > /dev/null
}

###关闭IPV6服务
stop_ipv6()
{
  echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
	echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
	systemctl disable ip6tables
	sysctl -p
}

###关闭SSH中不需要的服务
ssh_config()
{
  	sed -i 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
  	sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' /etc/ssh/sshd_config
}

###设置区域时间
modify_datetime()
{
	cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
}

###修改主机名
modify_hostname(){
	lastip=`ifconfig ens3 | grep inet | grep -v inet6 | awk '{print $2}' | awk -F. '{print $NF}'`
	hostnamectl set-hostname mwcx-server-$lastip

}


###升级系统内核
update ()
{
	#1，离线安装方式:
	#已下载好的内核rpm包安装
	#unzip kernel-4.19.12.zip
	#cd kernel-4.19.12/kernel-4.19.12
	#yum install -y kernel-ml-4.19.12-1.el7.elrepo.x86_64.rpm kernel-ml-devel-4.19.12-1.el7.elrepo.x86_64.rpm kernel-ml-doc-4.19.12-1.el7.elrepo.noarch.rpm perf-4.19.12-1.el7.elrepo.x86_64.rpm python-perf-4.19.12-1.el7.elrepo.x86_64.rpm
	#2,下载安装方式:
	rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
	rpm -Uvh http://elrepo.reloumirrors.net/kernel/el7/x86_64/RPMS/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
	yum --enablerepo=elrepo-kernel install kernel-lt-devel kernel-lt -y
  	awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
	grub2-set-default 0
}

###安装docker
install_docker ()
{
  	yum install -y yum-utils device-mapper-persistent-data lvm2 yum-plugin-ovl
  	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
  	#wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.06.1.ce-3.el7.x86_64.rpm
  	yum localinstall -y docker-ce-18.06.1.ce-3.el7.x86_64.rpm && yum install -y docker-ce-18.06.1.ce
  	systemctl enable docker && systemctl start docker && systemctl status docker

}



###定义判断变量
kstatus=`grep tcp_synack_retries /etc/sysctl.conf | wc -l`


#echo "modify dnsserver"
#modify_dnsserver
echo "install command..."
install_command
echo "color modify..."
color_modify
echo "Stop iptables..."
iptables_stop
echo "Stop Selinux..."
selinux_stop
echo "modify datetime"
modify_datetime
echo "optimize kernel..."
if [ $kstatus -gt 0 ]; then
    echo "kernel yes"
else
    kernel_optimize
fi
echo "ntpdate Time..."
ntp_time
echo "modify limits..."
modify_limits
echo "delete users and groups..."
delete_users_groups
echo "close services..."
close_services
echo "modify hostname"
modify_hostname
echo "stop ipv6"
stop_ipv6
echo "ssh config"
ssh_config
echo "update"
update
echo "install docker"
install_docker

