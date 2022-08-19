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

def no_data(playing)
  puts `clear`
  puts 'No cover art available.'.red
  green 'Artist:'
  puts playing[0]
  green 'Track:'
  puts playing[1]
end

def green(string)
  puts "\n#{string}".green
end

def now_playing
  playing = `mpc current | awk -F':' '{print $NF}' | awk '{$1=$1};1'`
  playing.split(' - ')
end

begin
  RSpotify.authenticate(client_id, client_secret)
rescue StandardError
  puts 'Spotify authentication failed. Missing credentials?'
  exit
end

# Infinite loop to intercept mpd changes
Kernel.loop do
  `mpc idle`
  playing = now_playing

  if playing == ''
    no_data
    next
  end

  result = RSpotify::Track.search("track:#{playing[1]}+artist:#{playing[0]}", limit: 1)[0]
  puts `clear`

  if result.nil?
    no_data(playing)
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
