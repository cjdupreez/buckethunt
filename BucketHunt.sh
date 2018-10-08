#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

file="$1"
cat $file | while read line
do
	response=`curl -s https://s3.amazonaws.com/$line/`
	if grep -q "AccessDenied" <<< $response; then
		echo -e "${RED}[-] Public access is denied for: $line${NC}"
	elif grep -q "AllAccessDisabled" <<< $response; then
		echo -e "${RED}[-] All access is disabled for: $line${NC}"
	elif grep -q "NoSuchBucket" <<< $response; then
                echo -e "${RED}[-] This bucket doesn't exist: $line${NC}"
	else
		echo -e "${GREEN}[+] Found a bucket with public listing here: $line${NC}"
	fi
done
