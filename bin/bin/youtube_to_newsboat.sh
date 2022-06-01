#!/bin/bash

# Search term on youtube and save a copy of results
youtube-dl -j "ytsearch1:$*" > /tmp/sub.txt

# Extract relevant details. Some duplication but w/e.
channel_id=$(</tmp/sub.txt jq -r '.channel_id')
channel_url=$(</tmp/sub.txt jq -r '.channel_id' \
| sed 's!^!https://www.youtube.com/feeds/videos.xml?channel_id=!')
channel_name=$(</tmp/sub.txt jq -r '.uploader')

# Add URL to files. Note I have tags for 'exclude' which is filtered from my
# 'news just in' query feed and 'videos' which adds it to my videos query feed.
echo "$channel_url \"Youtube\" \"~$channel_name\"" >> ~/.newsboat/urls

# Inform me of what has happened
echo "Adding $channel_name to Newsboat subscriptions"
