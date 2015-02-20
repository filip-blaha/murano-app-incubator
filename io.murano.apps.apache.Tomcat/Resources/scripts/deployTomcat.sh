#!/bin/bash

platform=`python -mplatform`

if [[ $platform == *"Ubuntu"* ]]
then
  echo "Ubuntu ...";
  sudo apt-get update
  sudo apt-get -y -q install tomcat7
else
  echo "Other linux...";
  sudo yum -y update
  sudo yum -y install java-1.7.0-openjdk
  cd /tmp
  wget https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz
  tar xzf apache-tomcat-7.0.57.tar.gz
  sudo mv apache-tomcat-7.0.57 /usr/share/tomcat
  sudo /usr/share/tomcat/bin/startup.sh
fi

sudo iptables -I INPUT 1 -p tcp -m tcp --dport 8080 -j ACCEPT -m comment --comment "by murano, Tomcat"
