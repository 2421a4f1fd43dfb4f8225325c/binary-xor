#!/bin/bash
rng(){
    x="$(cat /dev/urandom | xxd -u -l 1 -p)"
    echo "ibase=G;obase=A;$x" | bc
}
enc=""
data=""
key_svd=""
echo "Press CTRL+D when you are done typing"
data="$(cat /dev/stdin)";echo
data="$(echo $data | perl -lpe '$_=unpack"B*"')"
data="$(echo $data | sed 's/.\{1\}/& /g')"
echo $data
for i in $data;do
    key="$(rng)"
    ((key%=2))
    key_svd+=$key
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
echo "Ciphertext: `echo "$enc" | sed 's/.\{8\}/& /g'`"
echo "Key: `echo "$key_svd" | sed 's/.\{8\}/& /g'`"
for i in $(seq $(tput cols));do echo -n "#";done;echo
echo "ibase=2;obase=G;$enc" | bc | sed 's/.\{2\}/& /g' | sed 's/\\//g'
for i in $(seq $(tput cols));do echo -n "#";done
echo "ibase=2;obase=G;$key_svd" | bc | sed 's/.\{2\}/& /g' | sed 's/\\//g'
echo "ibase=2;obase=G;$key_svd" | bc | xxd -p -r > key
echo "ibase=2;obase=G;$enc" | bc | xxd -p -r > encrypted
