require 'sinatra'
require 'erb'
require 'thin'
require './locator.rb'

require './helpers/scraper_helper.rb'
helpers ScraperHelper

get "/" do
  #locator = Locator.new
  #location = locator.fetch_location
  #params[:'search-location'] = location if params.nil?

  scraper = ScraperHelper::DiceScraper.new

  results = scraper.search(params)

  erb :index, :locals => { :results => results, :today => Date.today }
end