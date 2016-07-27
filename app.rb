require "sinatra"
require "sinatra/reloader"
require "erb"
require "./helpers/dash_help.rb"

helpers Dash

enable :sessions

get '/' do
  # session["ip"] = request.ip
  session["location"] = get_loc("24.156.10.54") if !session["location"].is_a?(String)
  erb :index
end

post '/' do
  @query = params["query"]
  # @location = params["location"]
  # @ip = request.ip
  @location = session["location"]
  scrape(@query, @location)
  add_info
  @reviews = session["reviews"]
  @string = table
  erb :results
end
