require 'sinatra'
require './dice_scraper.rb'


get '/' do 
  erb :index
end

post '/' do
  job_title = params[:job_title]
  location = params[:location]
  scraper = DiceScraper.new(job_title, location)
  result_array = scraper.create_listings_array
  erb :results, locals: {:result_array => result_array}

end
