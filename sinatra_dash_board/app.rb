#app.rb

require 'sinatra'
require 'pry-byebug'
require 'httparty'
require_relative '../dice_scraper/script'


class Locator

  attr_reader :location

  def initialize(ip="173.68.17.225")
    @location = HTTParty.get("https://freegeoip.net/json/#{ip}")
  end
end


get '/index' do
  location = (request.ip.to_s.length < 4) ? Locator.new.location : Locator.new(request.ip).location
  erb :index, locals: {geo_city: "#{location["city"]}", 
  geo_state: "#{location["region_code"]}"}
end

post '/search' do

  scraper = DiceScraper.new(params[:job],params[:location])
  arr = scraper.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")
  scraper.get_all_company_info(arr)
  jobs = scraper.jobs
  erb :results, locals: {jobs: jobs}

end