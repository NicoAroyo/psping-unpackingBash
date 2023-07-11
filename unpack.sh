#!/bin/bash

FILES_UNPACKED=0
VERBOSE=false
RECURSIVE=false

unpack() {
    FILE=$1
    FILE_TYPE=$(file -b "$FILE")
    case "$FILE_TYPE" in
        *"gzip compressed data"*)
            if [ "$VERBOSE" = true ]; then
                echo "unpacking $FILE"
            fi
            gunzip -f "$FILE"
            ((FILES_UNPACKED++))
            ;;
            
        *"bzip2 compressed data"*)
            if [ "$VERBOSE" = true ]; then
                echo "unpacking $FILE"
            fi
            bunzip2 -f "$FILE"
            ((FILES_UNPACKED++))
            ;;
            
        *"Zip archive"*)
            if [ "$VERBOSE" = true ]; then
                echo "unpacking $FILE"
            fi
            unzip -o "$FILE"
            ((FILES_UNPACKED++))
            ;;
            
        *"compress'd data"*)
            if [ "$VERBOSE" = true ]; then
                echo "unpacking $FILE"
            fi
            uncompress -f "$FILE"
            ((FILES_UNPACKED++))
            ;;
        *) 
            if [ "$VERBOSE" = true ]; then 
                echo "ignoring $FILE"
            fi
            ;;
    esac 
}

traverse() {
    DIR=$1
    for archive in "$DIR"/*; do
        if [ -f "$archive" ]; then
            unpack "$archive"
        elif [ -d "$archive" ]; then
            if [[ "$RECURSIVE" == true ]]; then 
                traverse "$archive"
            else 
                echo "ignoring $archive"
            fi 
        fi
    done
}

while getopts "rv" flag; do
    case $flag in
        r)
            RECURSIVE=true
            ;;
        v)
            VERBOSE=true
            ;;
        *)
            echo "Invalid flag: -$OPTARG"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

for archive in "$@"; do
    if [ -f "$archive" ]; then   
        unpack "$archive"
    elif [ -d "$archive" ]; then
        
            traverse "$archive"
    fi
done

echo "Decompressed $FILES_UNPACKED archive(s)"

