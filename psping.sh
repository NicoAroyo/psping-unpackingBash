#!/bin/bash


COUNT=-1
TIME=1
PROCESS_COUNT=0

timeout() {
    local TIME=$1 
    sleep $TIME 
    kill -s TERM $$
}

while getopts "c:t:u:" opt; do
    case $opt in
        c)
            COUNT=$OPTARG
            ;;
        t) 
            if [[ $OPTARG =~ ^[0-9]+$ ]]; then
                TIME=$OPTARG
            fi
            timeout $TIME &   
        ;;
        u) 
            USER=$OPTARG
        ;;     
        *)
            echo "Invalid option: -$opt"
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1)) 

if [ $# -eq 1 ]; then
    EXE=$1
fi

if [ -n $USER ]; then 
    echo "pinging $EXE for $USER"
else 
    echo "pinging $EXE" 
fi

i=0

if [ "$COUNT" -eq -1 ]; then

while true; do
    if [ -n $USER ]; then 
        echo "$EXE:  $(pgrep -c -u $USER $EXE ) instance(s)"
    else
        echo "$EXE:  $(pgrep -c $EXE ) instance(s)"   
    fi
done 
elif [ "$COUNT" -ne -1 ]; then
    while [ $i -ne $COUNT ]; do
        if [ -n $USER ]; then 
            echo "$EXE:  $(pgrep -c -u $USER $EXE ) instance(s)"
        else
            echo "$EXE:  $(pgrep -c $EXE ) instance(s)" 
        fi
        ((i++))
    done  
fi


 