require 'sinatra'
require './dice_scraper.rb'
require 'httparty'
require 'pry-byebug'

helpers do
  @fake_ip = '40.138.174.92'

  def make_free_geo_url(ip)
    "http://freegeoip.net/json/#{ip}"
  end

  def get_loc_data(ip)
    url = make_free_geo_url(ip)
    result = HTTParty.get(url)
  end
end

get '/' do
  erb :index
end

post '/' do
  job_title = params[:job_title]
  location = params[:location]
  loc_data = get_loc_data('40.138.174.92')

  scraper = DiceScraper.new(job_title, loc_data)
  result_array = scraper.create_listings_array.compact
  erb :results, locals: {:result_array => result_array, :city => loc_data['city'], :state => loc_data['state']}
end
