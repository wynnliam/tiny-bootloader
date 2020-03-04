# Tiny Bootloader

This code follows the tutorial from [Joe Bergeron](http://joebergeron.io/posts/post_two.html)

In this project, I attempt to build a tiny bootloader. I will consider this a success when I
can put this on a flash drive and boot it.

## What do I need to compile this code?
You will need [NASM](https://www.nasm.us/), the Netwide Assembler, and the
[bochs](http://bochs.sourceforge.net/) emulator. Since these are open source,
there are a ton of ways to get them. Since I am running Arch Linux, I use

`sudo pacman -S nasm bochs`

## How do I compile and run this project
Provided you have nasm and bochs installed properly, run the following commands:

`make all`

This will assemble to code into `boot.com`

Then run :

`make run`

This will run the bootloader in bochs.
