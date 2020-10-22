#!/bin/bash
: '
Variables:
Encrypted: Encrypted text
Key: Key text
Key_location: location of key character array (in loop)
Decrypted: Decrypted text
'
decrypted=""
read -e -r -p "Encrypted text [In base 2]: " encrypted
read -e -r -p "Key text [In base 2]: " key
key=( $(echo $key | sed 's/.\{1\}/& /g') )
key_location="0"
for i in $(echo $encrypted | sed 's/.\{1\}/& /g');do
case $i${key[$key_location]} in
    00|11)
    decrypted+=0
    ;;
    01|10)
    decrypted+=1
    ;;
esac
((key_location++))
done
echo $decrypted
echo "ibase=2;obase=G;$decrypted" | bc | sed 's/.\{2\}/& /g'
echo "ibase=2;obase=G;$decrypted" | bc | xxd -p -r