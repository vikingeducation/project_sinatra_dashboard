require 'sinatra'
require 'erb'
require 'thin'
#require './locator.rb'

require './helpers/scraper_helper.rb'
helpers ScraperHelper

get "/" do

  if session[:zip].nil?
    locator = Locator.new
    location = locator.fetch_location
    session[:zip] = location
  end

  location = session[:zip]

  scraper = ScraperHelper::DiceScraper.new

  if params.nil?
    results = scraper.search(location)
  else
    results = scraper.search_with_params(params, location)
  end

  erb :index, :locals => { :results => results, :today => Date.today }
end