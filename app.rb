require 'sinatra'
require 'erb'
require 'thin'
#require './locator.rb'
#require './dice_scraper.rb'
#require './company_profiler.rb'

require './helpers/app_helper.rb'

helpers AppHelper


get "/" do

  location = session_location

  results = run_search(location)

  add_profiles!(results)


  erb :index, :locals => { :results => results, :today => Date.today }
end