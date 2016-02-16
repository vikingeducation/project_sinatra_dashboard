=begin
  Displaying Your Scrape

  To start, display the data you scraped from your original Mechanize scraper from the scraping assignment by pulling that code in from your previous repo and getting it working in a new Sinatra App.

  1. Set up a basic Sinatra app with a Gemfile. (DONE)

  2. Build the core view layout (DONE)
  and the index.erb template (the home page) which will display the information you want. (DONE)

  3. Refreshing the page should kick off scraping operations.

  4. There should be a form for your search query, which tells the scraper what to search for.

  5. Display your job hunt data in a table on the page.

  6. Load Bootstrap into your Sinatra app and use it to put some bare-bones styling around the job hunt widget you built. Look into Bootstrap's table styling classes -- they are very easy to use.
=end

# 3. Refreshing the page should kick off scraping operations.
# IT works but because the scraping takes so long, the page doesn't load, do you need to have the erb on the bottom?

require 'rubygems'
require 'bundler/setup'
require './assignment_web_scraper/lib/dice_scraper'
require './free_geo/free_geo_ip.rb'
Bundler.require(:default)

helpers do

  def get_ip
    if Sinatra::Base::development?
      session["ip"] = "202.86.32.122"
    else
      session["ip"] =  request.ip
    end
  end

end

enable :sessions

get '/' do
  get_ip if session["ip"] == nil
  redirect '/index'
end

get '/index' do
  get_ip if session["ip"] == nil
  if session["country"] == nil
    location = IPLocator.new.get_user_location_details(session["ip"])
    session["zip_code"] = location["zip_code"]
    session["city"] = location["city"]
    session["state"] = location["region_code"]
    session["country"] = location["country_name"]
  end
  erb :index, locals: {searched: false, zip: session["zip_code"], city: session["city"], state: session["state"], country: session["country"]}
end

post '/index' do
  search_topic = params[:search_topic]
  results = DiceScraper.new(search_topic).get_results_array
  erb :index, locals: {searched: true, results: results}
end
