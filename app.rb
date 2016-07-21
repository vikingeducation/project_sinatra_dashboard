require 'sinatra'
require 'sinatra/reloader' if development?
require './assignment_web_scraper/lib/scraper.rb'

enable :sessions


helpers Locator

get '/' do 
  session[:json] ||= Locator.new("108.51.25.16")
  erb :index, locals: {position: nil, location: nil, json: session[:json]}

end

post '/' do
  position = params[:position]
  location = params[:location]
  limit = params[:limit]
  erb :index, locals: {position: position, location: location, limit: limit}
end
