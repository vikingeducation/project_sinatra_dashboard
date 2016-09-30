require 'sinatra'
require 'erb'
require 'csv'
require_relative 'helpers/jobsearch_helper.rb'

enable :sessions

get '/' do
  erb :index
end

post '/search' do
  job_keyword = params[:job]
  job_location = params[:location]

  web_scraper = WebScraper.new(job_keyword, job_location)
  web_scraper.loop_through_job
  web_scraper.all_data
  all_data = web_scraper.data
  web_scraper.write_csv
  erb :result, locals: {data: all_data}
end