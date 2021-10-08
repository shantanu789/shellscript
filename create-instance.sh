#!/usr/bin/env bash

LID="lt-048c498b2ab4c35c3"
LVER=1
InstanceName="$1"

declare -A INSTANCE_STATE_CODE='([16]="running" [32]="shutting-down" [48]="terminated" [64]="stopping" [80]="stopped")'

if [ -z "$InstanceName" ]; then
  echo -e "\n\e[31mInstance Name or Input is missing\e[0m\n"
  exit 1
fi
# Getting instance state - running, stopped, terminated
# instance-state-code - The code for the instance state, as a 16-bit unsigned integer. The high byte is used for internal purposes and should be ignored. The low byte is set based on the state represented. The valid values are 0 (pending), 16 (running), 32 (shutting-down), 48 (terminated), 64 (stopping), and 80 (stopped).

InstanceState=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$InstanceName" | jq .Reservations[].Instances[].State.Code | sed -e 's/"//g')

echo -e "\t\t\e[32m-----------------Checking Existance of the same Instance-----------------\e[0m\n"

if [[ "$InstanceState" == 16 || "$InstanceState" == 32 || "$InstanceState" == 48 || "$InstanceState" == 64 || "$InstanceState" == 80 ]]; then
  echo -e "\n\e[33m $InstanceName is exists and ${INSTANCE_STATE_CODE[$InstanceState]}\n"
  exit 1
else
  echo -e "\n\e[32mCheck Done.No Instance found...\e[0m\n"
fi

echo -e "\t\t\e[32m-----------------Launching Instance-----------------\e[0m\n"

IP=$(aws ec2 --launch-template 'LaunchTemplateId=$LID,Version=$LVER' --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$InstanceName}]" "ResourceType=instance,Tags=[{Key=Name,Value=$InstanceName}]" | jq .Instances[].PrivateIpAddress | sed -e 's/"//g')

sed -e "s/INSTANCE_NAME/$InstanceName/" -e "s/INSTANCE_IP/$IP/" record.json >/tmp/record.json

aws route53 change-resource-record-sets --hosted-zone-id Z04674552UCKELJX08IB3 --change-batch file:///tmp/record.json | jq
