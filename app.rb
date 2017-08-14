# app.rb
require 'sinatra'
require 'erb'
require 'sinatra/reloader'
require 'httparty'
require 'pry-byebug'
require './models/dice_scraper.rb'
require './helpers/scraper_helper.rb'

enable :sessions
helpers ScraperHelper

get '/' do

  unless session["location"]
    session["location"] = get_location
  end
  erb :index, locals: {location: session["location"]}
end

post '/search' do
  # collects search term from user input
  # gets location and passes it to scraper

  search_term = params[:search_term]

  # @ip_address = request.ip
  @ip_address = "50.22.219.2"
  location = get_zip


  # scrapes site
  j = JobScraper.new(search_term, location)
  # j.scrape
  redirect to('/')
end
