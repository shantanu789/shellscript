#!/usr/bin/env bash
echo "Hello World"
printf "New line below Hello World"
#Bash tips: Color and Formatting (ANSI/VT100 Control sequences)
#Escape character <Esc> "\e","\033","\x1B" and followed by character/color code "<Esc>[FormatCodem..."
#NOTE: The -e option of the echo command enable the parsing of the escape sequences.
#NOTE²: The “\e[0m” sequence removes all attributes (formatting and colors).
#It can be a good idea to add it at the end of each colored text.
echo -e "This is \e[1mBold"
echo -e "This is \e[2mDim"
echo -e "This is \e[4mUnderline"
echo -e "This is \e[5mBlink"
echo -e "This is \e[7mInverted Color"
echo -e "This is \e[8mHidden"