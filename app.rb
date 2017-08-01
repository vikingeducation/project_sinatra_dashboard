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
  find_jobs(search_params)
  @csv_table = CSV.open("jobs.csv")
  erb :results
end
