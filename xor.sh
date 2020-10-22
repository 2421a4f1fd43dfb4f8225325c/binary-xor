#!/bin/bash

case $1 in
    "-p encrypted")
    output='echo "ibase=2;obase=G;$enc" | bc | xxd -p -r"'
    ;;
    "-p key")
    output='echo "ibase=2;obase=G;$key_svd" | bc | xxd -p -r'
    ;;
    "-p")
    output='echo "ibase=2;obase=G;$enc" | bc | xxd -p -r;echo "ibase=2;obase=G;$key_svd" | bc | xxd -p -r'
    ;;
    "-h encrypted")
    output='echo "ibase=2;obase=G;$enc" | bc | xxd -p -r'
    ;;
    "-h key")
    output='echo "ibase=2;obase=G;$key_svd" | bc'
    ;;
    "-h")
    output='echo "ibase=2;obase=G;$enc" | bc;echo "ibase=2;obase=G;$key_svd" | bc'
    ;;
esac

enc=""
data=""
key_svd=""
read -e -r -p "text: " data
data="$data$pad"
data="$(echo $data | perl -lpe '$_=unpack"B*"')"
data="$(echo $data | sed 's/.\{1\}/& /g')"
for i in $data;do
key="$((RANDOM%2))"
key_svd="$key_svd$key"
case $i$key in
    00|11)
    enc+=0
    ;;
    01|10)
    enc+=1
    ;;
esac
done
clear

if [ "$output" != "" ];then
echo $output > tmp
. tmp
else
echo "ibase=2;obase=G;$enc" | bc
echo "ibase=2;obase=G;$enc" | bc | xxd -p -r
echo "ibase=2;obase=G;$enc" | bc | xxd -p -r > encrypted
echo
echo "ibase=2;obase=G;$key_svd" | bc
echo "ibase=2;obase=G;$key_svd" | bc | xxd -p -r
echo "ibase=2;obase=G;$key_svd" | bc | xxd -p -r > key
fi
