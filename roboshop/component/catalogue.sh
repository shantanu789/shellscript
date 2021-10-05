#!/usr/bin/env bash

source component/common.sh

Print "Installing NodeJs"
yum install nodejs make gcc-c++ -y &>>$LOG
Status_check $?
# Let's now set up the catalogue application.
#
# As part of operating system standards, we run all the applications and databases as a normal user but not with root user.
#
# So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use roboshop as the username to run the service.
Print "Adding Roboshop user"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
  echo -e "\e[33mSkipping adding user\e[0m" &>>$LOG
else
  useradd roboshop &>>$LOG
fi
Status_check $?

Print "Downloading Catalogue zip"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
Status_check $?

Print "Extracting Catalogue zip"
cd /home/roboshop
unzip /tmp/catalogue.zip &>>$LOG
Status_check $?

Print "Rename Catalogue main Dir"
if [[ -d "/home/roboshop/catalogue" || -d "/home/roboshop/catalogue-main" ]]; then
  echo -e "\e[33mSkipping File Exists" &>>$LOG
else
  mv catalogue-main catalogue
fi
Status_check $?

cd /home/roboshop/catalogue

Print "Installing npm"
npm install --unsafe-perm=true &>>$LOG
Status_check $?
# NOTE: We need to update the IP address of MONGODB Server in systemd.service file
# Now, lets set up the service with systemctl.

Print "Catalogue Daemon and service Start"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue &>>$LOG
Status_check $?

Print "Enabling catalogue service"
systemctl enable catalogue
Status_check $?
