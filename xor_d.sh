#!/bin/bash

Help()
{
   # Display Help
   echo "XOR Decyption Tool that accepts an input file(-f) and a hex XOR decryption key(-k) with options to adjust the infile offset(-s), number of bytes(-b) XOR decrypted per iteration(1-4), a hex number for incrementing the XOR decryption key(-i) per iteration, and a hex number for incrementing the Part of the file being XOR decrypted(-p) per iteration."
   echo
   echo "Syntax: xor_d.sh [-f Input_File] [-b Number_of_Bytes] [-k XOR_Key] [-i XOR_Key_Increment] [-o Outfile | -x Preview_Number_of_Bytes]"
   echo "options:"
   echo "-b     Decimal number of Bytes (Part) to XOR Decrypt per Iteration. If left empty, the tool will XOR Decrypt 4 bytes(DWORD) with same XOR Decryption Key per iteration."
   echo "-f     Input Filename."
   echo "-h     Print this Help."
   echo "-i     XOR Decryption Key Increment. Hex number for incrementing the XOR Decryption Key per iteration. Default is zero."
   echo "-k     XOR Decryption Key. If left empty the tool will use the last 4 Bytes from the input file as the XOR Decyption Key. Enter in Hex."
   echo "-o     Output Filename."
   echo "-p     Part Increment. Hex number for incrementing the Part of the file being XOR decrypted per iteration. Default is zero."
   echo "-s     Start Bytes. Decimal number for infile offset. Default is zero."
   echo "-x     Preview x Number Bytes of Decrypted Data."
   echo
}

while getopts x:b:k:f:o:i:p:s:h flag
do
    case "${flag}" in
    	x) PREVIEW=${OPTARG};;
        b) BYTES=${OPTARG};;
        k) KEY=${OPTARG};;
        f) FILENAME=${OPTARG};;
        o) OUTPUT=${OPTARG};;
        i) KEY_INC=${OPTARG};;
        p) PART_INC=${OPTARG};;
        s) START_BYTES=${OPTARG};;
        h) Help 
           exit;;
    esac
done

if [[ -z $OUTPUT && -z $PREVIEW ]]
then
	echo "Supply a value for either parameter -o Outfile or -x Preview_Number_of_Bytes"
	exit
fi

if [ $BYTES -gt 4 ]
then
	echo "Bytes value too high. Please supply a bytes value of 1-4"
	exit
fi

FILESIZE=$(stat -c%s "$FILENAME")

if [ $START_BYTES -ge $FILESIZE ]
then
	echo "Start Bytes values too high. The value should be less than the input file size."
	exit
fi

KEY_INC=$(printf "%08x" $(($KEY_INC)))
PART_INC=$(printf "%08x" $(($PART_INC)))

PART_INC_C=$PART_INC

if [ -z "$KEY" ]
then
	KEY_BYTES=$(( $FILESIZE - 4 ))
	KEY=$(xxd -e -s$KEY_BYTES -l4 $FILENAME | awk '{ print $2 }')
fi

KEY=${KEY^^}

if [ -z "$START_BYTES" ]
then
	START_BYTES=0
fi

KEY_LEN=`expr length "$KEY"`

if [ -z "$BYTES" ]
then
	BYTES=4
fi

INC=$BYTES

PART=$(xxd -e -s$START_BYTES -l$BYTES $FILENAME | awk '{ print $2 }')
DECODED_PART=$(echo $PART | xxd -r -p | xortool-xor -h $KEY -f - | xxd -e | awk '{ print $2 }')
DECODED="${DECODED}${DECODED_PART}"
START_BYTES=$(( $START_BYTES + $INC ))
KEY=$(printf "%08x" $((0x$KEY + 0x$KEY_INC)))


while [ $START_BYTES -lt $FILESIZE ]
do
  PART=$(xxd -e -s$START_BYTES -l$BYTES $FILENAME | awk '{ print $2 }')
  PART=$(printf "%08x" $((0x$PART + 0x$PART_INC)))
  DECODED_PART=$(echo $PART | xxd -r -p | xortool-xor -h $KEY -f - | xxd -e | awk '{ print $2 }')
  DECODED="${DECODED}${DECODED_PART}"
  START_BYTES=$(( $START_BYTES + $INC ))
  PART_INC=$(printf "%08x" $((0x$PART_INC + 0x$PART_INC_C)))
  KEY=$(printf "%08x" $((0x$KEY + 0x$KEY_INC)))
  printf -v PROGRESS '%.2f' $(echo "$START_BYTES / $FILESIZE*100" | bc -l)
  echo -ne "Progress: $PROGRESS%\r"
done

if [ -z "$PREVIEW" ]
then
	:
else
	echo ""
	echo "Hex:"
	echo $DECODED
	echo ""
	echo "Binary:"
	echo $DECODED | xxd -r -p
	echo ""
fi

if [ -z "$OUTPUT" ]
then
	echo ""
	echo "Hex:"
	echo $DECODED
else
	echo $DECODED | xxd -r -p - $OUTPUT
fi

