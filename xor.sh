#!/bin/bash
enc="";data="";key_svd=""
data="$(cat|perl -lpe '$_=unpack"B*"'|sed 's/.\{1\}/& /g')"
printf "\n$data\n"
for i in $data;do
	key=$(cat /dev/urandom|hexdump -v -e '/1 "%u"' -n 1)
	enc+=$(((i+(key%=2))%2))
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
