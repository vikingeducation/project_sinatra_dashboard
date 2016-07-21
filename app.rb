require 'sinatra'
require 'erb'
require './helpers/script.rb'

helpers ScraperHelper

get '/' do
  erb :index
end

post '/' do
  query = params[:keyword]
  location = params[:location]
  scraper = DiceScraper.new(query, location)
  job_hash = scraper.run
end