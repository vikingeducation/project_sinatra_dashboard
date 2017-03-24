require "sinatra"
require "erb"
require "json"
require_relative "scraper"
require_relative "locator"

require "sinatra/reloader" if development?
require "pp" if development?

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'


# ------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------

def load_location
  session[:location] && JSON.parse(session[:location])
end

def save_location(l)
  session[:location] = l.to_json
end

def get_location(ip)
  location = load_location
  return location if location
  ip = "177.155.221.208" if ip.to_s == "::1"
  location = Locator.new.location(ip)
  save_location(location)
  location
end

# ------------------------------------------------------------------------
# Routes
# ------------------------------------------------------------------------

get "/" do
  erb :index
end

post "/" do
  location = get_location(request.ip)
  scraper = Scraper.new
  option = params[:scrape].to_i
  result = scraper.scrape_first_page if option == 1
  result = scraper.scrape_since(Time.now) if option == 2
  locals = {locals: {result: result}}
  erb :result, locals
end
