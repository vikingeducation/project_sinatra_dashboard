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
  # store location info in two session variables
  unless session["location"]
    # @ip_address = request.ip
    get_location
  end
  erb :index, locals: {location: session["location"], results: CSV.read("combined_results.csv")}
end

post '/search' do
  # collects search term from user input
  # gets location and passes it to scraper
  search_term = params[:search_term]
  
  # scrapes site
  get_jobs(search_term, session["zip_code"])
  # redirect to('/')
  erb :index, locals: {location: session["zip_code"], results: CSV.read("combined_results.csv")}
end
