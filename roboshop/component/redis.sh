#!/usr/bin/env bash

source component/common.sh

Print "Installing Redis dependencies\t\t\t"
yum install epel-release yum-utils -y &>>$LOG
Status_check $?

Print "Installing Remi repo and Enabling\t\t"
yum list installed | grep remi-release.noarch &>>$LOG
if [ $? -ne 0 ]; then
  yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y &>>$LOG && yum-config-manager --enable remi &>>$LOG
else
  echo -e "\e[33mRemi repo already installed\e[0m" &>>$LOG
fi
Status_check $?

Print "Installing Redis Now\t\t\t\t"
yum install redis -y &>>$LOG
Status_check $?

# Update the BindIP from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf
Print "Updating the BindIP in config file /etc/redis.conf" #& /etc/redis/redis.conf --> here not needed
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf -e 's/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf &>>$LOG
Status_check $?

Print "Start Redis Database\t\t\t\t"
systemctl enable redis &>>$LOG && systemctl restart redis &>>$LOG
Status_check $?
