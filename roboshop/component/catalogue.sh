#!/usr/bin/env bash

source component/common.sh

Print "Installing NodeJs\t\t\t\t"
yum install nodejs make gcc-c++ -y &>>$LOG
Status_check $?
# Let's now set up the catalogue application.
#
# As part of operating system standards, we run all the applications and databases as a normal user but not with root user.
#
# So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use roboshop as the username to run the service.
Print "Adding Roboshop user\t\t\t\t"
id roboshop &>>$LOG
if [ $? -eq 0 ]; then
  echo -e "\e[33mSkipping adding user\e[0m" &>>$LOG
else
  useradd roboshop &>>$LOG
fi
Status_check $?

Print "Downloading Catalogue content\t\t\t"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG
Status_check $?

Print "Extracting Catalogue\t\t\t\t"
cd /home/roboshop
rm -rf catalogue && unzip -o /tmp/catalogue.zip &>>$LOG && mv catalogue-main catalogue
# if [ -e "/home/roboshop/catalogue" ]; then
#   echo -e "\e[33mZip file Previous Extract present,removing \e[0m" &>>$LOG
#   rm -rf catalogue
#   unzip /tmp/catalogue.zip &>>$LOG
# fi
# unzip -o /tmp/catalogue.zip &>>$LOG
# mv catalogue-main catalogue
Status_check $?

# Print "Rename Catalogue main Dir\t\t\t"
# if [ -d "/home/roboshop/catalogue" ]; then
#   echo -e "\e[33mSkipping, Directory Exists" &>>$LOG
# else
# mv -f catalogue-main catalogue
# fi
# Status_check $?

Print "Installing npm and NodeJs dependencies\t\t"
cd /home/roboshop/catalogue && npm install --unsafe-perm=true &>>$LOG
Status_check $?
# NOTE: We need to update the IP address of MONGODB Server in systemd.service file
# Now, lets set up the service with systemctl.
chown -R roboshop:roboshop /home/roboshop/

# Print "Catalogue Daemon and service Start\t\t"
# if [ -e "/etc/systemd/system/catalogue.service" ]; then
#   echo -e "\e[33mCatalogue service file Exists by previous run, skipping moving\e[0m" &>>$LOG
# else
# Print "Setup systemd.service\t"
# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG
# Status_check $?
# fi
# Print "Catalogue Daemon reload and service Start\t"
Print "Update Systemd service\t\t\t\t"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/catalogue/systemd.service
Status_check $?

Print "Setup systemd.service\t\t\t\t"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG
systemctl daemon-reload &>>$LOG && systemctl restart catalogue &>>$LOG && systemctl enable catalogue &>>$LOG
Status_check $?
# Print "Enabling catalogue service\t\t\t"
# systemctl enable catalogue
# Status_check $?
