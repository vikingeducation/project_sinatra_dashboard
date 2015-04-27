require 'sinatra'
require './helpers/weather_scrape.rb'
require './helpers/craig_scrape.rb'

set :server, 'thin'

get '/' do
  @forecast = WeatherScraper.new
  @craig = CraigScraper.new(1000, 3000, 'family')
  erb :main
end
