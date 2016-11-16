#!/usr/bin/env ruby

require 'erb'
require 'sinatra'
require 'sinatra/reloader'
require_relative './locator/locator'
require_relative 'figaro_file'
require_relative './dice_scraper/lib/dice_scraper_controller'

get '/' do

  terms    = params[:terms]
  location = params[:location] || Locator.get_location#(request.ip)

  if terms && location
    jobs = DiceScraperController.new.search(terms, location)
  end

  erb :index, locals: { jobs:     jobs,
                        terms:    terms,
                        location: location }
end
