#!/usr/bin/env bash

read -p "Enter your input: " input

if [ -z "$input" ]; then
  echo "Please enter the input, You have not enter anything."
else
  echo "This is your input: $input"
fi
} while [ -z != $input ]