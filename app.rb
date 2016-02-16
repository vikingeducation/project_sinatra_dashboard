=begin

=end

# 3. Refreshing the page should kick off scraping operations.
# IT works but because the scraping takes so long, the page doesn't load, do you need to have the erb on the bottom?

require 'rubygems'
require 'bundler/setup'
require './assignment_web_scraper/lib/dice_scraper'
require './free_geo/free_geo_ip.rb'
require './glassdoor/glassdoor_api.rb'
Bundler.require(:default)

helpers do

  # Getting the user's IP.
  # If in development mode, we just set it to a static San Francisco IP
  # Else we get the user's ip
  # Stored in session
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
  company_hash={}
  search_topic = params[:search_topic]
  results = DiceScraper.new(search_topic, session["zip_code"]).get_results_array
  results.each do |result|
    company_details = Glassdoor.new.get_employer_details(session["ip"], session["user_agent"], result[1], session["country"])
    company_details["response"]["employers"].each do |company|
      if company["name"].upcase == result[1].upcase && company_hash[result[-2]] == nil
        company_hash[result[-2]] = {
          "id" => company["id"],
          "name" => company["name"],
          "numberOfRatings" => company["numberOfRatings"],
          "overallRating" => company["overallRating"],
          "cultureAndValuesRating" => company["cultureAndValuesRating"],
          "workLifeBalanceRating" => company["workLifeBalanceRating"],
          "recommendToFriendRating" => company["recommendToFriendRating"]
        }
      end
    end
  end
  company_hash
  erb :index, locals: {searched: true, results: results, zip: session["zip_code"], city: session["city"], state: session["state"], country: session["country"], company_hash: company_hash}
end
