#!/usr/bin/env bash

LID="lt-048c498b2ab4c35c3"
LVER=1
INSTANCE_NAME="$1"

declare -A INSTANCE_STATE_CODE='([16]="running" [32]="shutting-down" [48]="terminated" [64]="stopping" [80]="stopped")'

if [ -z "$INSTANCE_NAME" ]; then
  echo -e "\n\e[31mInstance Name or Input is missing\e[0m\n"
  exit 1
fi
# Getting instance state - running, stopped, terminated
# instance-state-code - The code for the instance state, as a 16-bit unsigned integer. The high byte is used for internal purposes and should be ignored. The low byte is set based on the state represented. The valid values are 0 (pending), 16 (running), 32 (shutting-down), 48 (terminated), 64 (stopping), and 80 (stopped).

INSTANCE_STATE=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=$INSTANCE_NAME" | jq .Reservations[].Instances[].State.Code | sed -e 's/"//g')

if [ $(INSTANCE_STATE) == '16' || $(INSTANCE_STATE) == '32' || $(INSTANCE_STATE) == '48' || $(INSTANCE_STATE) == '64' || $(INSTANCE_STATE) == '80' ]; then
  echo -e "\n\e[33m $INSTANCE_NAME is exists and ${INSTANCE_STATE_CODE[$INSTANCE_STATE]}\n"
  exit 1
fi

echo -e "\t\t\e[32m-----------------Launching Instance-----------------\e[0m\n"

IP=$(aws ec2 --launch-template 'LaunchTemplateId=$LID,Version=$LVER' --tag-specifications "ResourceType=spot-instances-request,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" | jq.Instances[].PrivateIpAddress | sed -e 's/"//g')
