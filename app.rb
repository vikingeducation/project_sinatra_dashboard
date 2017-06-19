# Web scraper with Sinatra
require "sinatra"
require "sinatra/reloader" if development?
require "./models/job_scraper.rb"

# helpers ScraperHelper

enable :sessions

get '/' do
  # For each new game, clear any active sessions
  session.clear 
  erb :index
end

get '/search' do
  search_term = params[:search_terms]
  location = params[:location]
  radius = params[:radius]

  job_scraper = JobScraper.new
  postings = job_scraper.create_search(search_term, location, radius)

    locals = {
    location: location,
    postings: postings
  }

  erb :index, locals: locals
end



