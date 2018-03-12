#!/bin/bash
cd $1/$2
fileJflex=$2".jflex"
run1=$(jflex $fileJflex)
fileJava=$2".java"
javac $fileJava
java $2 $2".txt"