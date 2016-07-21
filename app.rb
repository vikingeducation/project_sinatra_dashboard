require 'sinatra'
require 'sinatra/reloader' if development?
require './assignment_web_scraper/lib/scraper.rb'


get '/index' do
  erb :index
end

post '/index' do 
  position = params[:position]
  location = params[:location]
  erb :index, locals: {position: position, location: location}
end
