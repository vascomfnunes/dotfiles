#!/bin/bash

# parse article with mercury-parser

clear

echo "Parsing the article..."

mercury-parser $1 | jq -r '.content' | w3m -T text/html | vim -
