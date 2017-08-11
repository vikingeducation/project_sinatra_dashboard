# app.rb
require 'sinatra'
require 'erb'
require 'sinatra/reloader'
require 'pry-byebug'
require './models/dice_scraper.rb'

enable :sessions

get '/' do
  erb :index, locals: {scrape_results: session["results"]}
end

post '/search' do
  # collects search term from user input
  j = JobScraper.new
  j.scrape
  # gets location and passes it to scraper
  redirect to('/')
end
