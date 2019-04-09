#!/bin/bash





echo 'export SPRAK_HOME=/usr/local/spark-2.3.3-bin-hadoop2.7'>> /etc/profile

echo 'export PATH=$SPRAK_HOME/bin:$HADOOP_PREFIX/bin:$PATH' >> /etc/profile

echo 'export PATH=/usr/local/hbase-1.2.11/bin:$PATH' >> /etc/profile
echo 'export JAVA_HOME=/usr/lib/jdk1.8.0_201' >> /etc/profile
echo 'export PATH=${JAVA_HOME}/bin:${PATH}' >> /etc/profile
source /etc/profile




echo '启动hbase'
sh /usr/local/hbase-1.2.11/bin/start-hbase.sh

#echo '启动spark' 
# local[1] 1 是线程数
#sh $SPRAK_HOME/bin/spark-shell local[1]



if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

