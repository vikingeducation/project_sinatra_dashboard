require 'sinatra'
require 'sinatra/reloader' if development?
require './assignment_web_scraper/lib/scraper.rb'


get '/index' do
  erb :index, locals: {position: nil, location: nil}
end

post '/index' do
  position = params[:position]
  location = params[:location]
  limit = params[:limit]
  erb :index, locals: {position: position, location: location, limit: limit}
end
