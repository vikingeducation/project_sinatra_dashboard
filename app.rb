require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry'

# Classes
require './models/job.rb'
require './models/scraper.rb'

# Routes
enable :sessions

get '/' do
  # Build objects
  # scraper = Scraper.new('https://www.dice.com')
  # scraper.scrape(title: 'Ruby on Rails Engineer', location: 'New Orleans, LA', name: 'Anne')
  # scraper.scrape(title: 'Data Analyst Business Analyst', location: 'New Orleans, LA', name: 'Josh')

  # Modify objects

  # Save objects to session

  # Output data to view
  erb :index
end