require 'sinatra'
require './dice_scraper.rb'
require 'httparty'
# require 'pry-byebug'

helpers do
  @fake_ip = '40.138.174.92'

  def make_free_geo_url(ip)
    "http://freegeoip.net/json/#{ip}"
  end

  def get_loc_data(ip)
    url = make_free_geo_url(ip)
    JSON.parse(HTTParty.get(url))['zip_code']
  end
end

get '/' do
  erb :index
end

post '/' do
  job_title = params[:job_title]
  location = params[:location]
  scraper = DiceScraper.new(job_title, location)
  result_array = scraper.create_listings_array.compact
  loc_data = get_loc_data(@fake_ip)
  # binding.pry
  erb :results, locals: {:result_array => result_array, :loc_data => loc_data}
end
