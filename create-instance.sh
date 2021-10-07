#!/usr/bin/env bash

LID="lt-048c498b2ab4c35c3"
LVER=1
aws ec2 --launch-template LaunchTemplateId=$LID,Version=$LVER 
