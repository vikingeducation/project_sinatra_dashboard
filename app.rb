require 'sinatra'
require './helpers/weather_scrape.rb'
require './helpers/craig_scrape.rb'

enable :sessions

set :server, 'thin'

get '/' do
  redirect to '/main'
end

get '/main' do
  erb :main
end

post '/main' do
  session[:min_ask] = params[:min_ask]
  session[:max_ask] = params[:max_ask]
  session[:keywords] = params[:keywords]
  redirect to '/results'
end

get '/results' do
  @forecast = WeatherScraper.new
  @craig = CraigScraper.new(session[:min_ask], session[:max_ask], session[:keywords])
  erb :results
end
