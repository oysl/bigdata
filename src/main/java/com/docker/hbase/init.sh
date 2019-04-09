#!/bin/bash

#sh /etc/bootstrap.sh




: ${HADOOP_PREFIX:=/usr/local/hadoop}

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml


service sshd start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi

#加载 jdk8,这个本来想写Dockfile里面,但是一直报错...
#yum -y remove jdk-1.7.0_71-fcs.x86_64
yum -y install java-1.8.0-openjdk*

echo '启动hbase'
sh /usr/local/hbase-1.2.11/bin/start-hbase.sh
echo 'export PATH=$HADOOP_PREFIX/bin:$PATH' >> /etc/profile
echo 'export JAVA_HOME=/usr' >> /etc/profile

echo 'export PATH=/usr/local/hbase-1.2.11/bin:$PATH' >> /etc/profile

source /etc/profile








if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

