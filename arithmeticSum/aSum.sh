#!/bin/bash

# Check if an argument is provided. If not, prompt user for values.
if [ $# -ne 3 ]; then
  echo "Calculates the arithmetic sum, via ( n * ( 2*a + (n-1)*i ) ) / 2"
  echo
  echo "Usage: $0 n a i"
  echo "Example: $0 10 5 1 (This sets n=10, a=5, i=1)"
  echo

  echo "Argument invalid. Please supply the values to calculate the arithmetic sum."
  echo

  echo -n "Enter quantity (n): "
  read -r n

  echo -n "Enter first term (a): "
  read -r a

  echo -n "Enter common difference (i): "
  read -r i
  echo
else
  echo "Calculating arithmetic sum via: ( n * ( 2*a + (n-1)*i ) ) / 2"
  echo
  echo "Using values: n=$1, a=$2, i=$3"
  echo

  n=$1
  a=$2
  i=$3
fi

echo -n "Arithmetic Sum =  ( n * ( 2*a + (n-1)*i ) ) / 2 = $(( ($n*(2*$a+($n-1)*$i))/2 ))"
echo
