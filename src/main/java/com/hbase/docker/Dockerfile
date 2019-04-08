FROM sequenceiq/hadoop-docker
MAINTAINER project Images 

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8



RUN yum  clean  all && yum -y install lrzsz

ADD hbase-1.2.11-bin.tar.gz /usr/local/



COPY init.sh /
RUN chmod +x /init.sh

EXPOSE 50070
EXPOSE 22

#ENTRYPOINT ["/init.sh"]
