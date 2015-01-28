#!/bin/sh

# Stop Tomcat
$CATALINA_HOME/bin/shutdown.sh

# Pull latest version of app
cd $APP_HOME
git pull origin master

# Build app
mvn -Dmaven.test.skip=true package

# Copy war to Tomcat
rm -rf $CATALINA_HOME/webapps/*
cp target/$APP_NAME $CATALINA_HOME/webapps/ROOT.war

# Start Tomcat
$CATALINA_HOME/bin/startup.sh

# Stop Nginx


# Start Nginx
nginx
