require 'sinatra'
require './dice_scraper.rb'
# require 'pry-byebug'


get '/' do 
  erb :index
end

post '/' do
  job_title = params[:job_title]
  location = params[:location]
  scraper = DiceScraper.new(job_title, location)
  result_array = scraper.create_listings_array.compact
  # binding.pry
  erb :results, locals: {:result_array => result_array}
end
