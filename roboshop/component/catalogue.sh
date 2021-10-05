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
useradd roboshop &>>$LOG
Status_check $?

Print "Downloading Catalogue zip"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG

Print "Extracting Catalogue zip"
cd /home/roboshop
unzip /tmp/catalogue.zip &>>$LOG
mv catalogue-main catalogue
Status_check $?

cd /home/roboshop/catalogue

Print "Installing npm"
npm install &>>$LOG
Status_check $?
# NOTE: We need to update the IP address of MONGODB Server in systemd.service file
# Now, lets set up the service with systemctl.

mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl start catalogue &>>$LOG
Status_check $?
systemctl enable catalogue
Status_check $?
