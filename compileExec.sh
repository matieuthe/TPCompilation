#!/bin/bash
cd $1
fileJflex=$1".jflex"
run1=$(jflex $fileJflex)
fileJava=$1".java"
javac $fileJava
java $1 $1".txt"