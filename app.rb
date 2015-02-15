require 'sinatra'
require 'json'
require 'mechanize'
require './helpers/schwaddyhelper.rb'
require './models/weather.rb'
require './models/inhouseebay.rb'

set :server, "webrick"
helpers Schwaddyhelper
include Schwaddyhelper

enable :sessions



get '/' do
  # binding.pry
  @my_weather = Weather.new("Missoula, MT")
  @my_individualized_weather = @my_weather.ten_day_forecast
  @ebay_results = nil
  
  erb :index
end

post '/ebay' do
  #user inputs last
  @keyword_text = save_keyword( params[:keyword])
  @max_price = save_maxprice( params[:maxprice])
  @ebay_search = InHouseEbay.new(@keyword_text, @max_price)
  @ebay_results = @ebay_search.all_items
  # binding.pry
  @my_weather = Weather.new("Missoula, MT")
  @my_individualized_weather = @my_weather.ten_day_forecast
  erb :index
end

