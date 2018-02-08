#!/bin/bash

if [ ! -f /usr/lib/jvm || ! -f /etc/init.d/jenkins ]; 
then
	echo "------------- Update YUM --------------"
	echo "---------------------------------------"
	yum -y install epel-release
	yum -y update
fi

if [ ! -f /usr/lib/jvm ]; 
then
    echo "-------- PROVISIONING JAVA ------------"
	echo "---------------------------------------"
	yum -y install java-1.8.0-openjdk.x86_64
	echo 'export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk' | sudo tee -a /etc/profile
	echo 'export JRE_HOME=/usr/lib/jvm/jre' | sudo tee -a /etc/profile
	source /etc/profile
else
	echo "CHECK - Java already installed"
fi

if [ ! -f /etc/init.d/jenkins ]; 
then
	echo "-------- PROVISIONING JENKINS ------------"
	echo "------------------------------------------"
	yum -y install wget
	wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
	rpm --import http://pkg.jenkins-ci.org/redhat-stable/jenkins-ci.org.key
	yum -y install jenkins
	sudo service jenkins restart

else
	echo "CHECK - Jenkins already installed"
fi

if [ ! -f /usr/bin/node ]; 
then
	echo "---------- PROVISIONING NODE -------------"
	echo "------------------------------------------"
	yum -y install nodejs
else
	echo "CHECK - Node is already installed"
fi

sudo cat /var/lib/jenkins/secrets/initialAdminPassword