#!/bin/bash
read -e -r -p "Start RNG: " rng
if ! [ "$rng" -eq "$rng" ] 2>/dev/null;then
echo -e "\033[38;05;9mInteger expected but found $rng"
return 1
exit
fi
RANDOM=$rng
enc=""
data=""
key_svd=""
read -e -r -p "text: " data
data="$(echo $data | perl -lpe '$_=unpack"B*"')"
data="$(echo $data | sed 's/.\{1\}/& /g')"
echo $data
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
