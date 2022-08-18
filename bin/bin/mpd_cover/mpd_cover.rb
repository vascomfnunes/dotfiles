#!/usr/bin/env ruby

# Copyright 2022 Vasco Nunes
#
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

# A tiny ruby script to fetch the album cover art
# for the currently playing song on MPD
# (using Spotify API) and display it on a kitty terminal window.
#
# Requires a MPD server and the mpc tool both installed
#
# ** ONLY WORKS ON A KITTY TERMINAL **

require 'colorize'
require 'rspotify'
require 'shorturl'

# Spotify keys should be exported in the shell as environment variables
client_id = ENV['SPOTIFY_CLIENT_ID']
client_secret = ENV['SPOTIFY_CLIENT_SECRET']

def no_data
  puts `clear`
  puts 'No data available.'.red
end

def green(string)
  puts "\n#{string}".green
end

RSpotify.authenticate(client_id, client_secret)

# Infinite loop to intercept mpd changes
Kernel.loop do
  `mpc idle`
  playing = `mpc current | awk -F':' '{print $NF}' | awk '{$1=$1};1'`

  if playing == ''
    no_data
    next
  end

  result = RSpotify::Track.search(playing, limit: 1)[0]

  puts `clear`

  if result.nil?
    no_data
  else
    album = result.album
    `kitty +kitten icat --align left --silent #{album.images[0]['url']}`
    green 'Artist:'
    puts album.artists[0].name
    green 'Track:'
    puts result.name
    green 'Album:'
    puts album.name
    green 'Release date:'
    puts album.release_date
    green 'Spotify:'
    puts ShortURL.shorten(result.album.external_urls['spotify'])
  end
end
