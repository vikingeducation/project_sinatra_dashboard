#!/usr/bin/env ruby
require 'sinatra'
require "sinatra/reloader" if development?
require './helpers/scraper_helper.rb'
require 'bootstrap'

helpers ScraperHelper

get '/' do

  erb :index, locals: {results: nil}
end


post '/' do
  search_term = params[:search_term]
  time = Time.now - 12 * 3600

  results = scraper_helper(time, search_term)

  erb :index, locals: {results: results}
end
