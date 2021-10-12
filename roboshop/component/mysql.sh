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
Print "Reset Default password\t\t\t"
echo 'show databases' | mysql -u root --password="RoboShop@1" &>>$LOG
if [ $? -eq 0 ]; then
  echo "Root password already set" &>>$LOG
else
  echo "ALTER USER 'root'@'localhost' IDENTIFIED BY 'RoboShop@1';" > reset.mysql
  mysql --connect-expired-password -u root --password="$DEFAULT_PASSWORD" < reset.mysql &>>$LOG
fi
Status_check $?

Print "Uninstall Validate Password Plugin\t" # Run the following SQL commands to remove the password policy.

# echo "SELECT PLUGIN_NAME, PLUGIN_STATUS
#        FROM INFORMATION_SCHEMA.PLUGINS
#        WHERE PLUGIN_NAME LIKE 'validate%';" >query.plugin
# mysql -u root -p"RoboShop@1" <query.plugin &>>$LOG
echo 'show plugins;' | mysql -u root --password="RoboShop@1" 2>>$LOG | grep -i 'validate_password' &>>$LOG
if [ $? -eq 0 ]; then
  echo "uninstall plugin validate_password;" > uninstall_validate.password
  mysql -u root --password="RoboShop@1" <uninstall_validate.password &>>$LOG
else
  echo "Already Uninstalled validate_password Plugin" &>>$LOG
fi
Status_check $?

# Setup Needed for Application.
# As per the architecture diagram, MySQL is needed by
#
# Shipping Service
# So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
# To download schema, Use the following command
Print "Downloading MySQL archive\t\t"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG
Status_check $?

Print "Load the schema for Services\t\t"
cd /tmp && unzip -o mysql.zip &>>$LOG && cd mysql-main &>>$LOG
mysql -u root --password=RoboShop@1 <shipping.sql &>>$LOG
Status_check $?
