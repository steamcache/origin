#!/bin/sh

if [[ "$1" == "" ]]; then
	BEATTIME="3600"
else
	BEATTIME=$1
	if [[ "$1" == 0 ]]; then 
		exit 0;
	fi
fi


while [ 1 ]; do
    sleep $BEATTIME;
	wget http://127.0.0.1/heatbeat -O /dev/null > /dev/null 2>&1
done
