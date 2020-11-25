#!/bin/bash
rng(){
    x="$(cat /dev/urandom | xxd -u -l 1 -p)";: make sure to move your mouse around or something
    echo "ibase=G;obase=A;$x" | bc
}
enc=""
data=""
key_svd=""
echo "Press CTRL+D when you are finished" #unless input is a pipe
data="$(cat /dev/stdin)"
data="$(echo $data | perl -lpe '$_=unpack"B*"')"
data="$(echo $data | sed 's/.\{1\}/& /g')"
echo $data
for i in $data;do
    temp_key="$(rng)";((key%=2))
    key_svd="$key_svd$temp_key"
    case $i$temp_key in
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
echo "$key_svd" | sed 's/.\{8\}/& /g'
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
for i in $(echo "ibase=2;obase=G;$key_svd" | bc | sed 's/.\{2\}/& /g');do
    i="${i//\\/}"
    i="${i// /}"
    for x in $i;do
        echo -n "${x} "
    done
done;echo
echo "ibase=2;obase=G;$key_svd" | bc | xxd -p -r > key
