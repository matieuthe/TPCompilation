#!/bin/bash
cd $1/$2
echo
echo "----------------------"
echo "Execution of Jflex"
echo "----------------------"
echo
fileJflex=$2".jflex"
jflex $fileJflex
fileJava=$2".java"
echo
echo "----------------------"
echo "Compilation of Java file"
echo "----------------------"
echo
javac $fileJava
echo
echo "----------------------"
echo "Execution of Java Code"
echo "----------------------"
echo
java $2 $2".txt"