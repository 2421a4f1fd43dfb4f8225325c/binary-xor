#!/bin/bash
enc=""
data=""
read -e -r -p "text: " data
read -e -r -p "key: " key
key_length="$(echo $key | wc -c)"
data="$(echo $data | perl -lpe '$_=unpack"B*"')"
key="$(echo $key | perl -lpe '$_=unpack"B*"')"
key=( $(echo $key | sed 's/.\{1\}/& /g') )
data="$(echo $data | sed 's/.\{1\}/& /g')"
echo $data
key_location=0
for i in $data;do
case $i${key[$key_location]} in
    00|11)
    enc+=0
    ;;
    01|10)
    enc+=1
    ;;
    *)
    echo $i${key[$key_location]}
    ;;
esac
((key_location++))
if [ "$key_location" -gt "$key_length" ];then
key_location=0
fi
done
clear
echo -n "Ciphertext: "
echo "$enc" | sed 's/.\{8\}/& /g'
echo -n "Key: "
echo "$key_svd" | sed 's/.\{8\}/& /g'

echo "ibase=2;obase=G;$enc" | bc
echo "ibase=2;obase=G;$enc" | bc | xxd -p -r
echo "ibase=2;obase=G;$enc" | bc | xxd -p -r > encrypted
