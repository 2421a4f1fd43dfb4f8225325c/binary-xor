#!/bin/bash
getrandom(){
urandom="$(cat /dev/urandom | xxd -u -l 1 -p)"
echo "ibase=G;obase=2;$urandom" | bc | cut -c 6-6
}
getrandom
enc=""
data=""
keyTotal=""
read -e -r -p "text: " data
data="$(echo $data | perl -lpe '$_=unpack"B*"')"
data="$(echo $data | sed 's/.\{1\}/& /g')"
echo $data
for i in $data;do
key="$(getrandom)"
keyTotal="$keyTotal$key"
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
echo -n "Ciphertext: "
echo "$enc" | sed 's/.\{8\}/& /g'
echo -n "Key: "
echo "$keyTotal" | sed 's/.\{8\}/& /g'
for i in $(echo "ibase=2;obase=G;$enc" | bc | sed 's/.\{2\}/& /g');do
i="${i//\\/}"
i="${i// /}"
for x in $i;do
echo -n "$x "
done
done;echo
echo "ibase=2;obase=G;$enc" | bc | xxd -p -r > encrypted
for i in $(seq $(tput cols));do
echo -n "#"
done
for i in $(echo "ibase=2;obase=G;$keyTotal" | bc | sed 's/.\{2\}/& /g');do
i="${i//\\/}"
i="${i// /}"
for x in $i;do
echo -n "${x} "
done
done;echo
echo "ibase=2;obase=G;$keyTotal" | bc | xxd -p -r > key
