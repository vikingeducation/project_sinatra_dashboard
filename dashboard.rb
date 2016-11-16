#!/usr/bin/env ruby

require 'erb'
require 'sinatra'
require 'sinatra/reloader'
require_relative 'figaro_file'
require_relative './assignment_web_scraper/lib/dice_scraper_controller'

get '/' do
  erb :index
end

get '/search_results' do
  search_terms = params[:search_terms]
  location     = params[:location]
  jobs = DiceScraperController.new.search(search_terms, location)

  erb :search_results, locals: { jobs:     jobs,
                                 search_terms:    search_terms,
                                 location: location }
end
