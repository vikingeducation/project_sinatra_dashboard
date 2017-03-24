require "sinatra"
require "sinatra/reloader" if development?
require "erb"
require_relative "scraper"
require "json"
require "pp"

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'

class Locator
  attr_accessor :agent

  BASE_URI = "http://freegeoip.net"

  def initialize
    @agent = Mechanize.new
  end

  def from_ip(ip)
    url = [BASE_URI, "json", ip].join("/")
    page = agent.get(url)
    JSON.parse(page.body)
  end

  def location(ip)
    d = from_ip(ip)
    [d["city"], d["region_name"], d["country_name"]].join(", ")
  end

end

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
