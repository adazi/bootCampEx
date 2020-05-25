#!/bin/bash

for x in {1..30}
do
    # if even
    if [ $((x%2)) -eq 0 ]
    then
	echo $x >> evens.txt
    else
	echo $x "is odd"
    fi
done
