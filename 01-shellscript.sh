#!/usr/bin/env bash
echo "Hello World"
printf "New line below Hello World\n"
#Bash tips: Color and Formatting (ANSI/VT100 Control sequences)
#Escape character <Esc> "\e","\033","\x1B" and followed by character/color code "<Esc>[FormatCodem..."
#NOTE: The -e option of the echo command enable the parsing of the escape sequences.
#NOTE: The “\e[0m” sequence removes all attributes (formatting and colors).
#It can be a good idea to add it at the end of each colored text.
#Set of codes
echo -e "This is \e[1mBold\e[0m"
echo -e "This is \e[2mDim\e[0m"
echo -e "This is \e[4mUnderline\e[0m"
echo -e "This is \e[5mBlink\e[0m"
echo -e "This is \e[7mInverted Color\e[0m"
echo -e "This is \e[8mHidden\e[0m"

#Reset of codes
echo -e "This is \e[1mBold \e[21mNormal\e[0m"
echo -e "This is \e[2mDim \e[22mNormal\e[0m"
echo -e "This is \e[4mUnderline \e[24mNormal\e[0m"
echo -e "This is \e[5mBlink \e[25mNormal\e[0m"
echo -e "This is \e[7mInverted Color \e[27mNormal\e[0m"
echo -e "This is \e[8mHidden \e[28mNormal\e[0m"
