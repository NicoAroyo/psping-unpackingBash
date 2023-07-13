#!/bin/bash

COUNT=-1
TIME=1
TIMEOUT_TIME=1
USER=''


#I misunderstood the -t as timeout time and not interval time 
#kept the timeout option as -i :) 
#I also fixed USER to not retain a previous value
 timeout() {
     local TIME=$1 
     sleep $TIME 
     kill -s TERM $$
 } 
 
while getopts "c:t:u:i:" opt; do
    case $opt in
        c)
            if [[ $OPTARG =~ ^[0-9]+$ ]]; then
                COUNT=$OPTARG
            fi
            ;;
        t) 
            if [[ $OPTARG =~ ^[0-9]+$ ]]; then
                TIME=$OPTARG
            fi 
        ;;
        u) 
            USER=$OPTARG
        ;;  
        i) 
            if [[ $OPTARG =~ ^[0-9]+$ ]]; then
                TIMEOUT_TIME=$OPTARG
            fi
            timeout $TIMEOUT_TIME &
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

if [[ -n $USER ]]; then 
    echo "pinging $EXE for $USER"
else 
    echo "pinging $EXE" 
fi

i=0

if [ "$COUNT" -eq -1 ]; then
    while true; do
        if [[ -n $USER ]]; then 
            echo "$EXE:  $(pgrep -c -u $USER $EXE ) instance(s)"
        else
            echo "$EXE:  $(pgrep -c $EXE ) instance(s)"   
        fi
        sleep $TIME
    done 
elif [ "$COUNT" -ne -1 ]; then
    while [ $i -ne $COUNT ]; do
        if [[ -n $USER ]]; then 
            echo "$EXE:  $(pgrep -c -u $USER $EXE ) instance(s)"
        else
            echo "$EXE:  $(pgrep -c $EXE ) instance(s)" 
        fi
        sleep $TIME
        ((i++))

    done  
fi


 