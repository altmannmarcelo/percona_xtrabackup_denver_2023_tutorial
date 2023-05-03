#!/bin/bash
# Simple bash script to read xbstream chunks
FILE=$1

MAGIC=$(xxd -l 8 $FILE | awk '{print $6}')
OFFSET=9
TYPE=$(xxd -s ${OFFSET} -l 1 $FILE | awk '{print $3}')

echo "Magic: $MAGIC"
if [ "$TYPE" == "P" ]; then
    echo "Type: $TYPE (Payload)"
elif [ "$TYPE" == "S" ]; then
    echo "Type: $TYPE (Sparse Map)"
    echo "Not implemented"
    exit 0
elif [ "$TYPE" == "E" ]; then
    echo "Type: $TYPE (End of File)"
elif [ "$TYPE" == "\0" ]; then
    echo "Type: $TYPE (Unknown)"
    echo "Not implemented"
    exit 0
else
    echo "Type: $TYPE (Invalid)"
    exit 1
fi

OFFSET=$(($OFFSET+1)) # 10
PATH_LENGTH=$(od -An -j${OFFSET} -D -N4 $FILE)
echo "Path Length: $PATH_LENGTH"

OFFSET=$(($OFFSET + 4)) # 14
FILE_PATH=$(xxd -ps -s ${OFFSET} -l $PATH_LENGTH $FILE | xxd -r -ps | tr -d '\0')
echo "Path: $FILE_PATH"

if [ "$TYPE" == "E" ]; then
    exit 0
fi

OFFSET=$(($OFFSET + $PATH_LENGTH))
PAYLOAD_SIZE=$(od -An -j${OFFSET} -t u8 -N8 $FILE)
echo "Payload Size: $PAYLOAD_SIZE"


OFFSET=$(($OFFSET+8))
PAYLOAD_OFFSET=$(od -An -j${OFFSET} -t u8 -N8 $FILE)
echo "Payload Offset: $PAYLOAD_OFFSET"


OFFSET=$(($OFFSET+8))
CHECKSUM=$(od -An -j${OFFSET} -D -N4 $FILE)
echo "Checksum: $CHECKSUM"


OFFSET=$(($OFFSET+4))
PAYLOAD=$(xxd -p -s ${OFFSET} -l $PAYLOAD_SIZE $FILE| xxd -r -p | tr -d '\0')
echo -e "*****Payload*****\n$PAYLOAD"



