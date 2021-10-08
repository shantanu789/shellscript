#!/usr/bin/env bash

Status_check(){
  if [ $1 -eq 0 ]; then
    echo -e "[ \e[42;1mSuccess\e[0m ]"
  else
    echo -e "[ \e[41;1mFailure\e[0m ]"
    exit 2
  fi
}

Print(){
  echo -e "\n\t\t\e[36m------------- $1 -------------\e[0m\n" &>>$LOG
  echo -n -e "$1 - \t\t" ##Tab spaces added just for fancy output
}

if [ $UID -ne 0 ]; then
  echo -e "\n\e[31;1m You should execute this script as a root user\e[0m\n"
  exit 1
fi

LOG=/tmp/roboshop.log
rm -f $LOG
