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




echo '启动hbase'
sh /usr/local/hbase-1.2.11/bin/start-hbase.sh

echo 'export PATH=$HADOOP_PREFIX/bin:$PATH' >> /etc/profile

echo 'export PATH=/usr/local/hbase-1.2.11/bin:$PATH' >> /etc/profile

source /etc/profile








if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

