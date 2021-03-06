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


# Config
ENV JAVA_LINK   http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.rpm
ENV MAVEN_LINK  http://mirrors.gigenet.com/apache/maven/maven-3/3.2.5/binaries/apache-maven-3.2.5-bin.tar.gz
ENV TOMCAT_LINK http://mirrors.advancedhosters.com/apache/tomcat/tomcat-8/v8.0.18/bin/apache-tomcat-8.0.18.tar.gz


# Setup Application Home
RUN mkdir    /app;
ENV APP_HOME /app

RUN yum update  -y; \
    yum install -y wget tar; \
    yum clean   -y all;

# Install JDK
RUN cd /tmp; \
    curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O $JAVA_LINK; \
    rpm -Uvh jdk-*-linux-x64.rpm; \
    rm jdk-*-linux-x64.rpm;
ENV JAVA_HOME /usr/java/default

# Install Maven
RUN cd /tmp; \
    wget -O maven.tar.gz $MAVEN_LINK; \
    cd /opt; \
    mkdir maven; \
    tar xzf /tmp/maven.tar.gz --strip-components=1 -C maven; \
    ln -s /opt/maven/bin/mvn /usr/local/bin; \
    rm -rf /tmp/*;
ENV M2_HOME /opt/maven

# Install Tomcat
RUN wget -O /tmp/tomcat-8.tar.gz $TOMCAT_LINK; \
    cd /usr/local; \
    mkdir tomcat-8; \
    tar xzf /tmp/tomcat-8.tar.gz --strip-components=1 -C tomcat-8; \
    rm -rf tomcat-8/webapps/*; \
    ln -s /usr/local/tomcat-8 /usr/local/tomcat; \
    rm -rf /tmp/*;
ENV CATALINA_HOME /usr/local/tomcat
ADD ./docker/tomcat-conf $CATALINA_HOME/conf

# Install Nginx
ADD ./docker/nginx.repo /etc/yum/repos.d/nginx.repo
RUN yum -y --noplugins --verbose install nginx; \
    yum clean -y all; \
    rm -f /etc/nginx/conf.d/default.conf;
ADD ./docker/nginx-conf /etc/nginx/conf.d

# Install MongoDB


# Install Start Script
ADD ./docker/startup.sh /bin/
RUN chmod +x /bin/startup.sh;

# Install App
ADD ./ /tmp/src
RUN cd /tmp/src; \
    mvn -Dmaven.test.skip=true package; \
	rm -rf $APP_HOME/*; \
	cp target/*.war $APP_HOME/ROOT.war; \
	cd /tmp; \
	rm -rf *;

# Forward HTTP ports
EXPOSE 80 8080

# Finish
