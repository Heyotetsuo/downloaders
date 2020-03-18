#!/usr/bin/env bash

cd "$( dirname "$0" )";

if [ -z "$1" ];
then
	echo 'Not enough arguments';
	echo 'Usage: ./dl-book.sh [url]';
	exit;
fi;

url="$1";
booktitle="$(
	grep -o '/books/.*' <<< "$url" |
	sed 's/^\/books\///; s/\/[^\/]*$//'
)";
sections="$(
	curl "$url" 2>/dev/null |
	grep -o '/core.*online-view' |
	tail
)";

[ ! -d "$booktitle" ] && mkdir -v "$booktitle";
cd "$booktitle";

while read line;
do
	../dl-section.sh 'https://www.cambridge.org'"$line"
done <<< "$sections";
