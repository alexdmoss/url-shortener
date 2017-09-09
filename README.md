# url-shortener

Alex Moss, 9th September 2017

## Description

Experimenting with the Google URL Shortener API

Two different uses:
1. Set and Get Short URLs using the publicly available API. Requires an API key. These are unauthenticated and available to anyone.
2. Set and List Short URLs using individual private data via the same API. These are still publicly callable, but defined under an individual's user account and all shortUrls defined by that user can be listed out. This required setting up an OAuth2.0 clientId, which I wanted to learn how to do! It is not as slick a process (needs a break-out to a browser to authorise) - see To-do!

## Initialisation

1. [manual] Enable the API in gcloud
2. [manual] Get an API Key to identify the call to this API in gcloud

## Audit Trail

Simply using an API key is sufficient if there is no desire to have an audit trail of created shortened URLs.
- if an audit trail is required, then authentication of the calls to insert new shortened URLs is necessary
- authentication also provides access to the list API, which shows all the created URLs for the authenticated user, along with their stats

## Usage

To create a new Shortened URL:

  `./set-short-url.sh <long-url-to-shorten>`
  - JSON response with the auto-generated shortened URL

To get the details of an already Shortened URL:  

  `./set-short-url.sh <short-url>`
  - JSON response with the auto-generated shortened URL
  - must be the full URL including https://goo.gl/

  `./set-short-url.sh <short-url> Y`
  - optional second parameter set to Y brings back all the analytics data for the URL
  - this can be lengthy! Use fields to filter down if desired

## To-do

- Demo with filters on the analytics data
- Figure out how to get the API enabled and API key out of gcloud from the command line / without needing to spawn a browser
