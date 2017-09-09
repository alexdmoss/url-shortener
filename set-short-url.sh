#!/usr/bin/env bash
#
# [ADM, 2017-09-08] set-short-urls.sh <long-url-to-shorten>
#
# Reads a saved API key and fires a request to the Google URL Shortener API
# to create a short url specified as the only argument.

API_KEY_FILE=secrets/url-shortener.key
API_URL=https://www.googleapis.com/urlshortener/v1/url
API_KEY=$(cat $API_KEY_FILE)

LONG_URL=$1

curl --silent ${API_URL}?key={$API_KEY} \
  -H 'Content-Type: application/json' \
  -d '{"longUrl": "'${LONG_URL}'"}' | jq .
