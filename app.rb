require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/weather_scraper.rb'

enable :sessions
set :server, 'thin'

get '/' do
  erb :home
end

post '/home' do
  session[:location] = params[:location]
  redirect to "/results"
end

get '/results' do
  @w = WeatherScraper.new(session[:location])
  erb :results
end