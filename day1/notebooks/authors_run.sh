#!/bin/bash

file='data/authors.txt'
n=1
while read line; do
    echo "Line $n : $line"
    n=$((n+1))
done < $file