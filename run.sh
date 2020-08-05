#!/bin/bash


#Author: Kien Truong
#Program name: Assignment 6
#Course ID: CPSC 240

rm *.o
rm *.out

echo "This is program <The Harmonic Sum>"

echo "Assemble the module assignment6.asm"
nasm -f elf64 -l assignment6.lis -o assign6.o assignment6.asm

echo "Compile the C module assignment6.c"
gcc -c -m64 -Wall -std=c11 -o assignment6.o assignment6.c -fno-pie -no-pie

echo "Link the object files already created"
g++ -m64 -o assignment6.out assignment6.o assign6.o -fno-pie -no-pie -std=c++14

echo "The program will run"
./assignment6.out

echo "The bash script file is now closing."
