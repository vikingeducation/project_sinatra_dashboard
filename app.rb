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
    # store location info in two session variables
    get_location
  end
  erb :index, locals: {location: session["location"], results: CSV.read("results.csv")}
end

post '/search' do
  # collects search term from user input
  # gets location and passes it to scraper
  search_term = params[:search_term]

  # @ip_address = request.ip
  # @ip_address = "50.22.219.2"

  # scrapes site
  get_jobs(search_term, session["zip_code"])
  # redirect to('/')
  erb :index, locals: {location: session["zip_code"], results: CSV.read("results.csv")}
end
