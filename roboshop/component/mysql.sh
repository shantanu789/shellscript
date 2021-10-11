#!/usr/bin/env bash

source component/common.sh

Print "Installing MySQL Repository\t\t"
echo '[mysql57-community]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0' > /etc/yum.repos.d/mysql.repo
Status_check $?

Print "Install MySQL\t\t\t\t"
yum remove mariadb-libs -y &>>$LOG && yum install mysql-community-server -y &>>$LOG
Status_check $?

Print "Start MySQL\t\t\t\t"
systemctl enable mysqld &>>$LOG && systemctl restart mysqld &>>$LOG
Status_check $?

# Now a default root password will be generated and given in the log file.
DEFAULT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{printf $NF}')

# Next, We need to change the default root password in order to start using the database service.
# mysql_secure_installation --> This will require manuall input. we need to eliminate this step

echo 'ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';' > reset.mysql

# You can check the new password working or not using the following command.

mysql  --connect-expired-password -u root -p"$DEFAULT_PASSWORD" < reset.mysql

exit

# Run the following SQL commands to remove the password policy.
> uninstall plugin validate_password;
Setup Needed for Application.
As per the architecture diagram, MySQL is needed by

Shipping Service
So we need to load that schema into the database, So those applications will detect them and run accordingly.

To download schema, Use the following command

# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
Load the schema for Services.

# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql
