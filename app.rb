require 'sinatra'
require 'erb'
require 'thin'

require './helpers/app_helper.rb'

helpers AppHelper


get "/" do

  ip = request.ip
  location = session_location(ip)

  dice_pull = run_search(location)

  query = dice_pull[0]
  results = dice_pull[1]

  erb :index, :locals => { :query => query, :results => results, :today => Date.today }
end