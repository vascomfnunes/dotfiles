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

require 'rspotify'
require 'shorturl'
require 'colorize'

# Spotify keys should be exported in the shell as environment variables
client_id = ENV['SPOTIFY_CLIENT_ID']
client_secret = ENV['SPOTIFY_CLIENT_SECRET']

RSpotify.authenticate(client_id, client_secret)

# Infinite loop to intercept mpd changes
Kernel.loop do
  `mpc idle`
  playing = `mpc current | awk -F':' '{print $NF}' | awk '{$1=$1};1'`
  result = RSpotify::Track.search(playing, limit: 1)[0]

  puts `clear`

  if result.nil?
    puts 'No data available.'.red
  else
    album = result.album
    `kitty +kitten icat --align left --silent #{album.images[0]['url']}`
    puts 'Artist:'.green
    puts album.artists[0].name
    puts "\nTrack:".green
    puts result.name
    puts "\nAlbum:".green
    puts album.name
    puts "\nRelease date:".green
    puts album.release_date
    puts "\nSpotify:".green
    puts ShortURL.shorten(result.album.external_urls['spotify'])
  end
end
