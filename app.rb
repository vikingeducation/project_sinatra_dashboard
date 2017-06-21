# Web scraper with Sinatra
require "sinatra"
require "sinatra/reloader" if development?
require "./models/job_scraper.rb"

# helpers ScraperHelper

enable :sessions

get '/' do
  # For each new search, clear any active sessions
  # session.clear 
  erb :index
end

post '/search' do
  search_term = params[:search_terms]
  location = params[:location]
  radius = params[:radius]

  # session[:search_terms] = search_term 
  # session[:location] = location 
  # session[:radius] = radius

  job_scraper = JobScraper.new

  postings = job_scraper.create_search(search_term, location, radius)
  job_scraper.extract_job_details
  job_scraper.csv_file.create_file(job_scraper.results)

    locals = {
    location: location,
    postings: postings
  }

  erb :index, :locals => locals
end





