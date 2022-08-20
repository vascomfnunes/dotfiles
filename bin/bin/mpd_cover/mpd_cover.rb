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
# ** COVER ART ONLY WORKS ON A KITTY TERMINAL **

require 'colorize'
require 'rspotify'
require 'shorturl'
require 'time'

# Spotify keys should be exported in the shell as environment variables
client_id = ENV['SPOTIFY_CLIENT_ID']
client_secret = ENV['SPOTIFY_CLIENT_SECRET']

def no_cover_data(playing)
  clear_screen
  puts 'No cover art available.'.red
  green_text 'Artist:'
  puts playing[0]
  green_text 'Track:'
  puts playing[1]
end

def not_playing
  clear_screen
  puts 'MPD not playing.'.yellow
end

def green_text(string, initial_break: true)
  puts "#{initial_break ? "\n" : ''}#{string}".green
end

def now_playing(source: `mpc current | awk -F':' '{print $NF}' | awk '{$1=$1};1'`)
  source.split(' - ')
end

def format_date(string)
  Time.parse(string).strftime('%-d %B %Y')
rescue StandardError
  '---'
end

def clear_screen
  puts `clear`
end

def cover_art(image)
  `kitty +kitten icat --align left --silent #{image}`
rescue StandardError
  nil
end

def output_track_info(data)
  album = data.album
  cover_art album.images[0]['url']
  track_info 'Artist', album.artists[0].name, initial_break: false
  track_info 'Track', data.name
  track_info 'Album', album.name
  track_info 'Release date', format_date(album.release_date)
  track_info 'Spotify', ShortURL.shorten(album.external_urls['spotify'])
end

def track_info(type, data, initial_break: true)
  green_text "#{type}:", initial_break: initial_break
  puts data
end

# Entry point

begin
  RSpotify.authenticate(client_id, client_secret)
rescue StandardError
  puts 'Spotify authentication failed. Missing credentials?'.red
  exit
end

clear_screen
puts 'Waiting for next MPD change...'.yellow

# Infinite loop to intercept mpd changes
Kernel.loop do
  # Wait for MPD changes
  `mpc idle`

  if now_playing.empty?
    not_playing
    next
  end

  begin
    track_data = RSpotify::Track.search("track:#{now_playing[1]}+artist:#{now_playing[0]}", limit: 1)[0]
  rescue StandardError
    track_data = nil
  end

  if track_data.nil? || track_data.album.nil?
    no_cover_data now_playing
  else
    clear_screen
    output_track_info track_data
  end
rescue Interrupt
  # Rescue ctr+c
  green_text 'Exiting...'
  exit
end
