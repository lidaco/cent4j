FROM centos

MAINTAINER Paolo Antinori <paolo.antinori@gmail.com>

RUN yum install -y wget tar
RUN curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.rpm \
 && rpm -Uvh jdk-*-linux-x64.rpm \
 && rm jdk-*-linux-x64.rpm
ENV JAVA_HOME /usr/java/default

RUN cd /tmp; wget http://www.eu.apache.org/dist/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
RUN cd /opt; tar -xzf /tmp/apache-maven-3.1.1-bin.tar.gz; mv apache-maven-3.1.1 maven; ln -s /opt/maven/bin/mvn /usr/local/bin; rm -rf /tmp/*
ENV M2_HOME /opt/maven
