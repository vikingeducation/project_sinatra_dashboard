require 'sinatra'
require './dice_scraper.rb'
require 'httparty'
require 'pry-byebug'

enable :sessions

helpers do
  def make_free_geo_url(ip)
    "http://freegeoip.net/json/#{ip}"
  end

  def get_loc_data(ip)
    url = make_free_geo_url(ip)
    result = HTTParty.get(url)
  end
end

get '/' do
  session['ip_addr'] ||= '40.138.174.92'
  erb :index
end

post '/' do
  job_title = params[:job_title]
  location = params[:location].capitalize
  loc_data = get_loc_data(session['ip_addr'])
  location = loc_data['city'].capitalize + ", " + loc_data['region_name'].capitalize if params[:location].empty?
  scraper = DiceScraper.new(job_title, location)
  result_array = scraper.create_listings_array.compact
  erb :results, locals: {:result_array => result_array, :location => location}
end
