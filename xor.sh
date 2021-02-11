#!/bin/bash
enc="";data="";key_svd=""
data="$(cat|base64 -w 0|perl -lpe '$_=unpack"B*"'|sed 's/.\{1\}/& /g')"
echo "$data"|tr -d '\n';echo
for i in $data;do
        key=$(od -An -N1 -i /dev/urandom|tr -d ' ')
        enc+=$((i^(key%=2)))
        key_svd+=$key
done
clear
echo "Ciphertext: `echo "$enc"|sed 's/.\{8\}/& /g'`"
echo "Key: `echo "$key_svd"|sed 's/.\{8\}/& /g'`"
for i in $(seq $(tput cols));do echo -n "#";done;echo
echo "ibase=2;obase=G;$enc"|bc|xxd -p -r > encrypted
cat encrypted|xxd -u -l 10000000000 -p|sed 's/.\{2\}/& /g'|tr -d '\n';echo
for i in $(seq $(tput cols));do echo -n "#";done
echo "ibase=2;obase=G;$key_svd"|bc|xxd -p -r > key
cat key|xxd -u -l 10000000000000000 -p|sed 's/.\{2\}/& /g'|tr -d '\n';echo
