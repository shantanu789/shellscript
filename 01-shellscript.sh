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
echo -e "This is \e[5mBlink \e[25m Normal\e[0m"
echo -e "This is \e[7mInverted Color \e[27mNormal\e[0m"
echo -e "This is \e[8mHidden \e[28mNormal\e[0m"

#Foreground Text color code
echo -e "R Red color code 31 \e[31mRed \e[0m"
echo -e "G Green color code 32 \e[32mGreen \e[0m"
echo -e "Y Yellow color code 33 \e[33mYellow \e[0m"
echo -e "B Blue color code 34 \e[34mBlue \e[0m"
echo -e "M Magenta color code 35 \e[35mMagenta \e[0m"
echo -e "C Cyan color code 36 \e[36mCyan \e[0m"
echo -e "Dark Gray color code 37 \e[37Dark Gray \e[0m"