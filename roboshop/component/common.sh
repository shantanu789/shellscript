#!/usr/bin/env bash

Status_check(){
  if [ $1 -eq 0 ]; then
    echo -e "[ \e[42;1mSuccess\e[0m ]"
  else
    echo -e "[ \e[41;1mFailure\e[0m ]"
    echo -e "\e[33mPlease refer log - /tmp/roboshop.log\e[0m"
    exit 2
  fi
}

Print(){
  echo -e "\n\e[36m-------------$1-------------\e[0m\n" &>>$LOG
  echo -n -e "$1 - \t\t" ##Tab spaces added just for fancy output
}

if [ $UID -ne 0 ]; then
  echo -e "\n\e[31;1m You should execute this script as a root user\e[0m\n"
  exit 1
fi

LOG=/tmp/roboshop.log
rm -f $LOG

ADD_APP_USER(){
  Print "Adding Roboshop user\t\t\t\t"
  id roboshop &>>$LOG
  if [ $? -eq 0 ]; then
    echo -e "\e[33mSkipping adding user\e[0m" &>>$LOG
  else
    useradd roboshop &>>$LOG
  fi
  Status_check $?
}

DOWNLOAD_ARCHIVES(){
  Print "Downloading ${COMPONENT} content\t\t\t"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>$LOG
  Status_check $?

  Print "Extracting ${COMPONENT}\t\t\t\t"
  cd /home/roboshop
  rm -rf ${COMPONENT} && unzip -o /tmp/${COMPONENT}.zip &>>$LOG && mv ${COMPONENT}-main ${COMPONENT}
  Status_check $?
}

SETUP_SYSTEMD_SERVICE(){
  Print "Update Systemd service\t\t\t\t"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
  Status_check $?

  Print "Setup systemd.service\t\t\t\t"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>$LOG && systemctl daemon-reload &>>$LOG && systemctl restart ${COMPONENT} &>>$LOG && systemctl enable ${COMPONENT} &>>$LOG
  Status_check $?
}

NODEJS(){
  Print "Installing NodeJs\t\t\t\t"
  yum install nodejs make gcc-c++ -y &>>$LOG
  Status_check $?
  # Let's now set up the catalogue application.
  #
  # As part of operating system standards, we run all the applications and databases as a normal user but not with root user.
  #
  # So to run the catalogue service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use roboshop as the username to run the service.

  ADD_APP_USER

  DOWNLOAD_ARCHIVES

  # Print "Extracting ${COMPONENT}\t\t\t\t" #It will go to DOWNLOAD_ARCHIVES function
  # cd /home/roboshop
  # rm -rf ${COMPONENT} && unzip -o /tmp/${COMPONENT}.zip &>>$LOG && mv ${COMPONENT}-main ${COMPONENT}

      # if [ -e "/home/roboshop/catalogue" ]; then
      #   echo -e "\e[33mZip file Previous Extract present,removing \e[0m" &>>$LOG
      #   rm -rf catalogue
      #   unzip /tmp/catalogue.zip &>>$LOG
      # fi
      # unzip -o /tmp/catalogue.zip &>>$LOG
      # mv catalogue-main catalogue

  # Status_check $?

  # Print "Rename Catalogue main Dir\t\t\t"
  # if [ -d "/home/roboshop/catalogue" ]; then
  #   echo -e "\e[33mSkipping, Directory Exists" &>>$LOG
  # else
  # mv -f catalogue-main catalogue
  # fi
  # Status_check $?

  Print "Installing npm and NodeJs dependencies\t\t"
  cd /home/roboshop/${COMPONENT} && npm install --unsafe-perm=true &>>$LOG
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

  SETUP_SYSTEMD_SERVICE

  # Print "Enabling catalogue service\t\t\t"
  # systemctl enable catalogue
  # Status_check $?
}

JAVA(){
  Print "Installing MAVEN\t\t\t\t"
  yum install maven -y &>>$LOG
  Status_check $?

  ADD_APP_USER
  DOWNLOAD_ARCHIVES

  Print "Making Shipping package and Rename\t\t"
  cd /home/roboshop/shipping && mvn clean package &>>$LOG && mv target/shipping-1.0.jar shipping.jar &>>$LOG
  Status_check $?

  chown -R roboshop:roboshop /home/roboshop/

  SETUP_SYSTEMD_SERVICE
}
