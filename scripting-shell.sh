#!/bin/bash
#Hello Bokka
a=12
b=13
c=14
d
echo hello 123
echo -e "$a \n $b \n $c"
echo -e "\e[32m Iam pretty in green;38m \e[0m"
echo $d
echo $(date +%F)
echo $(who |wc -l)
echo "the script is $0"
echo $1
echo $2
echo $3
echo $4
echo "$* this is dollar*"
echo "$@ this is @"
echo "$# this is #"
echo "$$ this is $"
read -p "ENTER THE NAME OF THE USER:" NAME
echo $NAME
