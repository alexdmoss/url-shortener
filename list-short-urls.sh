#!/usr/bin/env bash
#
# [ADM, 2017-09-08] list-short-urls.sh
#
# Uses OAuth2.0 to authenticate ourselves for the API, storing in a file to
# avoid repeated re-use.
# Will then display the shortURLs you have set up under the user account you
# chose to authenticate with.
#
# OAuth via curl based heavily on this:
# https://stackoverflow.com/questions/18244110/use-bash-curl-with-oauth-to-return-google-apps-user-account-data

CREDS=secrets/url-shortener.creds
CLIENT_ID=$(cat secrets/url-shortener.client_id)
CLIENT_SECRET=$(cat secrets/url-shortener.secret)

if [ -s ${CREDS} ]; then
  # if we already have a token stored, use it
  . ${CREDS}
  time_now=`date +%s`
else
  scope='https://www.googleapis.com/auth/urlshortener'
  auth_url="https://accounts.google.com/o/oauth2/auth?client_id=${CLIENT_ID}&scope=$scope&response_type=code&redirect_uri=urn:ietf:wg:oauth:2.0:oob"

  # TODO: Future enhancement - avoid break-out into browser - how?
  echo "Please go to:"
  echo
  echo "$auth_url"
  echo
  echo "after accepting, enter the code you are given:"
  read auth_code

  # swap authorization code for access and refresh tokens
  # http://goo.gl/Mu9E5J
  auth_result=$(curl -s https://accounts.google.com/o/oauth2/token \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d code=$auth_code \
    -d client_id=${CLIENT_ID} \
    -d client_secret=${CLIENT_SECRET} \
    -d redirect_uri=urn:ietf:wg:oauth:2.0:oob \
    -d grant_type=authorization_code)

  access_token=$(echo -e "$auth_result" | jq . | grep access_token | awk -F'"' '{print $4}')
  refresh_token=$(echo -e "$auth_result" | jq . | grep refresh_token | awk -F'"' '{print $4}')
  expires_in=$(echo -e "$auth_result" | jq . | grep expires_in | awk -F' ' '{print $3}' | awk -F',' '{print $1}')

  time_now=`date +%s`
  expires_at=$((time_now + expires_in - 60))

  echo -e "access_token=$access_token\nrefresh_token=$refresh_token\nexpires_at=$expires_at" > ${CREDS}

fi

# if our access token is expired, use the refresh token to get a new one
# http://goo.gl/71rN6V
if [ $time_now -gt $expires_at ]; then

  refresh_result=$(curl -s https://accounts.google.com/o/oauth2/token \
                  -H "Content-Type: application/x-www-form-urlencoded" \
                  -d refresh_token=$refresh_token \
                  -d client_id=${CLIENT_ID} \
                  -d client_secret=${CLIENT_SECRET} \
                  -d grant_type=refresh_token)

  time_now=$(date +%s)
  expires_at=$(($time_now + $expires_in - 60))
  echo -e "access_token=$access_token\nrefresh_token=$refresh_token\nexpires_at=$expires_at" > ${CREDS}

fi

# authentication things done - finally! Call the API with our access token
api_data=$(curl -s --get https://www.googleapis.com/urlshortener/v1/url/history \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $access_token")

echo $api_data | jq .
