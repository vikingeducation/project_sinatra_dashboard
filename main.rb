require 'sinatra'
require 'sinatra/reloader'
require './scrape.rb'
require './locator.rb'
require './glassdoor.rb'
require './nyt_scraper.rb'
require './helpers.rb'

helpers RequestHelper

#display the index page
get '/index' do
  erb :index, locals: {results: nil, loc: nil}
end

# When posting, scrape from dice.com then display to user.
post '/index' do
  # get_ip wraps around request.ip so if we're running locally we don't get an invalid
  # local ip address.
  ip = get_ip(request.ip)
  search_loc = get_location(params[:location], ip)
  scraper = DiceScraper.new

  results = scraper.search_jobs(params[:title], search_loc)
  location = location_string(search_loc)
  erb :index, locals: {results: results, loc: location}
end

get '/info/:name' do
  gscraper = GlassDoorScraper.new
  company_info = gscraper.get_employer(params[:name], request.ip)
  nytscraper = NewYorkTimesScraper.new
  news = nytscraper.get_articles(params[:name])
  erb :info, locals: {result: params[:name], company_info: company_info, news: news}
end

post '/info' do
  gscraper = GlassDoorScraper.new
  nytscraper = NewYorkTimesScraper.new
  company_info = gscraper.get_employer(params["info"], request.ip)
  news = nytscraper.get_articles(params["info"])
  erb :info, locals: {result: params[:info], company_info: company_info, news: news}
end