#!/bin/bash
#you can also use this as XOR with a set key; the output will just look a little weird, you can just ignore that.
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
echo $decrypted | sed 's/.\{8\}/& /g'
: > dec_hex
for i in $(echo "ibase=2;obase=G;$decrypted" | bc | sed 's/.\{2\}/& /g');do
i="${i//\\/}"
for x in $i;do
echo -n "$x "
echo -n "$x " >> dec_hex
done
done;echo
echo "ibase=2;obase=G;$decrypted" | bc | xxd -p -r
echo "ibase=2;obase=G;$decrypted" | bc | xxd -p -r > decrypted
