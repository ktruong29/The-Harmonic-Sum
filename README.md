# The Harmonic Sum
---
The purpose of this program is to become familiar with implementing a loop that
performs floating point arithmetic, along with the understanding of how to read
and compute tic count and run-time of the CPU

This program will do the following:
* Inputs a number of terms for calculating harmonic sum
* Reads the tic count from the system clock before the computation
* Computes and displays an intermediate value for each iterations
* Computes and displays the final sum
* Reads the tic count from the system clock after the computation
* Computes and displays the elapsed time in tics
* Computes and displays the elapsed time in seconds
* Returns the sum back to the main function

This program has three different source files:
* A driver file, which is written in C language.
* An X86 assembly file, which is a function written in X86 language and
is called from the driver program. This program does all the computations
specified above.
* A bash script is used to compile the two previously mentioned files, link
them to create one executable file, and lastly load that newly created
executable file.

## Prerequisites
---
* A virtual machine
* Install g++ and nasm

## Instruction on how to run the program
---
1. chmod +x run.sh then ./run.sh
2. sh run.sh
