#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require_relative 'helpers/dice_scraper_helper'

helpers DiceScraperHelper

get '/' do
  terms = params[:terms]
  location = params[:location]

  # run helper stuff and create a CSV
  erb :index
end
