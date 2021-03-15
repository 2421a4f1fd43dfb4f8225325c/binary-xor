#!/bin/bash
data="$(cat|xxd -u -p|sed 's/.\{2\}/& /g'|tr -d '\n')"
for dataloop in $data;do
        dataloop=$(bc <<<"ibase=G;obase=A;$dataloop")
        #converted to base 10 [0-255]
        key=$(cat /dev/urandom|hexdump -v -e '/1 "%u"' -n 1)
        ((key%=256))
        #key=random [0-255]
        xord=$((key^dataloop))
        #xor'd
        xord=$(bc <<<"ibase=A;obase=G;$xord")
        [ "$(echo -n $xord|wc -c)" -lt "2" ]&&xord="0$xord"
        total_encrypted+="$xord"
        key=$(bc <<<"ibase=A;obase=G;$key")
        [ "$(echo -n $key|wc -c)" -lt "2" ]&&key="0$key"
        total_key+="$key"
done
echo "$total_encrypted"|sed 's/.\{2\}/& /g'
echo
echo "$total_key"|sed 's/.\{2\}/& /g'

echo "$total_encrypted"|xxd -p -r > encrypted
echo "$total_key"|xxd -p -r > key
