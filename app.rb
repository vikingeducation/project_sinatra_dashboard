require 'sinatra'
require 'erb'
require 'thin'
require 'pry'
#require './locator.rb'
#require './dice_scraper.rb'
#require './company_profiler.rb'

require './helpers/app_helper.rb'

helpers AppHelper


get "/" do

  location = session_location

  dice_pull = run_search(location)
  #binding.pry

  query = dice_pull[0]
  results = dice_pull[1]

  #results = add_profiles!(dice_results)


  erb :index, :locals => { :query => query, :results => results, :today => Date.today }
end