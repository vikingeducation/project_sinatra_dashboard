require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/weather_scraper.rb'

enable :sessions
set :server, 'thin'

get '/' do
  :home
end

# get '/index' do
#   erb :index
# end

post '/index' do
  session[:weather_scraper] = WeatherScraper.new("Oakland, California")
  redirect to "results"
end