#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require_relative 'helpers/dice_scraper_helper'

helpers DiceScraperHelper

get '/' do
  "Welcome to our scraper! :D"
end
