require "sinatra"
require "erb"
require "json"
require_relative "scraper"
require_relative "locator"
require_relative "company_profiler"

require "sinatra/reloader" if development?
require "pp" if development?

use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :secret => 'your_secret'


# ------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------

helpers do
  def urlize(s)
    s.gsub(/\s/, "+")
  end
end

def load_location
  session[:location] && JSON.parse(session[:location])
end

def save_location(l)
  session[:location] = l.to_json
end

def resolve_ip(ip)
  ip == "::1" ? "177.155.221.208" : ip
end

def get_location(ip)
  location = load_location
  return location if location
  ip = "177.155.221.208" if ip.to_s == "::1"
  location = Locator.new.location(ip)
  save_location(location)
  location
end

def save_featured_reviews!(company, profile)
  if profile["success"]
    profile = profile["response"]
    unless profile["employers"].empty?
      featured_reviews = profile["employers"].select{ |e| e["featuredReview"] }
      unless featured_reviews.empty?
        featured_reviews.map!{ |e| e["featuredReview"] }
        session[company] = featured_reviews
      end
    end
  end
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



get "/company-profile" do
  company = params["company_name"]
  ip = resolve_ip(request.ip)
  # remove id and key!
  opts = {ip: ip, id: 134984, key: "fQ4JYfEDT3Q", company: company}
  profile = CompanyProfiler.new.profile(opts)
  save_featured_reviews!(company, profile)
  locals = {locals: {search: company, profiles: profile["response"]["employers"]}}
  erb :company_profile, locals
end
