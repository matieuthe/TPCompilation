#!/bin/bash
cd $1/$2
if [ $# -eq 2 ] || [ $3 == "-c" ]
    then
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
fi

if [ $# -eq 2 ] || [ $3 == "-e" ]  
then
    echo
    echo "----------------------"
    echo "Execution of Java Code"
    echo "----------------------"
    echo
    java $2 $2".txt"
fi