require 'sinatra'
require 'sinatra/reloader' if development?
require 'erb'
require 'pry-byebug'

require './helpers/job_dashboard_helpers'
require './helpers/job_site_scraper'

helpers JobDashboardHelpers

enable :sessions

get '/' do
  visitor_location = load_visitor(request_ip)
  city = visitor_location[0]
  country = visitor_location[1]

  locals = {
    request_ip: request_ip,
    city: city,
    country: country
  }

  save_visitor(city, country)

  erb :index, locals: locals
end

get "/search" do
  job_search_term = params[:job_search_term]
  job_location = params[:job_location]

  visitor_location = load_visitor(request_ip)
  city = visitor_location[0]
  country = visitor_location[1]

  scraper = JobSiteScraper.new
  job_postings = scraper.scrape_job_postings(job_search_term, job_location)

  locals = {
    request_ip: request_ip,
    city: city,
    country: country,
    job_postings: job_postings
  }

  erb :index, locals: locals
end
