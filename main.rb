require 'sinatra'
require 'csv'
require 'pry'
require './scrape.rb'
require './locator.rb'

helpers do
  def location_string(loc)
    unless loc == ""
      return "Searching for jobs in #{loc}."
    else
      return "Searching for jobs..."
    end
  end

  def get_location(loc, ip)
    return loc unless loc.empty?
    locator = Locator.new
    res = locator.find(ip)
    return res unless locator.find(ip).nil?
    return ""
  end
end

get '/index' do
  erb :index, locals: {results: nil, loc: nil}
end

post '/index' do
  search_title = params[:title]
  search_loc = get_location(params[:location], request.ip)
  scraper = DiceScraper.new
  results = scraper.search_jobs(search_title, search_loc)
  # binding.pry
  location = location_string(search_loc)
  erb :index, locals: {results: results, loc: location}
end

