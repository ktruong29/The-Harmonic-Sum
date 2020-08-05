/**************************************
Author:        Kien Truong
Program name:  Assignment 6
Course ID:     CPSC 240
***************************************/

#include <stdio.h>
double harmonic_sum();

int main()
{
  double return_code = -99.0;

  printf("%s", "Welcome to the fast number crunching by Kien Truong\n\n");

  return_code = harmonic_sum();

  printf("%s%5.10lf%s", "This driver has received this number ", return_code,
         ". Have a nice day.\nMain will return 0 to the operating system.");

  return 0;
}
