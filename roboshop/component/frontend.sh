#!/bin/bash

source component/common.sh

Print "Installing NGINX\t\t\t\t"
yum install nginx -y &>>$LOG #&& systemctl enable nginx &>>$LOG && systemctl start nginx &>>$LOG
Status_check $?

Print "Downloading HTDOCS\t\t\t\t"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG
Status_check $?

Print "Setting up FrontEnd Default configuration\t"
#DIRECTORY_NAME='/usr/share/nginx/html'
#rm -rf "$DIRECTORY_NAME/*"
#if [[ -d "$DIRECTORY_NAME" ]]; then
cd /usr/share/nginx/html && rm -rf ./* && unzip -o /tmp/frontend.zip &>>$LOG && mv frontend-main/* . &>>$LOG && mv static/* . &>>$LOG && rm -rf frontend-main static README.md &>>$LOG && mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG
# else
#   echo -e "\e[36mSkipping...\e[0m \n"
# fi
Status_check $?

sed -i -e '/catalogue/ s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf &>>$LOG

Print "Restarting NGINX\t\t\t\t"
systemctl restart nginx &>>$LOG && systemctl enable nginx &>>$LOG
Status_check $?
