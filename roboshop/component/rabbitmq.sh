#!/usr/bin/env bash

source component/common.sh

# Erlang is a dependency which is needed for RabbitMQ.
yum list installed | grep erlang &>>$LOG
Print "Installing RabbitMQ dependency - Erlang\t\t"
if [ $? -ne 0 ]; then
  yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>$LOG
else
  echo -e "\e[33mErlang - RabbitMQ dependency already installed\e[0m" &>>$LOG
fi
Status_check $?

Print "Setup YUM repositories for RabbitMQ\t\t"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG
Status_check $?

Print "Install RabbitMQ\t\t\t\t"
yum install rabbitmq-server -y &>>$LOG
Status_check $?

Print "Start RabbitMQ\t\t\t\t\t"
systemctl enable rabbitmq-server &>>$LOG && systemctl restart rabbitmq-server &>>$LOG
Status_check $?
# RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application.

Print "Create application user\t\t\t\t"
rabbitmqctl list_users | grep roboshop &>>$LOG
if [ $? -ne 0 ]; then
  rabbitmqctl add_user roboshop roboshop123 &>>$LOG && rabbitmqctl set_user_tags roboshop administrator &>>$LOG && rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG
else
  echo -e "\e[33mRoboshop user already added\e[0m" &>>$LOG
fi
Status_check $?
