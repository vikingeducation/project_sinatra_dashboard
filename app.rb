# app.rb
require 'sinatra'
require 'erb'
require 'sinatra/reloader'
require 'pry-byebug'
require './models/dice_scraper.rb'
require './helpers/scraper_helper.rb'

enable :sessions
helpers ScraperHelper

get '/' do
  erb :index
end

post '/search' do
  # collects search term from user input
  # gets location and passes it to scraper
  search_term = params[:search_term]
  location = coords

  # scrapes site
  j = JobScraper.new(search_term, location)
  j.scrape
  redirect to('/')
end
