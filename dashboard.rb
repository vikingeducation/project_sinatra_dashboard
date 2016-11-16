#!/usr/bin/env ruby

require 'erb'
require 'figaro'
require 'sinatra'
require 'sinatra/reloader'
require_relative './dice_scraper/lib/dice_scraper_controller'

get '/' do
  erb :index
end

post '/search_results' do
  search_terms = params[:search_terms]
  location     = params[:location]
  erb :search_results, locals: { terms:    search_terms,
                                 location: location }
end
