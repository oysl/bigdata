FROM harbor.uinar.cn/mwcx-tools/centos7-jdk-spring:v2
MAINTAINER project Images

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8





RUN yum install -y openssh-server


RUN echo 'Port 22 ' >> /etc/ssh/sshd_config
RUN echo 'RSAAuthentication yes ' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes ' >> /etc/ssh/sshd_config
RUN echo 'AuthorizedKeysFile .ssh/authorized_keys ' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes ' >> /etc/ssh/sshd_config

ADD hbase-1.2.11-bin.tar.gz /usr/local/
ADD spark-2.3.3-bin-hadoop2.7.tgz /usr/local/


COPY init.sh /
RUN chmod +x /init.sh
          
EXPOSE 50070
EXPOSE 22 
         
#ENTRYPOINT ["/init.sh"]
