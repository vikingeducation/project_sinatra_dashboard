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

  dice_results = run_search(location)

  results = add_profiles!(dice_results)


  erb :index, :locals => { :results => results, :today => Date.today }
end