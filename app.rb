require 'sinatra'
require 'json'
require 'erb'
require 'csv'
require './modules/scraper.rb'
require './helpers/helper_methods.rb'
require 'sinatra/reloader' if development?
require 'pry-byebug' if development?

enable :sessions


get '/' do
  erb :search_form
end

post '/search' do
  # pausing scraping during development
  # options = search_params
  # find_jobs(options)
  erb :search_complete
end

get '/search' do
  @csv_table = CSV.open("jobs.csv", :headers => true).read
  erb :results
end
