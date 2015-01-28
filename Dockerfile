#################################################################
#                    ##        .
#              ## ## ##       ==
#           ## ## ## ##      ===
#       /""""""""""""""""\___/ ===
#  ~~~ {~~ ~~~~ ~~~ ~~~~ ~~ ~ /  ===- ~~~
#       \______ o          __/
#         \    \        __/
#          \____\______/
#################################################################

FROM centos:7

MAINTAINER Saeed Esfandi <saeed.esfandi@gmail.com>

ENV APP_HOME /app
ENV APP_NAME name
ENV JAVA_VERSION 8u31
ENV JAVA_BUILD b13

RUN yum install -y update
RUN yum install -y wget tar

# Install JDK
RUN curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.rpm \
 && rpm -Uvh jdk-*-linux-x64.rpm \
 && rm jdk-*-linux-x64.rpm
ENV JAVA_HOME /usr/java/default

# Install Maven
RUN cd /tmp; wget http://www.eu.apache.org/dist/maven/maven-3/3.1.1/binaries/apache-maven-3.1.1-bin.tar.gz
RUN cd /opt; tar -xzf /tmp/apache-maven-3.1.1-bin.tar.gz; mv apache-maven-3.1.1 maven; ln -s /opt/maven/bin/mvn /usr/local/bin; rm -rf /tmp/*
ENV M2_HOME /opt/maven

# Install Tomcat
RUN wget -O /tmp/apache-tomcat-8.0.18.tar.gz http://mirrors.advancedhosters.com/apache/tomcat/tomcat-8/v8.0.18/bin/apache-tomcat-8.0.18.tar.gz
RUN cd /usr/local && tar xzf /tmp/apache-tomcat-8.0.18.tar.gz
RUN ln -s /usr/local/apache-tomcat-8.0.18.tar.gz /usr/local/tomcat
RUN rm /tmp/apache-tomcat-8.0.18.tar.gz

# Install Nginx
ADD ./docker/nginx.repo /etc/yum/repos.d/nginx.repo
RUN yum -y --noplugins --verbose install nginx
ADD ./docker/nginx.conf /etc/nginx/conf.d
RUN rm -f /etc/nginx/conf.d/default.conf

# Install MongoDB

# Forward HTTP ports
EXPOSE 8083 8080

# Finish


