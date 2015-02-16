require 'sinatra'
require 'erb'
require 'pry-byebug'
require './helpers/weather_scraper.rb'
require './helpers/craigslist_scraper.rb'

enable :sessions
set :server, 'thin'

get '/' do
  erb :home
end

post '/home' do
  session[:location] = params[:location]
  session[:keywords] = params[:keywords]
  session[:min_price] = params[:min_price]
  session[:max_price] = params[:max_price]
  redirect to "/results"
end

get '/results' do
  @w = WeatherScraper.new(session[:location])
  @c = CraigslistScraper.new(session[:min_price], session[:max_price], session[:keywords])
  erb :results
end