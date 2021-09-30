#!/usr/bin/env bash
#Declaring variable
a=10
b="20"

echo $a
echo ${b}

c=$((a+b))
echo $c

x=(100 200 300 abc)
echo ${x[2]}
echo ${x[3]}

declare -A bashArray=([key]=value [class]=devops [trainer]=raghu)
echo ${bashArray[key]}
echo ${bashArray[class]}; echo ${bashArray[trainer]}
