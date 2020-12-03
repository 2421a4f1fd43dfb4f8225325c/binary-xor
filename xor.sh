#!/bin/bash
rng(){
    cat /dev/urandom|hexdump -v -e '/1 "%u"' -n 1
}
enc="";data="";key_svd=""
data="$(cat /dev/stdin)";echo
data="$(echo $data|perl -lpe '$_=unpack"B*"'|sed 's/.\{1\}/& /g')"
echo $data
for i in $data;do
key="$(rng)"
enc+=$(((i+(key%=2))%2))
key_svd+=$key
done
clear
echo "Ciphertext: `echo "$enc"|sed 's/.\{8\}/& /g'`"
echo "Key: `echo "$key_svd"|sed 's/.\{8\}/& /g'`"
for i in $(seq $(tput cols));do echo -n "#";done;echo
echo "ibase=2;obase=G;$enc"|bc|sed 's/.\{2\}/& /g'|sed 's/\\//g'
for i in $(seq $(tput cols));do echo -n "#";done
echo "ibase=2;obase=G;$key_svd"|bc|sed 's/.\{2\}/& /g'|sed 's/\\//g'
echo "ibase=2;obase=G;$key_svd"|bc|xxd -p -r > key
echo "ibase=2;obase=G;$enc"|bc|xxd -p -r > encrypted
