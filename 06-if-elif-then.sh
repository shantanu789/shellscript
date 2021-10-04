#!/usr/bin/env bash

read -r "Enter your input: " input

if [ -z "$input" ]; then
  echo "Please enter the input, You have not enter anything."
  exit 1
fi

if [ "$input" == "ABC" ]; then
  echo "This is your input: ABC"
fi

echo input: "$input"

if [ "$?" -eq 0 ]; then
  echo Success
else
  echo Failure
fi

read -p "Enter the filename or file path: " filename

if [ -e "$filename" ]; then
  echo "File does exists $filename"
else
  echo "File does not exists"
fi