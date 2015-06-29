require 'sinatra'
require 'erb'
require 'thin'

require './helpers/scraper_helper.rb'
helpers ScraperHelper

get "/" do
  scraper = ScraperHelper::DiceScraper.new

  results = scraper.search(params)

  erb :index, :locals => { :results => results, :today => Date.today }
end