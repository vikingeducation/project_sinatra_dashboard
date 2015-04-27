require 'sinatra'
require './helpers/weather_scrape.rb'

set :server, 'thin'

get '/' do
  @forecast_table = WeatherScraper.new
  erb :weather
end
