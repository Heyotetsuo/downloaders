#!/usr/bin/env bash

cd "$( dirname "$0" )";

if [ -z "$1" ];
then
	echo 'Not enough arguments';
	echo 'Usage: ./dl-section.sh [url]';
	exit;
fi;

data="$( curl -vL "$1" 2>&1 )";
url="$(
	grep -o 'location: .*' <<< "$data" |
	sed 's/^location: //' |
	tr -d '\r\n';
)";
id="$(
	grep -o '/[^/]*/online-view' <<< "$url" |
	sed 's/online-view//' |
	tr -d '/\r\n'
)";
booktitle="$(
	grep -o 'core/books/[^/]*/' <<< "$url" |
	sed 's/^core\/books\///;' |
	tr -d '/\r\n'
)";
sectitle="$(
	grep -o '/[^/]*/'"$id" <<< "$url" |
	sed 's/\/'"$id"'$//' |
	tr -d '/\r\n'
)";

if [ -f "$booktitle/$sectitle" ];
then
	echo "Skipping $sectitle ...";
	exit;
fi;

echo "downloading https://www.cambridge.org$url ...";
curl "https://www.cambridge.org/core/services/online-view/get/$id" \
	-H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0 IceDragon/65.0.2" \
	-H "Accept: */*" \
	-H "Accept-Language: en-US,en;q=0.5" --compressed \
	-H "Referer: https://www.cambridge.org$url" \
	-H "X-Requested-With: XMLHttpRequest" \
	-H "Connection: keep-alive" \
	-H "Cookie: __cfduid=d2383271c98f2b3f5e44eaf564a1e959a1584501084; session=s"%"3AWvuLIxbdX3rdPKmsf4iULthsrI8gaJ_I.sB4jR0gdzYw9X6IAWtg4QpBtJll1EUQFCHgR5XkxAgQ; AWSELB=7F6109AF060F80A7A44D632B0C9B0D82B82BDA026D19DC3F3AB2A23F70D55BC13B59C3064ED6A9089DF29AED5B15C07A687C904EAA86D35AA4566619DB1586128530BD877073CB63298FDACCD54989CD9D62E683A6; __atuvc=12"%"7C12; __atssc=twitter"%"3B2; _ga=GA1.2.718934658.1584501087; _gid=GA1.2.1492710814.1584501087; _gat=1" \
	-H "Cache-Control: max-age=0" \
	-H "TE: Trailers" > "$booktitle/$sectitle".html;
