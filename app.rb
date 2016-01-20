#!/usr/bin/env ruby
require 'sinatra'
require "sinatra/reloader" if development?

get '/' do
  erb :index
end


post '/' do
  search_term = params[:search_term]
  time = Time.now - 12 * 3600

  results = scraper_helper(time, search_term)

  erb :index, locals = {results: results}
end
