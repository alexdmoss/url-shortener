#!/usr/bin/env bash
#
# [ADM, 2017-09-08] get-short-url.sh <short-url> [<analytics=Y>]
#
# Reads a saved API key and fires a request to the Google URL Shortener API
# to expand a shortened URL.
# Optionally, include a second argument set to Y to display analytics.

API_KEY_FILE=secrets/url-shortener.key
API_URL=https://www.googleapis.com/urlshortener/v1/url
API_KEY=$(cat $API_KEY_FILE)

SHORT_URL=$1

# optionally, add projection=FULL which brings back analytics
if [[ $2 == "Y" ]]; then
  SHORT_URL="$SHORT_URL&projection=FULL"
fi

curl --silent "${API_URL}?key={$API_KEY}&shortUrl=${SHORT_URL}" | jq .
