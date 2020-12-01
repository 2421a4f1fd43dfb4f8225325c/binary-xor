#!/bin/bash
#you can also use this as XOR with a set key
decrypted=""
read -e -r -p "Encrypted text [binary]: " encrypted
read -e -r -p "Key text [binary]: " key
key=( $(echo $key|sed 's/.\{1\}/& /g') )
key_location="0"
for i in $(echo $encrypted|sed 's/.\{1\}/& /g');do
decrypted+=$(( ($i+${key[$key_location]}) % 2))
((key_location++))
done
echo $decrypted|sed 's/.\{8\}/& /g'
echo "ibase=2;obase=G;$decrypted"|bc|xxd -p -r
