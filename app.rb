require "sinatra"
require "sinatra/reloader" if development?
require_relative './web_scraper'


get "/" do
  job_keyword = params[:job]
  job_location = params[:location]
  job_type = params[:type]

  erb :index

end


post '/job_search' do

  #WebScraper.new.search_query(job_keyword, job_location, job_type)
  #web_scraper.loop_through_job_links
  #web_scraper.write_csv

  erb :job_search, locals: {
    job: job_keyword, 
    location: job_location,
    type: job_type
  }

end