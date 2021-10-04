#!/usr/bin/env bash

Sample () { echo I am a function
echo "The value of a is $a"
b=20
}

a=10 ##Here declaring variable a
Sample ##Here we are calling Sample function and compiled variables in it
echo "The value of b in main program is $b" ##after calling Sample function above line, value of b compiled 

exit 0
