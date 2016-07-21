#app.rb

require 'sinatra'
require 'pry-byebug'
require_relative '../dice_scraper/script'



get '/index' do
  request.ip
  erb :index, locals: {geo_loc: "#{request.ip}"}
end

post '/search' do

  scraper = DiceScraper.new(params[:job],params[:location])
  arr = scraper.find_elements_and_return_links("div#search-results-experiment h3 .dice-btn-link")
  scraper.get_all_company_info(arr)
  jobs = scraper.jobs
  erb :results, locals: {jobs: jobs}

end