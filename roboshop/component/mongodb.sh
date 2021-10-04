#!/usr/bin/env bash

Status_check(){
  if [ $? -eq 0 ]; then
    echo -e "\e[92;1mSuccess\e[0m"
  else
    echo -e "\e[91;1mFailure\e[0m"
    exit 2
  fi
}

echo "Set up MongoDB repo"

echo '[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc' >/etc/yum.repos.d/mongodb.repo
Status_check $?

echo "Installing MongoDB"
yum install -y ongodb-org &>>/tmp/log
Status_check $?
#systemctl enable mongod
#systemctl start mongod

#Update List IP address from 127.0.0.1 to 0.0.0.0 in config file '/etc/mongod.conf'
echo "Modified /etc/mongod.conf"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
Status_check $?

echo "Restart MongoDB"
systemctl restart mongod
Status_check $?

echo "Download the RoboShop schema and load it"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
Status_check $?

echo "Downloaded schema unzipped"
cd /tmp
unzip -o mongodb.zip &>>/tmp/log
Status_check $?

echo "Downloaded schema loaded"
cd mongodb-main
mongo < catalogue.js &>>/tmp/log
mongo < users.js &>>/tmp/log
Status_check $?

exit 0
