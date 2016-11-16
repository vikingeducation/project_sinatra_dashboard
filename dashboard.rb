#!/usr/bin/env ruby

require 'erb'
require 'sinatra'
require 'sinatra/reloader'
require_relative 'figaro_file'
require_relative './assignment_web_scraper/lib/dice_scraper_controller'

get '/' do

  terms    = params[:terms]
  location = params[:location]

  if terms && location
    jobs = DiceScraperController.new.search(terms, location)
  end

  erb :index, locals: { jobs: jobs,
                              terms:    terms,
                              location: location }
end
