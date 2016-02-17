# 3. Refreshing the page should kick off scraping operations.
# IT works but because the scraping takes so long, the page doesn't load, do you need to have the erb on the bottom?

require 'rubygems'
require 'bundler/setup'
require './web_scraper/dice_scraper.rb'
require './free_geo/free_geo_ip.rb'
require './glassdoor/glassdoor_api.rb'
Bundler.require(:default)

helpers do

  # Getting the user's IP.
  # If in development mode, we just set it to a static San Francisco IP
  # Else we get the user's ip
  # Stored in session
  # I put this in a helper because I thought it might be needed on other pages depending on where the user comes from.
  def get_ip
    if Sinatra::Base::development?
      session["ip"] = "136.0.16.217"
    else
      session["ip"] =  request.ip
    end
  end

end

enable :sessions

get '/' do
  redirect '/index'
end

get '/index' do
  get_ip if session["ip"] == nil
  session["user_agent"] = request.user_agent if session["user_agent"] == nil
  if session["country"] == nil
    location = IPLocator.new.get_user_location_details(session["ip"])
    session["zip_code"] = location["zip_code"]
    session["city"] = location["city"]
    session["state"] = location["region_code"]
    session["country"] = location["country_name"]
  end
  erb :index, locals: {searched: false}
end

post '/index' do
  # Getting our Dicescrape results for display on page and also for Glassdoor to use.
  results = DiceScraper.new(params[:search_topic], session["zip_code"]).get_results_array

  # Need to get a hash full of company reviews from glassdoor. That way we can use logic in the erb page to display those columns in the table as well.
  company_hash=Glassdoor.new.get_company_hash(results, session["ip"], session["user_agent"])

  erb :index, locals: {searched: true, results: results, zip: session["zip_code"], city: session["city"], state: session["state"], country: session["country"], company_hash: company_hash}
end
