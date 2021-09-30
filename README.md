# shellscript

In Shell there are multiple types of shell,

BASH = KSH + SH + CSH (On server side, default shell BASH)

Here some points we are going to discuss, following points are:

1. She-bang or Hash-bang
2. Print messages on the screen
3. variables
4. take inputs
5. functions
6. redirects, quotes and exit status
7. conditions
8. loops

```
#! --> The header is called an interpreter directive (it is also called a hashbang or shebang).
It specifies that /bin/bash is to be used as the interpreter when the file is used as the executable in a command. When the kernel executes a non-binary file, it reads the first line of the file.
If the line begins with #!, the kernel uses the line to determine the interpreter to relay the file to. (There are other valid ways to do this as well, see below.)

The #! must be at the very start of the file, with no spaces or blank lines before it. Our script's commands will appear on separate lines below this.

Tip — Instead of #!/bin/bash , you could use
--> #!/usr/bin/env bash
```
