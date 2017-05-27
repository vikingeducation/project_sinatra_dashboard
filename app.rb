require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

require './helpers/job_site_scraper'

get '/' do
  erb :index
end

get "/search" do
  job_search_term = params[:job_search_term]
  job_location = params[:job_location]

  scraper = JobSiteScraper.new
  job_postings = scraper.scrape_job_postings(job_search_term, job_location)

  erb :index, locals: { job_postings: job_postings }
end
