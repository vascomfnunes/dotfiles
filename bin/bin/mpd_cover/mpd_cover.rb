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
require 'time'

# Spotify keys should be exported in the shell as environment variables
client_id = ENV['SPOTIFY_CLIENT_ID']
client_secret = ENV['SPOTIFY_CLIENT_SECRET']

def no_cover_data(playing)
  clear_screen
  puts 'No cover art available.'.red
  green 'Artist:'
  puts playing[0]
  green 'Track:'
  puts playing[1]
end

def not_playing
  clear_screen
  puts 'MPD not playing.'.yellow
end

def green(string, initial_break: true)
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

begin
  RSpotify.authenticate(client_id, client_secret)
rescue StandardError
  puts 'Spotify authentication failed. Missing credentials?'
  exit
end

clear_screen
puts 'Waiting for next MPD change...'.yellow

# Infinite loop to intercept mpd changes
Kernel.loop do
  `mpc idle`
  playing = now_playing

  if playing.empty?
    not_playing
    next
  end

  begin
    result = RSpotify::Track.search("track:#{playing[1]}+artist:#{playing[0]}", limit: 1)[0]
  rescue StandardError
    result = nil
  end

  if result.nil? || result.album.nil?
    no_cover_data now_playing
  else
    clear_screen
    album = result.album
    `kitty +kitten icat --align left --silent #{album.images[0]['url']}`
    green 'Artist:', initial_break: false
    puts album.artists[0].name
    green 'Track:'
    puts result.name
    green 'Album:'
    puts album.name
    green 'Release date:'
    puts format_date(album.release_date)
    green 'Spotify:'
    puts ShortURL.shorten(album.external_urls['spotify'])
  end
rescue Interrupt
  puts "\nExiting...".green
  exit
end
