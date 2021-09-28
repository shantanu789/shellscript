#!/usr/bin/env bash
echo "Hello World"
printf "New line below Hello World\n"
#Bash tips: Color and Formatting (ANSI/VT100 Control sequences)
#Escape character <Esc> "\e","\033","\x1B" and followed by character/color code "<Esc>[FormatCodem..."
#NOTE: The -e option of the echo command enable the parsing of the escape sequences.
#NOTE: The “\e[0m” sequence removes all attributes (formatting and colors).
#It can be a good idea to add it at the end of each colored text.
#Set of codes
echo -e "\e[1;4mSet of codes\e[0m"
echo -e "(1)This is \e[1mBold\e[0m"
echo -e "(2)This is \e[2mDim\e[0m"
echo -e "(4)This is \e[4mUnderline\e[0m"
echo -e "(5)This is \e[5mBlink\e[0m"
echo -e "(7)This is \e[7mInverted Color\e[0m"
echo -e "(8)This is Hidden - \e[8mHidden\e[0m"

#Reset of codes
echo -e "\e[1;4mHow to reset codes\e[0m"
echo -e "This is \e[1mBold \e[21mNormal\e[0m"
echo -e "This is \e[2mDim \e[22mNormal\e[0m"
echo -e "This is \e[4mUnderline \e[24mNormal\e[0m"
echo -e "This is \e[5mBlink \e[25m Normal\e[0m"
echo -e "This is \e[7mInverted Color \e[27mNormal\e[0m"
echo -e "This is Hidden - \e[8mHidden \e[28mThis is back to Normal\e[0m"

#Foreground Text color code
echo -e "\e[1;4mForeground Text regular color codes\e[0m"
echo -e "R Red color code 31 \e[31mRed \e[0m"
echo -e "G Green color code 32 \e[32mGreen \e[0m"
echo -e "Y Yellow color code 33 \e[33mYellow \e[0m"
echo -e "B Blue color code 34 \e[34mBlue \e[0m"
echo -e "M Magenta color code 35 \e[35mMagenta \e[0m"
echo -e "C Cyan color code 36 \e[36mCyan \e[0m"

echo -e "\e[1;4mLight and Dark Gray colors codes\e[0m"
echo -e "Light Gray color code 37 \e[37mLight Gray \e[0m"
echo -e "Dark Gray color code 90 \e[90mDark Gray \e[0m"

#Light color series and color codes
echo -e "\e[1;4mLight color series and color codes\e[0m"
echo -e "Light Red color code 91 \e[91m Light Red \e[0m"
echo -e "Light Green color code 92 \e[92m Light Green \e[0m"
echo -e "Light Yellow color code 93 \e[93m Light Yellow \e[0m"
echo -e "Light Blue color code 94 \e[94m Light Blue \e[0m"
echo -e "Light Magenta color code 95 \e[95m Light magenta \e[0m"
echo -e "Light Cyan color code 96 \e[96m Light Cyan \e[0m"

#Black and White color code
echo -e "\e[1;4mBlack and White color code\e[0m"
echo -e "Black color code 30 \e[30mBlack \e[0m"
echo -e "White color code 97 \e[97mWhite \e[0m"

#Default Foreground text color
echo -e "39 Default Foreground text color - \e[39mDefault\e[0m"
#Default Background text color
echo -e "49 Default Background text color - \e[49mDefault\e[0m"

#Default background colors
echo -e "Code - 40 Default background \e[40mBlack\e[0m"
echo -e "Code - 41 Default background \e[41mRed\e[0m"
echo -e "Code - 42 Default background \e[42mGreen\e[0m"
echo -e "Code - 43 Default background \e[43mYellow\e[0m"
echo -e "Code - 44 Default background \e[44mBlue\e[0m"
echo -e "Code - 45 Default background \e[45mMagenta\e[0m"
echo -e "Code - 46 Default background \e[46mCyan\e[0m"
echo -e "Code - 47 Default background \e[47mLight Gray\e[0m"
echo -e "Code - 100 Default background \e[100mDark Gray\e[0m"
echo -e "Code - 101 Default background \e[101mLight Red\e[0m"
echo -e "Code - 102 Default background \e[102mLight Green\e[0m"
echo -e "Code - 103 Default background \e[103mLight Yellow\e[0m"
echo -e "Code - 104 Default background \e[104mLight Blue\e[0m"
echo -e "Code - 105 Default background \e[105mLight Magenta\e[0m"
echo -e "Code - 106 Default background \e[106mLight Cyan\e[0m"
echo -e "Code - 107 Default background \e[107;30mWhite background\e[0m"