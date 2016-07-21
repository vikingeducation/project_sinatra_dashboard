require 'sinatra'
require 'sinatra/reloader' if development?
require './assignment_web_scraper/lib/scraper.rb'
require './helpers/locator_helper.rb'

puts "This is process #{Process.pid}"

enable :sessions

helpers LocatorHelper

get '/' do
  session[:json] ||= LocatorHelper::Locator.send_request("108.51.25.16").run.response_body
  erb :index, locals: {position: nil, location: nil, json: session[:json]}

end

post '/index' do
  position = params[:position]
  location = params[:location]
  limit = params[:limit]
  erb :index, locals: {position: position, location: location, limit: limit, json: session[:json]}
end
