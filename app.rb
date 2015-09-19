#!/usr/bin/env ruby
require './dice_scraper'
require 'sinatra'
require 'sinatra/reloader' if development?

get '/' do
  erb :home
end


post '/search' do
  @keywords = params[:keywords].split(" ")
  @zipcodes = params[:zipcodes].split(" ")

  #DiceScraper.new(@keywords, @zipcodes).build_csv
  @results = CSV.read('jobs.csv', headers:true)

  erb :home
end